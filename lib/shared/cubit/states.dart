abstract class TodoStates {}

class TodoInitialState extends TodoStates{}

class TodoChangeBottomNavBarState extends TodoStates{}

class TodoCreateDatabaseState extends TodoStates{}

class TodoGetDatabaseState extends TodoStates{}

class TodoGetDatabaseLodaingState extends TodoStates{}

class TodoInsertDatabaseState extends TodoStates{}

class ChangeBottomSheetState extends TodoStates{}

class UpdateDatabaseState extends TodoStates{}

class DeletingFromDatabaseState extends TodoStates{}
