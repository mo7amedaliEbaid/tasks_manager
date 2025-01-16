import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_manager/particle_swipe/swipe_main.dart';

import '../presentation/blocs/tasks/bloc.dart';
import '../presentation/blocs/tasks/events.dart';
import '../presentation/blocs/tasks/states.dart';
import 'components/sprite_sheet.dart';
import 'demo_data.dart';
import 'list_model.dart';
import 'particle_field.dart';
import 'particle_field_painter.dart';
import 'removed_swipe_item.dart';
import 'swipe_item.dart';

class ParticleSwipeDemo extends StatefulWidget {
  final List data;

  ParticleSwipeDemo({super.key}) : data = DemoData().getData();

  @override
  State<StatefulWidget> createState() {
    return ParticleSwipeDemoState();
  }
}

class ParticleSwipeDemoState extends State<ParticleSwipeDemo>
    with SingleTickerProviderStateMixin {
  //static const double headerHeight = 80;
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late ListModel _model;
  late SpriteSheet _spriteSheet;
  ParticleField _particleField = ParticleField();
  late Ticker _ticker = createTicker(_particleField.tick);

  @override
  void initState() {
    // Create the "sparkle" sprite sheet for the particles:
    _spriteSheet = SpriteSheet(
      imageProvider: AssetImage(
        "images/circle_spritesheet.png",
      ),
      length: 15, // number of frames in the sprite sheet.
      frameWidth: 10,
      frameHeight: 10,
    );

    // This synchronizes the data with the animated list:
    _model = ListModel(
      initialItems: widget.data,
      listKey: _listKey,
      // ListModel uses this to look up the list its acting on.
      removedItemBuilder: (dynamic removedItem, BuildContext context,
              Animation<double> animation) =>
          RemovedSwipeItem(animation: animation),
    );
    _ticker.start();
    context.read<TasksBloc>().add(LoadTasks(10, 0));
    super.initState();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Draw the header and List UI with a ParticleFieldPainter layered over top:
    return Stack(children: <Widget>[
      _buildList(),
      Positioned.fill(
          child: IgnorePointer(
        child: CustomPaint(
            painter: ParticleFieldPainter(
                field: _particleField, spriteSheet: _spriteSheet)),
      )),
    ]);
  }

  Widget _buildList() {
    return BlocBuilder<TasksBloc, TasksState>(builder: (context, state) {
      if (state is TasksLoaded && state.localTasks.isNotEmpty) {
        return AnimatedList(
          key: _listKey, // used by the ListModel to find this AnimatedList
          initialItemCount: state.localTasks.length,
          physics: ClampingScrollPhysics(),
          itemBuilder: (BuildContext context, int index, _) {
            var item = state.localTasks[index];
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => GradientPopupDialog(
                    isFromUpdate: true,
                    content: item["content"],
                    title: item["title"],
                    id: item["id"],
                  ),
                );
              },
              child: SwipeItem(
                  data: Task(
                      from: item["title"],
                      subject: item["title"],
                      body: item["content"]),
                  isEven: index.isEven,
                  onSwipe: (key, {required action}) => _performSwipeAction(
                      Task(
                          from: item["title"],
                          subject: item["title"],
                          body: item["content"]),
                      key,
                      action,
                      item["id"])),
            );
          },
        );
      }
      if (state is TasksLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is TasksError) {
        return Center(
          child: Text('Error loading tasks'),
        );
      }
      if (state is TasksLoaded && state.localTasks.isEmpty) {
        return Center(
          child: Text('No tasks available'),
        );
      }
      return SizedBox.shrink();
    });
  }

  void _performSwipeAction(
      Task data, GlobalKey key, SwipeAction action, int id) {
    // Get item's render box, and use it to calculate the position for the particle effect:
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      Offset position =
          box.localToGlobal(Offset.zero, ancestor: context.findRenderObject());
      double x = position.dx;
      double y = position.dy;
      double w = box.size.width;

      if (action == SwipeAction.remove) {
        // Delay the start of the effect a little bit, so the item is mostly closed before it begins.
        Future.delayed(Duration(milliseconds: 100))
            .then((_) => _particleField.lineExplosion(x, y, w));

        // Remove the item (using the ItemModel to sync everything), and redraw the UI (to update count):
        setState(() {
          context.read<TasksBloc>().add(DeleteTaskEvent(1, id));
          _model.removeAt(_model.indexOf(data),
              duration: Duration(milliseconds: 200));
          widget.data.remove(data);
        });
      }
      if (action == SwipeAction.favorite) {
        data.toggleFavorite();
        if (data.isFavorite) {
          _particleField.pointExplosion(x + 60, y + 46, 100);
        }
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Task Completed Successfully")));
    }
  }
}
