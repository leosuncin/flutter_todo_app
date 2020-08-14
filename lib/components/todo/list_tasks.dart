import 'package:flutter/material.dart';
import 'package:flutter_todo_app/providers/todo_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo_app/data/todo.dart';

class ListTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
      future: context.watch<TodoList>().fetchTodos(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Wrap(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Unable to load your tasks',
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              );
            }
            var tasks = snapshot.data;

            return tasks.isEmpty
                ? Center(
                    child: Text(
                      'Add a task to start',
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: Icon(
                        tasks.elementAt(index).done
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                      ),
                      title: Text(tasks.elementAt(index).text),
                    ),
                  );

          default:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
