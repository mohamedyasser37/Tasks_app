import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/cubit/app_cubit.dart';
import 'package:tasks/widgets/custom_task_item.dart';

class ArchivedTaskScreen extends StatelessWidget {
  const ArchivedTaskScreen({super.key, this.isArchived});
final bool? isArchived ;
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
                    isArchived: true,
                    tasks: AppCubit.get(context).archivedTasks[index],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(
                    thickness: 1.5,
                  ),
              itemCount: AppCubit.get(context).archivedTasks.length),
        );
      },
    );
  }
}
