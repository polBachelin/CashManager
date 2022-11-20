import 'package:flutter/material.dart';
import 'package:area/theme.dart' as theme;

class Input extends StatefulWidget {
  final String inputName;
  final IconData inputIcon;
  final String inputHintText;
  final String errorText;
  final TextInputType inputType;
  final bool inputHidden;
  final ValueChanged<String> getInputValue;

  const Input(
      {Key? key,
      required this.inputName,
      required this.errorText,
      required this.inputIcon,
      required this.inputHintText,
      required this.inputType,
      required this.inputHidden,
      required this.getInputValue})
      : super(key: key);

  @override
  InputState createState() => InputState();
}

class InputState extends State<Input> {
  String _input = "";

  @override
  Widget build(BuildContext context) {
    return (Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
        boxShadow: [
          BoxShadow(
            color: theme.labelColor,
            offset: Offset(0.0, 3.0),
            blurRadius: 3.0,
          )
        ],
      ),
      padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
      child: TextFormField(
        style: const TextStyle(fontSize: 14.0),
        maxLines: 1,
        obscureText: widget.inputHidden,
        decoration: InputDecoration(
          errorText: widget.errorText,
          hintText: widget.inputHintText,
          border: InputBorder.none,
          icon: Icon(
            widget.inputIcon,
            color: theme.primaryColor,
          ),
        ),
        onChanged: (value) {
          _input = value;
          widget.getInputValue(_input);
        },
      ),
    ));
  }
}
