import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks/cubit/app_cubit.dart';
import 'package:tasks/custom_text_form_field.dart';

import 'archived_task_screen.dart';
import 'done_task_screen.dart';
import 'new_task_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.text[cubit.currentIndex]),
            ),
            floatingActionButton: cubit.isBottomSheetShown == false
                ? FloatingActionButton(
                    onPressed: () {
                      cubit.changeFabIcon();
                      scaffoldKey.currentState!
                          .showBottomSheet((context) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              height: 310,
                              color: Colors.grey[100],
                              child: Form(
                                key: formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      CustomTextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'title must not be empty';
                                          } else {
                                            titleController.text = value;
                                          }
                                        },
                                        controller: titleController,
                                        keyboardType: TextInputType.text,
                                        hintText: 'title',
                                        prefixIcon: const Icon(Icons.title),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'time must not be empty';
                                          } else {
                                            timeController.text = value;
                                          }
                                        },
                                        onTap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) {
                                            timeController.text = value!
                                                .format(context)
                                                .toString();
                                          });
                                        },
                                        controller: timeController,
                                        hintText: 'time',
                                        keyboardType: TextInputType.datetime,
                                        prefixIcon: const Icon(
                                            Icons.watch_later_outlined),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextFormField(
                                        onTap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime(2100))
                                              .then((value) {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          });
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'date must not be empty';
                                          } else {
                                            dateController.text = value;
                                          }
                                        },
                                        controller: dateController,
                                        hintText: 'date',
                                        keyboardType: TextInputType.datetime,
                                        prefixIcon:
                                            const Icon(Icons.calendar_month),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                            minimumSize:
                                                MaterialStateProperty.all(
                                                    const Size(200, 50)),
                                          ),
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              cubit
                                                  .insertDatabase(
                                                title: titleController.text,
                                                date: dateController.text,
                                                time: timeController.text,
                                              )
                                                  .then((value) {
                                                Navigator.pop(context);
                                                titleController.clear();
                                                timeController.clear();
                                                dateController.clear();
                                              });
                                            }
                                          },
                                          child: const Text('Add',
                                              style: TextStyle(
                                                fontSize: 20,
                                              ))),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                          .closed
                          .then((value) {
                            cubit.changeFabIcon();
                          });
                    },
                    child: const Icon(Icons.add),
                  )
                : null,

            bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                onTap: (value) {
                  cubit.changeIndex(value);
                },
                items: const [
                  BottomNavigationBarItem(
                    label: 'New',
                    icon: Icon(Icons.list),
                  ),
                  BottomNavigationBarItem(
                    label: 'Done',
                    icon: Icon(Icons.check_circle_outline_outlined),
                  ),
                  BottomNavigationBarItem(
                    label: 'Archived',
                    icon: Icon(Icons.archive_outlined),
                  ),
                ]),
            body: cubit.screens[cubit.currentIndex],
            // screens[currentIndex],
          );
        },
      ),
    );
  }
}
