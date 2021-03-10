part of 'pin_code_screen_bloc.dart';

class PinCodeScreenState {
  final bool isLoading;
  final FieldError pinError;
  final bool submissionSuccess;

  PinCodeScreenState({
    this.isLoading: false,
    this.pinError,
    this.submissionSuccess: false,
  });
}
