import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';
import '../../modules/arch_screen/arch_screen.dart';
import '../../modules/done_screen/done_screen.dart';
import '../../modules/tasks_screen/tasks_screen.dart';

class hmoe_screen extends StatelessWidget {


  var s caffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  var titleControler = TextEditingController();
  var timeControler = TextEditingController();
  var dateControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TodoCubit()..createDataBase(),
      child: BlocConsumer<TodoCubit, TodoStates>(
        listener: (context, state) {
          if (state is TodoInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          TodoCubit cubit = TodoCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: const Text('To DO'),
            ),
            body: state == TodoGetDatabaseLodaingState ? const CircularProgressIndicator() : cubit.screens[cubit.currentindex],
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if(cubit.bottomSheetShown){
                  if(formkey.currentState!.validate()){
                    cubit.insertToDatabase(
                        title: titleControler.text,
                        time: timeControler.text,
                        date: dateControler.text
                    );
                  }
                }
                else{
                  scaffoldkey.currentState!.showBottomSheet(
                          (context) => Container(
                        color: Colors.grey[300],
                        padding: EdgeInsets.all(15),
                        child: Form(
                          key: formkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: titleControler,
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Field must not be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Task title',
                                  prefixIcon: const Icon(Icons.title),
                                  border:OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                controller: timeControler,
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Field must not be empty';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                  labelText: 'Task time',
                                  prefixIcon: const Icon(Icons.access_time_sharp),
                                  border:OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                ),
                                onTap: (){
                                  showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now()
                                  ).then((value)  {
                                    timeControler.text = value!.format(context).toString();
                                    print(value?.format(context));
                                  });
                                } ,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                controller: dateControler,
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Field must not be empty';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                  labelText: 'Due date',
                                  prefixIcon: const Icon(Icons.date_range),
                                  border:OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                ),
                                onTap: (){
                                  showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2024-07-10')
                                  ).then((value) {
                                    dateControler.text = DateFormat.yMMMd().format(value!);
                                  });
                                } ,
                              ),
                            ],
                          ),
                        ),
                      )
                  ).closed.then((value) {
                    cubit.changeBottomSheet(isShow: false, icon: Icons.add);
                  });
                  cubit.changeBottomSheet(isShow: true, icon: Icons.check);
                }
              },
              child: Icon(cubit.fabIcon,
                size: 35,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentindex,
              onTap: ( index ){
                cubit.changeindex(index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon:Icon(Icons.checklist_outlined,),
                    label: 'Tasks'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline,),
                    label: 'Done'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive,),
                    label: 'Arch'
                )
              ],
            ),
          );
        },
      ),
    );
  }

}

