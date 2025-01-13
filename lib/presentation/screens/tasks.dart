import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/di.dart';
import '../../domain/entities/task_entity.dart';
import '../blocs/tasks/bloc.dart';
import '../blocs/tasks/events.dart';
import '../blocs/tasks/states.dart';


class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: BlocProvider(
        create: (context) => getIt<TasksBloc>()..add(const LoadTasks(10, 0)),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<TasksBloc, TasksState>(
                builder: (context, state) {
                  if (state is TasksLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TasksError) {
                    return Center(child: Text(state.message));
                  } else if (state is TasksLoaded) {
                    return ListView.builder(
                      itemCount: state.tasks.length,
                      itemBuilder: (context, index) {
                        final task = state.tasks[index];
                        return ListTile(
                          title: Text(task.title.toString()),
                          subtitle: Text(task.description),
                          trailing: Checkbox(
                            value: task.completed,
                            onChanged: (bool? value) {
                              // Handle task completion
                              context.read<TasksBloc>().add(UpdateTaskEvent(task.copyWith(completed: value!)));
                            },
                          ),
                          onLongPress: () {
                            // Delete task on long press
                            context.read<TasksBloc>().add(DeleteTaskEvent(task.id));
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No tasks available.'));
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Add a new task (for testing)
                  final newTask = Task(
                    id: DateTime.now().millisecondsSinceEpoch,
                    title:500,
                    description: 'Description for new task',
                    completed: false,
                  );
                  context.read<TasksBloc>().add(AddTaskEvent(newTask));
                },
                child: const Text('Add New Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
