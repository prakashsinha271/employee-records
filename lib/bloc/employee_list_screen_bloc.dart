import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_records/database/helper.dart';
import 'package:employee_records/model/employee.dart';

abstract class EmployeeListState {}

class EmployeeListEvent {}

class InitEmployeeListEvent extends EmployeeListEvent {}

class EmployeeListLoading extends EmployeeListState {}

class EmployeeListLoaded extends EmployeeListState {
  final List<Employee> currentEmployees;
  final List<Employee> previousEmployees;

  EmployeeListLoaded(this.currentEmployees, this.previousEmployees);
}

class EmployeeListError extends EmployeeListState {
  final String error;

  EmployeeListError(this.error);
}

class EmployeeListBloc extends Bloc<EmployeeListEvent, EmployeeListState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  EmployeeListBloc() : super(EmployeeListLoading()) {
    add(InitEmployeeListEvent());
  }

  @override
  Stream<EmployeeListState> mapEventToState(EmployeeListEvent event) async* {
    if (event is InitEmployeeListEvent) {
      yield* _mapInitToState();
    }
  }

  Stream<EmployeeListState> _mapInitToState() async* {
    try {
      final db = await _databaseHelper.database;

      if (!(await _databaseHelper.isTableExists('empTable'))) {
        await _databaseHelper.onCreate(db, 1);
      }

      final employees = await _databaseHelper.getAllEmployees();
      final currentEmployees = employees.where((employee) => employee.exitDate == 'No date').toList();
      final previousEmployees = employees.where((employee) => employee.exitDate != 'No date').toList();

      yield EmployeeListLoaded(currentEmployees, previousEmployees);
    } catch (e) {
      yield EmployeeListError("Failed to fetch employee data");
    }
  }
}
