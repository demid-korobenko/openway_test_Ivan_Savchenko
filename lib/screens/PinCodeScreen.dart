import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pincode_test_v2/bloc/pin_code_screen_bloc.dart';
import 'package:pincode_test_v2/bloc/pin_code_screen_event.dart';
import 'package:pincode_test_v2/enums/field_error.dart';
import 'package:pincode_test_v2/widgets/LoadingDialog.dart';
import 'package:pincode_test_v2/widgets/OtpWidget.dart';

class PinCodeScreen extends StatefulWidget {
  PinCodeScreen({Key key}) : super(key: key);

  @override
  _PinCodeScreenState createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PinCodeScreenBloc(),
      child: BlocListener<PinCodeScreenBloc, PinCodeScreenState>(
        listener: (context, state) {
          if (state.isLoading)
            LoadingDialog.show(context);
          else
            LoadingDialog.hide(context);

          if (state.submissionSuccess) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Row(
                    children: [
                      Icon(Icons.info),
                      Text(" Success"),
                    ],
                  ),
                  content: Text("Otp matched successfully."),
                  actions: <Widget>[
                    RaisedButton(
                      child: Text('OK'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: Scaffold(
          backgroundColor: Color(0xfffdf5e6),
          body: BlocBuilder<PinCodeScreenBloc, PinCodeScreenState>(
              builder: (context, state) {
            return Center(
              child: ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: <Widget>[
                    Text(
                      "Enter the code sent\n to +32 (0) 10 80 01 00",
                      style: GoogleFonts.rubik(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    OtpWidget(
                      controller: _otpController,
                      onSubmit: (String pin) => context
                          .bloc<PinCodeScreenBloc>()
                          .add(PinCodeScreenEventSubmit(pin)),
                      preFilled: Text(
                          "●",
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                      textStyle: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color:
                            this._getPinError(state) ? Colors.red : Colors.black,
                      ),
                    ),
                    SizedBox(height: 15),
                    if (this._getPinError(state))
                      Text(
                        this._pinErrorText(state.pinError),
                        style: TextStyle(color: Colors.red, fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                    if (!this._getPinError(state))
                      FlatButton(
                        onPressed: () => _otpController.text = "",
                        child: Text(
                          "Request new code",
                          style: GoogleFonts.rubik(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ]),
            );
          }),
        ),
      ),
    );
  }

  bool _getPinError(PinCodeScreenState state) {
    return state.pinError != null;
  }

  String _pinErrorText(FieldError error) {
    _otpController.text = "";
    switch (error) {
      case FieldError.Incorrect:
        return 'Incorrect code';
      default:
        return '';
    }
  }
}
