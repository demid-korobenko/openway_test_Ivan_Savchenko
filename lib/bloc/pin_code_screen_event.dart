abstract class PinCodeScreenEvent {}

class PinCodeScreenEventSubmit extends PinCodeScreenEvent {
  final String pin;
  PinCodeScreenEventSubmit(this.pin);
}