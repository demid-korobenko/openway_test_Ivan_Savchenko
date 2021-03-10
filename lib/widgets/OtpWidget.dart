import 'package:flutter/material.dart';

class OtpWidget extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmit;
  final TextStyle textStyle;
  final Widget preFilled;

  OtpWidget({this.controller, this.onSubmit, this.textStyle, this.preFilled});
  @override
  _OtpWidgetState createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  List<int> separatorPositions = [];
  ValueNotifier<String> _textControllerValue;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textControllerValue = ValueNotifier<String>(widget.controller.value.text);
    widget.controller.addListener(() {
      final otp = widget.controller.value.text;
      if (otp != _textControllerValue.value) {
        try {
          _textControllerValue.value = otp;
        } catch (e) {
          _textControllerValue = ValueNotifier(widget.controller.value.text);
        }
        if (otp.length == 4) widget.onSubmit?.call(otp);
      }
    });
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _textControllerValue?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          controller: widget.controller,
          maxLength: 4,
          keyboardType: TextInputType.number,
          focusNode: _focusNode,
          autofocus: true,
          enableSuggestions: false,
          autocorrect: false,
          enableInteractiveSelection: false,
          style: TextStyle(color: Colors.transparent),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide.none),
            counterText: "",
          ),
          showCursor: false,
        ),
        ValueListenableBuilder<String>(
          valueListenable: _textControllerValue,
          builder: (BuildContext context, value, Widget child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _buildFieldsWithSeparator(),
            );
          },
        )
      ],
    );
  }

  List<Widget> _buildFieldsWithSeparator() {
    final fields = Iterable<int>.generate(4).map((index) {
      return _field(index);
    }).toList();

    for (final int i in separatorPositions) {
      if (i <= 4) {
        final List<int> smaller =
            separatorPositions.where((int d) => d < i).toList();
        fields.insert(i + smaller.length, SizedBox(width: 15.0));
      }
    }

    return fields;
  }

  Widget _field(int index) {
    final String otp = widget.controller.value.text;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: 25,
        height: 30,
        child: _fieldContent(index, otp),
      ),
    );
  }

  Widget _fieldContent(int index, String otp) {
    if (index < otp.length) {
      return Text(
        otp[index],
        key: ValueKey<String>(index < otp.length ? otp[index] : ''),
        style: widget.textStyle,
        textAlign: TextAlign.center,
      );
    }

    if (widget.preFilled != null)
      return SizedBox(
        key: ValueKey<String>(index < otp.length ? otp[index] : ''),
        child: widget.preFilled,
      );
    return Text(
      'a',
      key: ValueKey<String>(index < otp.length ? otp[index] : ''),
      style: widget.textStyle,
    );
  }
}
