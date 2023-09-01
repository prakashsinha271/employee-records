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
  late List<Employee> _filteredEmployees = [];
  late List<Employee> _allEmployee = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper.instance;
    _employees = [];
    _initDatabaseAndFetchData();
  }

  Future<void> _initDatabaseAndFetchData() async {
    final db = await _databaseHelper.database;

    if (!(await _databaseHelper.isTableExists('empTable'))) {
      await _databaseHelper.onCreate(db, 1);
    }

    _employees = await _databaseHelper.getAllEmployees();

    final employees = await _databaseHelper.getAllEmployees();
    _currentEmployees =
        employees.where((employee) => employee.exitDate == 'No date').toList();
    _previousEmployees =
        employees.where((employee) => employee.exitDate != 'No date').toList();
    _filteredEmployees = _employees;
    _allEmployee = _employees;
    setState(() {});
  }

  void _filterEmployees(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredEmployees = _employees;
      } else {
        _filteredEmployees = _employees.where((employee) {
          final nameMatches =
              employee.name.toLowerCase().contains(query.toLowerCase());
          final roleMatches =
              employee.role.toLowerCase().contains(query.toLowerCase());
          return nameMatches || roleMatches;
        }).toList();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filterEmployees('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                onChanged: _filterEmployees,
                decoration: const InputDecoration(
                  hintText: 'Search employees',
                  border: InputBorder.none,
                ),
              )
            : const Text('Employee List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
          _isSearching
              ? const Text("")
              : PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == "sortByName") {
                      // TODO Handle sort event by name
                    } else if (value == "sortByRole") {
                      // TODO Handle sort event by role
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'sortByName',
                        child: Text('Sort by Name'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'sortByRole',
                        child: Text('Sort by Role'),
                      ),
                    ];
                  },
                ),
        ],
      ),
      body: _allEmployee.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                    children: _isSearching
                        ? [
                            _buildEmployeeSection(
                                'Search Result', _filteredEmployees)
                          ]
                        : [
                            if (_currentEmployees.isNotEmpty)
                              _buildEmployeeSection(
                                  'Current employees', _currentEmployees),
                            if (_previousEmployees.isNotEmpty)
                              _buildEmployeeSection(
                                  'Previous employees', _previousEmployees),
                          ],
                  ),
                ),
                _allEmployee.isNotEmpty
                    ? Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey,
                          padding: const EdgeInsets.all(12.0),
                          child: const Text(
                            "Swipe left to delete & tap to edit employee",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      )
                    : const Text(""),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEmployeeScreen()),
          ).then((_) {
            _initDatabaseAndFetchData();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmployeeSection(String header, List<Employee> employees) {
    if (employees.isEmpty) {
      return Container();
    }

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
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEmployeeScreen(employee: employee),
                  ),
                ).then((_) {
                  _initDatabaseAndFetchData();
                });
              },
              child: Dismissible(
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
                          await _databaseHelper
                              .undoDeleteEmployee(deletedEmployee);
                          _initDatabaseAndFetchData();
                        },
                      ),
                    ),
                  );
                  setState(() {});
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
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
