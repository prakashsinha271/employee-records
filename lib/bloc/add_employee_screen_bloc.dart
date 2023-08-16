import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_records/database/helper.dart';

class AddEmployeeState {}

class AddEmployeeInitial extends AddEmployeeState {}

class AddEmployeeSaved extends AddEmployeeState {}

class AddEmployeeBloc extends Cubit<AddEmployeeState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  AddEmployeeBloc() : super(AddEmployeeInitial());

  Future<void> saveEmployee(
      String name,
      String role,
      String joiningDate,
      String exitDate,
      ) async {
    final joinDateFinal =
        '${joiningDate.split(" ")[0]} ${joiningDate.split(" ")[1]}, ${joiningDate.split(" ")[2]}';
    final exitDateFinal =
    exitDate != "No date" ? '${joiningDate.split(" ")[0]} ${joiningDate.split(" ")[1]}, ${joiningDate.split(" ")[2]}' : exitDate;

    await _databaseHelper.insertData(name, role, joinDateFinal, exitDateFinal);
    emit(AddEmployeeSaved());
  }
}
