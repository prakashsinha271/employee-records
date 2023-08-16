import 'package:flutter/material.dart';
import 'package:employee_records/screens/add_emp_screen.dart';
import 'package:employee_records/database/helper.dart';

import '../model/employee.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({Key? key}) : super(key: key);

  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  late DatabaseHelper _databaseHelper;
  late List<Employee> _employees;
  late List<Employee> _currentEmployees = [];
  late List<Employee> _previousEmployees = [];

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper.instance;
    _employees = [];
    _initDatabaseAndFetchData();
  }

  Future<void> _initDatabaseAndFetchData() async {
    final db = await _databaseHelper.database;

    // Check if the table exists, if not, create it
    if (!(await _databaseHelper.isTableExists('empTable'))) {
      await _databaseHelper.onCreate(db, 1);
    }

    // Fetch employees from the database
    _employees = await _databaseHelper.getAllEmployees();

    final employees = await _databaseHelper.getAllEmployees();
    _currentEmployees =
        employees.where((employee) => employee.exitDate == 'No date').toList();
    _previousEmployees =
        employees.where((employee) => employee.exitDate != 'No date').toList();
    setState(() {}); // Update the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
      ),
      body: _employees.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(
              16.0), // Optional: Add padding around the image
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(
                    8.0), // Optional: Add additional padding
                child: Image.asset('assets/images/no_data_found.png'),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                if (_currentEmployees.isNotEmpty)
                  _buildEmployeeSection('Current employees', _currentEmployees),
                if (_previousEmployees.isNotEmpty)
                  _buildEmployeeSection(
                      'Previous employees', _previousEmployees),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: double.infinity, // Span the full width of the screen
              color: Colors.grey, // Set the desired background color
              padding: const EdgeInsets.all(16.0), // Adjust padding as needed
              child: const Text(
                "Swipe left to delete",
                style: TextStyle(
                  color: Colors.white, // Set text color
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEmployeeScreen()),
          ).then((_) {
            // Reload employee list when returning from AddEmployeeScreen
            _initDatabaseAndFetchData();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmployeeSection(String header, List<Employee> employees) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          color: Colors.white70,
          child: Text(
            header,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        const Divider(height: 1),
        Column(
          children: employees.asMap().entries.map((entry) {
            final index = entry.key;
            final employee = entry.value;
            return Dismissible(
              key: Key(employee.id.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) async {
                final deletedEmployee = employees.removeAt(index);
                await _databaseHelper.deleteEmployee(deletedEmployee.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Employee data has been deleted"),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () async {
                        await _databaseHelper.undoDeleteEmployee(deletedEmployee);
                        _initDatabaseAndFetchData();
                      },
                    ),
                  ),
                );
              },
              child: ListTile(
                title: Text(employee.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(employee.role),
                    Text(
                      '${employee.exitDate == "No date" ? "From" : ""} ${employee.joiningDate} ${employee.exitDate != "No date" ? "- ${employee.exitDate}" : ""}',
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
