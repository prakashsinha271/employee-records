import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_records/widgets/exit_date_widget.dart';
import 'package:employee_records/widgets/joining_date_widget.dart';
import '../bloc/add_employee_screen_bloc.dart';

class AddEmployeeScreen extends StatelessWidget {
  const AddEmployeeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddEmployeeBloc(),
      child: Scaffold(
        body: AddEmployeeForm(),
      ),
    );
  }
}

class AddEmployeeForm extends StatefulWidget {
  @override
  _AddEmployeeFormState createState() => _AddEmployeeFormState();
}

class _AddEmployeeFormState extends State<AddEmployeeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController(text: 'Employee Name');
  TextEditingController selectRoleController = TextEditingController(text: 'Select a Role');
  TextEditingController joiningDateController = TextEditingController(text: 'Today');
  TextEditingController exitDateController = TextEditingController(text: 'No date');

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
              Navigator.pop(context); // Close the overlay
            },
          ),
        );
      },
    );
  }

  String? validateEmployeeName(String? value) {
    if (value == null || value.isEmpty || value == "Employee Name" || value == "") {
      return 'Please enter a valid employee name';
    }
    return null;
  }

  String? validateSelectedRole(String? value) {
    if (value == null || value.isEmpty || value == "" || value == "Select a Role") {
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
      final joinDateFinal = '${joiningDate.split(" ")[0]} ${joiningDate.split(" ")[1]}, ${joiningDate.split(" ")[2]}';
      final exitDateFinal = exitDate != "No date" ? '${exitDate.split(" ")[0]} ${exitDate.split(" ")[1]}, ${exitDate.split(" ")[2]}' : exitDate;
      print("Prakash Sir");
      print("${name}, ${role}, ${joinDateFinal}, ${exitDateFinal}`");
      context.read<AddEmployeeBloc>().add(
        SaveEmployeeEvent(name, role, joinDateFinal, exitDateFinal),
      );
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
      appBar: AppBar(
        title: const Text('Add Employee'),
      ),
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
                  prefixIcon: const Icon(Icons.person_outline, color: Colors.blue),
                ),
                style: TextStyle(
                  color: nameController.text == 'Employee Name' ? Colors.grey : Colors.black,
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
                  prefixIcon: const Icon(Icons.work_outline, color: Colors.blue),
                  suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                ),
                style: TextStyle(
                  color: selectRoleController.text == 'Select a Role' || selectRoleController.text == '' ? Colors.grey : Colors.black,
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
                      width: 150, // Provide a finite width constraint here
                      child: TextFormField(
                        controller: joiningDateController,
                        validator: validateJoiningDate,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // labelText: 'Today',
                          labelStyle: TextStyle(
                            color:
                            joiningDateController.text.isEmpty ? Colors.grey : Colors.blue,
                          ),
                          prefixIcon:
                          const Icon(Icons.calendar_today, color: Colors.blue),
                        ),
                        readOnly: true, // Make the field read-only
                        onTap: () {
                          _openJoiningDateWidget(context); // Open the date picker
                        },
                      ),
                    ),
                    const SizedBox(
                        width:
                        16), // Spacer between the first GestureDetector and the icon
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.blue,
                      size: 24,
                    ),
                    const SizedBox(
                        width:
                        16), // Spacer between the icon and the second GestureDetector
                    SizedBox(
                      width: 150, // Provide a finite width constraint here
                      child: TextFormField(
                        controller: exitDateController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelStyle: TextStyle(
                            color:
                            exitDateController.text == "No date" ? Colors.grey : Colors.blue,
                          ),
                          prefixIcon:
                          const Icon(Icons.calendar_today, color: Colors.blue),
                        ),
                        readOnly: true, // Make the field read-only
                        onTap: () {
                          _openExitDateWidget(context); // Open the date picker
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
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(240, 255, 255, 1.0),
                    onPrimary: Colors.blue, // Text color
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _handleSaveButtonTap();
                  },
                  child: const Text('Save'),
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
