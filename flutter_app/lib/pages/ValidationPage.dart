import 'package:cash_manager/components/widgets/classic_button.dart';
import 'package:cash_manager/pages/selectPayment_screen.dart';
import 'package:cash_manager/theme.dart';
import 'package:flutter/material.dart';

class ValidationPage extends StatefulWidget {
  const ValidationPage({super.key});

  @override
  State<ValidationPage> createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {
  double _elementsOpacity = 1;
  bool loadingBallAppear = false;
  double loadingBallSize = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorBackground,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Paiement Validate',
                      style: TextStyle(
                        color: ColorText,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
                Container(
                    decoration: BoxDecoration(
                      color: ColorText,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.assignment_turned_in_rounded,
                      color: Colors.white,
                    ))
              ],
            ),
            const SizedBox(
              height: 150,
            ),
            ClassicButton(
              width: 120,
              height: 50,
              sizeText: 20,
              text: 'Go back',
              elementsOpacity: _elementsOpacity,
              icon: Icons.arrow_back_sharp,
              onTap: () {
                setState(() {
                  _elementsOpacity = 0;
                });
              },
              // onAnimationEnd: () async {
              //   await Future.delayed(const Duration(milliseconds: 500));
              //   setState(() {
              //     loadingBallAppear = true;
              //   });
              // },
            ),
          ],
        ),
      )),
    );
  }
}
