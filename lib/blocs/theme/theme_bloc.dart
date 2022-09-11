import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tasks_app/config/theme.dart';
import 'package:tasks_app/models/models.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: darkThemeData())) {
    on<UpdateTheme>(_onUpdateTheme);
  }

  FutureOr<void> _onUpdateTheme(UpdateTheme event, Emitter<ThemeState> emit) {
    if (event.appTheme == AppTheme.lightTheme) {
      emit(ThemeState(themeData: lightThemeData()));
    } else {
      emit(ThemeState(themeData: darkThemeData()));
    }
  }
}
