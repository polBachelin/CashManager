import 'package:cash_manager/components/widgets/classic_button.dart';
import 'package:cash_manager/services/manager.dart';
import 'package:cash_manager/theme.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class ValidationPage extends StatefulWidget {
  const ValidationPage({super.key, required this.paymentInfos});

  final String? paymentInfos;

  @override
  State<ValidationPage> createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {
  double _elementsOpacity = 1;
  bool loadingBallAppear = false;
  double loadingBallSize = 1;
  String _isRefused = "images/validate.riv";
  bool paymentSucceed = false;

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
            paymentSucceed
                ? SizedBox(
                    height: 300,
                    width: 300,
                    child: RiveAnimation.asset(
                      _isRefused,
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                      //controllers: [_controller],
                    ))
                : const SizedBox(
                    height: 300,
                    width: 300,
                    child: RiveAnimation.asset('images/waiting.riv.riv',
                        fit: BoxFit.fill, alignment: Alignment.center)),
            const SizedBox(height: 150),
            FutureBuilder<bool>(
              future: paymentSucceed ? null : Manager.of(context).api.checkPayment(widget.paymentInfos),
              builder: (context, snapshot) {
              if (snapshot.hasData) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                    if (snapshot.data == false) {
                      _isRefused = "images/wrong.riv";
                    }
                    paymentSucceed = true;
                  });
                });
              }
              return ClassicButton(
                text: paymentSucceed ? 'Go back' : "Cancel",
                elementsOpacity: _elementsOpacity,
                icon: paymentSucceed ? Icons.arrow_back_sharp : Icons.cancel,
                onTap: () {
                  setState(() {
                    _elementsOpacity = 0;
                  });
                  Navigator.pushReplacementNamed(context, '/buy');
                },
                onAnimationEnd: () async {
                  await Future.delayed(const Duration(milliseconds: 500));
                  setState(() {
                    loadingBallAppear = true;
                  });
                },
              );
            }),
          ],
        ),
      )),
    );
  }
}
