import 'package:flutter/material.dart';
import 'package:cash_manager/theme.dart' as theme;

class RoundedFlatButton extends StatefulWidget {
  final Color backgroundColor;
  final String buttonText;
  final IconData buttonIcon;
  final Function passedFunction;

  const RoundedFlatButton(
      {Key? key,
      required this.backgroundColor,
      required this.passedFunction,
      required this.buttonText,
      required this.buttonIcon})
      : super(key: key);

  @override
  RoundedFlatButtonState createState() => RoundedFlatButtonState();
}

//TODO: replace with textButton

class RoundedFlatButtonState extends State<RoundedFlatButton> {
  @override
  Widget build(BuildContext context) {
    return (ButtonTheme(
      child: TextButton(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            color: theme.white,
            backgroundColor: theme.primaryColor,
            
          )
        ),
        child: widget.buttonText != null
            ? Text(widget.buttonText)
            : Icon(widget.buttonIcon),
        onPressed: () => widget.passedFunction(context),
      ),
    ));
  }
}
