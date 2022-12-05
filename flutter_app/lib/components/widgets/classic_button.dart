import 'package:cash_manager/theme.dart';
import 'package:flutter/material.dart';

class ClassicButton extends StatefulWidget {
  final Function onTap;
  final Function? onAnimationEnd;
  final double elementsOpacity;
  final String text;
  final IconData? icon;
  const ClassicButton({
    super.key,
    required this.text,
    required this.onTap,
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
            width: 230,
            height: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorButton,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.text,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ColorTextButton,
                      fontSize: 19),
                ),
                const SizedBox(width: 50),
                Icon(
                  widget.icon,
                  color: ColorLogo,
                  size: 26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
