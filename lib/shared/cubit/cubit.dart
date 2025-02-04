import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/states.dart';
import '../../modules/arch_screen/arch_screen.dart';
import '../../modules/done_screen/done_screen.dart';
import '../../modules/tasks_screen/tasks_screen.dart';

class TodoCubit extends Cubit<TodoStates>{
  TodoCubit() : super(TodoInitialState());

  static TodoCubit get(context) => BlocProvider.of(context);

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  late Database database;
  int currentindex = 0;
  List<Widget> screens = [
    tasks_screen(),
    done_screen(),
    arch_screen(),
  ];
  bool bottomSheetShown = false;
  IconData fabIcon = Icons.add;

  void changeindex(int index){
    currentindex = index;
    emit(TodoChangeBottomNavBarState());
  }

  Future<void> createDataBase() async {
   database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version){
        database.execute('create table tasks (id INTEGER PRIMARY KEY, title TEXT,date TEXT, time TEXT, status TEXT)').then((value){
          print('Table Created');
        }).catchError((error){
          print('Error when Creating table ${error.toString()}');
        });
        print('Database Created');
      },
      onOpen: (database){
        getFromDatabase(database);
        print('Database Opened');
      },
    );
   emit(TodoCreateDatabaseState());
  }


   insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
     await database.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO tasks(title,date,time,status ) VALUES("$title","$date","$time","New")').then((value) {
        print('Inserting Done');
        emit(TodoInsertDatabaseState());
        getFromDatabase(database);
          }).catchError((error){
        print('Error when Inserting to Database ${error.toString()}');
      });
    });
  }

  void getFromDatabase(database)
  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(TodoGetDatabaseLodaingState());

    database.rawQuery('SELECT * From tasks').then((value) {

      value.forEach((element) {
        print(element);
        if (element['status'] == 'New') {
          newTasks.add(element);
        }
        else if (element['status'] == 'done'){
          doneTasks.add(element);
      }
        else {
          archivedTasks.add(element);
        }
      });
      emit(TodoGetDatabaseState());
    });
  }

  void changeBottomSheet({
    required bool isShow,
    required IconData icon,
}){
    bottomSheetShown = isShow;
    fabIcon = icon;
    emit(ChangeBottomSheetState());
  }

 void updateDatabase({
    required String status,
    required int id
}) async {
     database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id]).then((value) {
          getFromDatabase(database);
          emit(UpdateDatabaseState());
     });
  }

  void deletingFromDatabase({required int id}){
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getFromDatabase(database);
      emit(DeletingFromDatabaseState());
    });
  }
}