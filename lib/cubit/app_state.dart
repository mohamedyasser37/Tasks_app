part of 'app_cubit.dart';

@immutable
sealed class AppState {}

final class AppInitial extends AppState {}


final class AppBottomNavBarChange extends AppState {}

final class AppFabChange extends AppState {}



final class AppCreateDatabaseState extends AppState {}

final class AppGetDatabaseState extends AppState {}

final class AppInsertDatabaseState extends AppState {}

final class AppIUpdateDatabaseState extends AppState {}

final class AppDeleteDatabaseState extends AppState {}




