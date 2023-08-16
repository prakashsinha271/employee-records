// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../database/helper.dart';
//
// // Events
// abstract class UpdateEmployeeEvent {}
//
// class SaveEmployeeEvent extends UpdateEmployeeEvent {
//   final String name;
//   final String role;
//   final String joiningDate;
//   final String exitDate;
//
//   SaveEmployeeEvent(this.name, this.role, this.joiningDate, this.exitDate);
// }
//
// // States
// abstract class UpdateEmployeeState {}
//
// class UpdateEmployeeInitial extends UpdateEmployeeState {}
//
// class EmployeeSavedSuccess extends UpdateEmployeeState {}
//
// class EmployeeSavedError extends UpdateEmployeeState {
//   final String error;
//
//   EmployeeSavedError(this.error);
// }
//
// // Bloc
// class UpdateEmployeeBloc extends Bloc<UpdateEmployeeEvent, UpdateEmployeeState> {
//   final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
//
//   UpdateEmployeeBloc() : super(UpdateEmployeeInitial());
//
//   @override
//   Stream<UpdateEmployeeState> mapEventToState(UpdateEmployeeEvent event) async* {
//     if (event is SaveEmployeeEvent) {
//       yield* _mapSaveEmployeeEventToState(event);
//     }
//   }
//
//   Stream<UpdateEmployeeState> _mapSaveEmployeeEventToState(SaveEmployeeEvent event) async* {
//     try {
//       await _databaseHelper.updateEmployee(event.updatedEmployee);
//
//       // Simulate a delay to emulate asynchronous behavior
//       await Future.delayed(Duration(seconds: 2));
//
//       // After saving successfully, emit a state indicating success
//       yield EmployeeSavedSuccess();
//     } catch (e) {
//       // In case of an error, emit a state indicating failure
//       yield EmployeeSavedError('Failed to save employee data');
//     }
//   }
// }
