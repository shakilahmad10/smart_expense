import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_expense/bloc/theme/theme_event.dart';
import 'package:smart_expense/bloc/theme/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(false)) {
    on<ToggleTheme>((event, emit) {
      emit(ThemeState(!state.isDarkMode));
    });
  }
}
