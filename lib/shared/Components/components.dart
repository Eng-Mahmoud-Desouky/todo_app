import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget taskeItem(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        IconButton(
            onPressed: (){
              TodoCubit.get(context).updateDatabase(
                  status: 'done',
                  id: model['id']
              );
            },
            icon: const Icon(Icons.radio_button_unchecked,
              color: Colors.green,
              size: 30,
            )
        ),
        const SizedBox(
          width: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${model['title']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text('${model['time']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('${model['date']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: (){
            TodoCubit.get(context).updateDatabase(
                status: 'archive',
                id: model['id']
            );
          },
          icon: const Icon(Icons.archive,
          color: Colors.black45,
          )
        ),
      ],
    ),
  ),
  onDismissed: (direction){
    TodoCubit.get(context).deletingFromDatabase(id: model['id']);
  },
);

Widget noTasksMassege() => const Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.menu,
      size: 120,
      ),
      SizedBox(height: 10,),
      Text('No Tasks Yet, Please Add Some Tasks',
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
      )
    ],
  ),
);