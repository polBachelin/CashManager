import 'package:flutter/material.dart';

class ClassicButton extends StatefulWidget {
  final Function onTap;
  final Function? onAnimationEnd;
  final double elementsOpacity;
  final String text;
  const ClassicButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.onAnimationEnd,
      required this.elementsOpacity});

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
              color: const Color.fromARGB(255, 224, 227, 231),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.text,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 19),
                ),
                const SizedBox(width: 15),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.black,
                  size: 26,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
