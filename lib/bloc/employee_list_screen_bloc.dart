import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/employee.dart';
import '../database/helper.dart';

// Events
abstract class EmployeeListEvent {}

class InitEmployeeListEvent extends EmployeeListEvent {}

// States
abstract class EmployeeListState {}

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

// Bloc
class EmployeeListBloc extends Bloc<EmployeeListEvent, EmployeeListState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  EmployeeListBloc() : super(EmployeeListLoading());

  @override
  Stream<EmployeeListState> mapEventToState(EmployeeListEvent event) async* {
    if (event is InitEmployeeListEvent) {
      yield* _mapInitEmployeeListEventToState();
    }
  }

  Stream<EmployeeListState> _mapInitEmployeeListEventToState() async* {
    try {
      final employees = await _databaseHelper.getAllEmployees();
      final currentEmployees =
      employees.where((employee) => employee.exitDate == 'No date').toList();
      final previousEmployees =
      employees.where((employee) => employee.exitDate != 'No date').toList();

      yield EmployeeListLoaded(currentEmployees, previousEmployees);
    } catch (e) {
      yield EmployeeListError('Error fetching employee list');
    }
  }
}
