import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
import '../../shared/Components/components.dart';

class tasks_screen extends StatelessWidget {
  const tasks_screen({super.key});

  @override
  Widget build(BuildContext context) {
     return BlocConsumer<TodoCubit, TodoStates>(
       builder: (BuildContext context, TodoStates state) {
         var tasks = TodoCubit.get(context).newTasks;

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
