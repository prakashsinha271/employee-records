import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_records/widgets/exit_date_widget.dart';
import 'package:employee_records/widgets/joining_date_widget.dart';
import '../bloc/add_employee_screen_bloc.dart';
import '../database/helper.dart';
import '../model/employee.dart';

class AddEmployeeScreen extends StatelessWidget {
  final Employee? employee;
  const AddEmployeeScreen({Key? key, this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddEmployeeBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(employee == null ? 'Add Employee' : 'Edit Employee'),
          actions: <Widget>[
            employee == null
                ? IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Help'),
                            content: const Text(
                                'Hello There, I am here to assist you'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.help_outline))
                : IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Delete Employee'),
                            content: Text(
                                'Are you sure you want to delete ${employee!.name}?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Delete'),
                                onPressed: () async {
                                  await DatabaseHelper.instance
                                      .deleteEmployee(employee!.id);
                                  Navigator.of(context).popUntil(ModalRoute.withName('/home'));
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete_outline_outlined))
          ],
        ),
        body: AddEmployeeForm(employee: employee),
      ),
    );
  }
}

class AddEmployeeForm extends StatefulWidget {
  final Employee? employee;
  AddEmployeeForm({Key? key, this.employee}) : super(key: key);
  @override
  _AddEmployeeFormState createState() => _AddEmployeeFormState();
}

class _AddEmployeeFormState extends State<AddEmployeeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController selectRoleController;
  late TextEditingController joiningDateController;
  late TextEditingController exitDateController;

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      nameController = TextEditingController(text: widget.employee!.name);
      selectRoleController = TextEditingController(text: widget.employee!.role);
      joiningDateController =
          TextEditingController(text: widget.employee!.joiningDate);
      exitDateController =
          TextEditingController(text: widget.employee!.exitDate);
    } else {
      nameController = TextEditingController(text: 'Employee Name');
      selectRoleController = TextEditingController(text: 'Select a Role');
      joiningDateController = TextEditingController(text: 'Today');
      exitDateController = TextEditingController(text: 'No date');
    }
  }

  List<String> roles = [
    'Product Designer',
    'Flutter Developer',
    'QA Tester',
    'Product Owner'
  ];
  DateTime todayLocalDate = DateTime.now().toLocal();

  void _openRolesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Container(
            height: 300,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: ListView.separated(
                      itemCount: roles.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1, color: Colors.grey),
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Center(child: Text(roles[index])),
                          onTap: () {
                            setState(() {
                              String selectedRole = roles[index];
                              selectRoleController.text = selectedRole;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openJoiningDateWidget(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: JoiningDateWidget(
            onDateSelected: (date) {
              setState(() {
                joiningDateController.text = getFormatedDate(date);
              });
            },
          ),
        );
      },
    );
  }

  void _openExitDateWidget(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: ExitDateWidget(
            onDateSelected: (selectedDate) {
              setState(() {
                String onSelectedDate = getFormatedDate(selectedDate);
                exitDateController.text = onSelectedDate;
              });
            },
            onNoDateSelected: () {
              setState(() {
                exitDateController.text = "No date";
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  String? validateEmployeeName(String? value) {
    if (value == null ||
        value.isEmpty ||
        value == "Employee Name" ||
        value == "") {
      return 'Please enter a valid employee name';
    }
    return null;
  }

  String? validateSelectedRole(String? value) {
    if (value == null ||
        value.isEmpty ||
        value == "" ||
        value == "Select a Role") {
      return 'Please select a role';
    }
    return null;
  }

  String? validateJoiningDate(String? value) {
    if (value == null || value.isEmpty || value == "Today") {
      return 'Please select a joining date';
    }
    return null;
  }

  Future<void> _handleSaveButtonTap() async {
    if (_formKey.currentState!.validate()) {
      final name = nameController.text;
      final role = selectRoleController.text;
      final joiningDate = joiningDateController.text;
      final exitDate = exitDateController.text;
      final joinDateFinal =
          '${joiningDate.split(" ")[0]} ${joiningDate.split(" ")[1]}, ${joiningDate.split(" ")[2]}';
      final exitDateFinal = exitDate != "No date"
          ? '${exitDate.split(" ")[0]} ${exitDate.split(" ")[1]}, ${exitDate.split(" ")[2]}'
          : exitDate;

      if (widget.employee == null) {
        context.read<AddEmployeeBloc>().add(
              SaveEmployeeEvent(name, role, joinDateFinal, exitDateFinal),
            );
      } else {
        final updatedEmployee = Employee(
          id: widget.employee!.id,
          name: name,
          role: role,
          joiningDate: joinDateFinal,
          exitDate: exitDateFinal,
        );
        context.read<AddEmployeeBloc>().add(
              UpdateEmployeeEvent(updatedEmployee),
            );
      }

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                validator: validateEmployeeName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon:
                      const Icon(Icons.person_outline, color: Colors.blue),
                ),
                style: TextStyle(
                  color: nameController.text == 'Employee Name'
                      ? Colors.grey
                      : Colors.black,
                ),
                onTap: () {
                  if (nameController.text == 'Employee Name') {
                    nameController.clear();
                  }
                },
                onFieldSubmitted: (value) {
                  if (value.isEmpty || value == '') {
                    nameController.text = 'Employee Name';
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: selectRoleController,
                validator: validateSelectedRole,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon:
                      const Icon(Icons.work_outline, color: Colors.blue),
                  suffixIcon:
                      const Icon(Icons.arrow_drop_down, color: Colors.blue),
                ),
                style: TextStyle(
                  color: selectRoleController.text == 'Select a Role' ||
                          selectRoleController.text == ''
                      ? Colors.grey
                      : Colors.black,
                ),
                readOnly: true,
                onTap: () {
                  _openRolesModal(context);
                },
                onFieldSubmitted: (value) {
                  if (value.isEmpty || value == '') {
                    selectRoleController.text = 'Select a Role';
                  }
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        controller: joiningDateController,
                        validator: validateJoiningDate,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelStyle: TextStyle(
                            color: joiningDateController.text.isEmpty
                                ? Colors.grey
                                : Colors.blue,
                          ),
                          prefixIcon: const Icon(Icons.calendar_today,
                              color: Colors.blue),
                        ),
                        readOnly: true,
                        onTap: () {
                          _openJoiningDateWidget(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.blue,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        controller: exitDateController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelStyle: TextStyle(
                            color: exitDateController.text == "No date"
                                ? Colors.grey
                                : Colors.blue,
                          ),
                          prefixIcon: const Icon(Icons.calendar_today,
                              color: Colors.blue),
                        ),
                        readOnly: true,
                        onTap: () {
                          _openExitDateWidget(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            color: Colors.grey,
            height: 1,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: const Color.fromRGBO(240, 255, 255, 1.0),
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _handleSaveButtonTap();
                  },
                  child: widget.employee == null
                      ? const Text('Save')
                      : const Text('Update'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _getShortMonth(intMonth) {
  switch (intMonth) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      throw ArgumentError('Invalid month: $intMonth');
  }
}

String getFormatedDate(dateValue) {
  if (dateValue == "Today") {
    return dateValue;
  } else if (dateValue == "No date") {
    return dateValue;
  } else {
    List<String> splitDate = dateValue.toString().split("-");
    return "${int.parse(splitDate[2])} ${_getShortMonth(int.parse(splitDate[1]))} ${splitDate[0]}";
  }
}
