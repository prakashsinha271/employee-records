import 'package:employee_records/screens/add_emp_screen.dart';
import 'package:employee_records/screens/emp_list_screen.dart';
import 'package:employee_records/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/splash_screen_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return BlocProvider(
      create: (context) => SplashScreenBloc(),
      child: MaterialApp(
        title: 'Employee Records',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const EmployeeListScreen(),
          '/add_edit_employee': (context) => const AddEmployeeScreen(),
        },
      ),
    );
  }
}
