import 'package:flutter/material.dart';
import 'package:tasks/cubit/app_cubit.dart';

class CustomTaskItem extends StatelessWidget {
  const CustomTaskItem({
    super.key,
    required this.tasks,
    this.isDone,
    this.isArchived,
  });

  final Map tasks;
  final bool? isDone;
  final bool? isArchived;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(tasks['id'].toString()),
      onDismissed: (direction) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task ${tasks['title']} deleted successfully'),
            backgroundColor: Colors.grey,
          ),
        );
        AppCubit.get(context).deleteDatabase(id: tasks['id']);
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              tasks['time'],
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tasks['title'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
                Text(
                  tasks['date'],
                  style: const TextStyle(height: 1.5),
                ),
              ],
            ),
          ),
          IconButton(
              iconSize: 32,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Task ${tasks['title']} done successfully'),
                    backgroundColor: Colors.grey,
                  ),
                );
                AppCubit.get(context)
                    .updateDatabase(status: 'done', id: tasks['id']);
              },
              icon: Icon(
                Icons.check_box,
                color: isDone == true ? Colors.green : Colors.grey,
              )),
          const SizedBox(
            width: 10,
          ),
          IconButton(
              iconSize: 32,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Task ${tasks['title']} archived successfully'),
                    backgroundColor: Colors.grey,
                  ),
                );
                AppCubit.get(context)
                    .updateDatabase(status: 'archived', id: tasks['id']);
              },
              icon: Icon(
                Icons.archive,
                color: isArchived == true ? Colors.green : Colors.grey,
              )),
        ],
      ),
    );
  }
}
