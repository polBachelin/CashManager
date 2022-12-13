import 'package:cash_manager/theme.dart';
import 'package:flutter/material.dart';

class ClassicButton extends StatefulWidget {
  final Function onTap;
  final Function? onAnimationEnd;
  final double elementsOpacity;
  final String text;
  final double width;
  final double height;
  final double sizeText;
  final IconData? icon;
  const ClassicButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.width,
    required this.sizeText,
    required this.height,
    this.onAnimationEnd,
    required this.elementsOpacity,
    this.icon,
  });

  @override
  State<ClassicButton> createState() => _ClassicButtonState();
}

class _ClassicButtonState extends State<ClassicButton> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 1, end: widget.elementsOpacity),
      onEnd: () async {
        widget.onAnimationEnd!();
      },
      builder: (_, value, __) => GestureDetector(
        onTap: () {
          widget.onTap();
        },
        child: Opacity(
          opacity: value,
          child: Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorButton,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.text,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ColorTextButton,
                      fontSize: widget.sizeText),
                ),
                const SizedBox(width: 30),
                Icon(
                  widget.icon,
                  color: ColorLogo,
                  size: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
