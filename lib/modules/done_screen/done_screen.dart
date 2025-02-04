import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/Components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class done_screen extends StatelessWidget {
  const done_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      builder: (BuildContext context, TodoStates state) {
        var tasks = TodoCubit.get(context).doneTasks;

        return tasks.isNotEmpty ?  ListView.separated(
          itemBuilder: (context, index) => taskeItem(tasks[index], context),
          separatorBuilder: (context, index) => Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          ),
          itemCount: tasks.length,
        ) : noTasksMassege();
      },
      listener: (BuildContext context, TodoStates state) {},
    );
  }
}
int suming (int num, int num2){
  int sum = num + num2;
  return sum
}
