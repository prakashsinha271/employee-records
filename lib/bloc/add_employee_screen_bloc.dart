import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/helper.dart';

// Events
abstract class AddEmployeeEvent {}

class SaveEmployeeEvent extends AddEmployeeEvent {
  final String name;
  final String role;
  final String joiningDate;
  final String exitDate;

  SaveEmployeeEvent(this.name, this.role, this.joiningDate, this.exitDate);
}

// States
abstract class AddEmployeeState {}

class AddEmployeeInitial extends AddEmployeeState {}

class EmployeeSavedSuccess extends AddEmployeeState {}

class EmployeeSavedError extends AddEmployeeState {
  final String error;

  EmployeeSavedError(this.error);
}

// Bloc
class AddEmployeeBloc extends Bloc<AddEmployeeEvent, AddEmployeeState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  AddEmployeeBloc() : super(AddEmployeeInitial());

  @override
  Stream<AddEmployeeState> mapEventToState(AddEmployeeEvent event) async* {
    if (event is SaveEmployeeEvent) {
      yield* _mapSaveEmployeeEventToState(event);
    }
  }

  Stream<AddEmployeeState> _mapSaveEmployeeEventToState(SaveEmployeeEvent event) async* {
    try {
      await _databaseHelper.insertData(event.name, event.role, event.joiningDate, event.exitDate);

      // Simulate a delay to emulate asynchronous behavior
      await Future.delayed(Duration(seconds: 2));

      // After saving successfully, emit a state indicating success
      yield EmployeeSavedSuccess();
    } catch (e) {
      // In case of an error, emit a state indicating failure
      yield EmployeeSavedError('Failed to save employee data');
    }
  }
}
