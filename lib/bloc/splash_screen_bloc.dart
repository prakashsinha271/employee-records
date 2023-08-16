import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreenBloc extends Cubit<bool> {
  SplashScreenBloc() : super(false) {
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 5), () {
      emit(true);
    });
  }
}
