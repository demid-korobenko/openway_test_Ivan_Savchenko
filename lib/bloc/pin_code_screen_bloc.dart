import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pincode_test_v2/enums/field_error.dart';
import 'package:pincode_test_v2/mixins/validation_mixin.dart';
import 'package:pincode_test_v2/bloc/pin_code_screen_event.dart';
part 'package:pincode_test_v2/bloc/pin_code_screen_state.dart';

class PinCodeScreenBloc extends Bloc<PinCodeScreenEvent, PinCodeScreenState>
    with ValidationMixin {
  PinCodeScreenBloc();

  @override
  PinCodeScreenState get initialState => PinCodeScreenState();

  @override
  Stream<PinCodeScreenState> mapEventToState(
    PinCodeScreenEvent event,
  ) async* {
    if (event is PinCodeScreenEventSubmit) {
        yield PinCodeScreenState(isLoading: true);
        await Future.delayed(const Duration(seconds: 2));
        if (!this.validateOtpCode(event.pin)) {
          yield PinCodeScreenState(pinError: FieldError.Incorrect);
          return;
        }
        yield PinCodeScreenState(submissionSuccess: true);
    }
  }
}
