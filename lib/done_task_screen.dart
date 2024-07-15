import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/cubit/app_cubit.dart';
import 'package:tasks/new_task_screen.dart';
import 'package:tasks/widgets/custom_task_item.dart';

class DoneTaskScreen extends StatelessWidget {
 const  DoneTaskScreen({super.key, this.isDone});

 final bool? isDone ;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.separated(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTaskItem(
                    isDone: true,
                    tasks: AppCubit.get(context).doneTasks[index],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(
                    thickness: 1.5,
                  ),
              itemCount: AppCubit.get(context).doneTasks.length),
        );
      },
    );
  }
}
