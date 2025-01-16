import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_manager/domain/entities/task_entity.dart';
import 'package:tasks_manager/presentation/blocs/tasks/bloc.dart';
import 'package:tasks_manager/presentation/blocs/tasks/events.dart';
import 'package:tasks_manager/presentation/blocs/tasks/states.dart';

import 'components/particle_app_bar.dart';
import 'demo.dart';

class SwipeScreen extends StatelessWidget {
  const SwipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          ParticleAppBar(),
          Flexible(child: ParticleSwipeDemo()),
        ]),
      ),
      floatingActionButton: Container(
        height:
            MediaQuery.sizeOf(context).height * 0.08, // Adjust size as needed
        width: MediaQuery.sizeOf(context).height * 0.08, // Keep it circular
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), // Circular shape
          gradient: LinearGradient(
            colors: [Color(0xffaa07de), Color(0xffde4ed6)],
          ),
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent, // Transparent to show gradient
          elevation: 0, // Remove shadow to keep style clean
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => GradientPopupDialog(
                isFromUpdate: false,
              ),
            );
          },
          child: Icon(Icons.add), // Replace with desired icon
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class GradientPopupDialog extends StatefulWidget {
  const GradientPopupDialog(
      {super.key,
      required this.isFromUpdate,
      this.title,
      this.content,
      this.id});

  final bool isFromUpdate;
  final String? title;
  final String? content;
  final int? id;

  @override
  State<GradientPopupDialog> createState() => _GradientPopupDialogState();
}

class _GradientPopupDialogState extends State<GradientPopupDialog> {
  final TextEditingController titleTextEditingController =
      TextEditingController();
  final TextEditingController contentTextEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.isFromUpdate) {
      titleTextEditingController.text = widget.title!;
      contentTextEditingController.text = widget.content!;
    }
    super.initState();
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    titleTextEditingController.dispose();
    contentTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Color(0xffaa07de), Color(0xffde4ed6)],
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: titleTextEditingController,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                ),
                decoration: InputDecoration(
                  hintText: 'Enter Title',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: contentTextEditingController,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                ),
                decoration: InputDecoration(
                  hintText: 'Enter Description',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              BlocConsumer<TasksBloc, TasksState>(
                listener: (context, state) {
                  if (state is TasksLoaded) {
                    Navigator.of(context).pop();
                  }
                },
                builder: (context, state) {
                  if (state is TasksLoading) {
                    return CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Perform your task submission logic
                        if (widget.isFromUpdate) {
                          context.read<TasksBloc>().add(
                                UpdateTaskEvent(
                                  Task(
                                    id: 1,
                                    title: 152,
                                    description:
                                        contentTextEditingController.text,
                                    completed: false,
                                  ),
                                  widget.id!,
                                  titleTextEditingController.text,
                                ),
                              );
                          context
                              .read<TasksBloc>()
                              .getTasks(limit: 10, skip: 0);
                        } else {
                          context.read<TasksBloc>().add(
                                AddTaskEvent(
                                  Task(
                                    id: 2,
                                    title: 152,
                                    description:
                                        contentTextEditingController.text,
                                    completed: false,
                                  ),
                                  titleTextEditingController.text,
                                ),
                              );
                          context
                              .read<TasksBloc>()
                              .getTasks(limit: 10, skip: 0);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xffaa07de),
                    ),
                    child: Text('Submit'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
void main() => runApp(App());

class App extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
    ));
    final theme = ThemeData(
      brightness: Brightness.dark,
      canvasColor: Color(0xFF161719),
      textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white, fontFamily: 'OpenSans'),
      iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
    );
    return MaterialApp(
      title: 'Particle Swipe',
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          secondary: Color(0xffc932d9),
        ),
      ),
      home: Scaffold(
        body: SafeArea(
          child: Column(children: [
            ParticleAppBar(),
            Flexible(child: ParticleSwipeDemo()),
          ]),
        ),
      ),
    );
  }
}
*/
