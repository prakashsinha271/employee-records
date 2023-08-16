import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_records/screens/add_emp_screen.dart';
import 'package:employee_records/database/helper.dart';

import '../bloc/employee_list_screen_bloc.dart';
import '../model/employee.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeListBloc()..add(InitEmployeeListEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Employee List'),
        ),
        body: BlocBuilder<EmployeeListBloc, EmployeeListState>(
          builder: (context, state) {
            if (state is EmployeeListLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is EmployeeListLoaded) {
              return ListView(
                children: [
                  if (state.currentEmployees.isNotEmpty)
                    _buildEmployeeSection(
                        'Current employees', state.currentEmployees, context),
                  if (state.previousEmployees.isNotEmpty)
                    _buildEmployeeSection(
                        'Previous employees', state.previousEmployees, context),
                ],
              );
            } else if (state is EmployeeListError) {
              return Center(
                child: Text(state.error),
              );
            }
            return Container();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddEmployeeScreen()),
            ).then((_) {
              // Reload employee list when returning from AddEmployeeScreen
              context.read<EmployeeListBloc>().add(InitEmployeeListEvent());
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
  Widget _buildEmployeeSection(String header, List<Employee> employees, context) {
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
                await context.read<EmployeeListBloc>().deleteEmployee(deletedEmployee.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Employee data has been deleted"),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () async {
                        await context.read<EmployeeListBloc>().undoDeleteEmployee(deletedEmployee);
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
