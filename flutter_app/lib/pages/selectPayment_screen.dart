import 'package:cash_manager/pages/NFC_Reader.dart';
import 'package:cash_manager/pages/QR_code.dart';
import 'package:cash_manager/theme.dart';
import 'package:flutter/material.dart';
import 'package:cash_manager/components/widgets/classic_button.dart';
import 'package:cash_manager/theme.dart';

class SelectPayment extends StatefulWidget {
  const SelectPayment({super.key, required this.bill});

  final double bill;

  @override
  State<SelectPayment> createState() => _SelectPaymentState();
}

class _SelectPaymentState extends State<SelectPayment> {
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
                      'Select Payment',
                      style: TextStyle(
                        color: ColorTitleText,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'QRcode or NFC',
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
                      Icons.wallet_rounded,
                      color: Colors.white,
                    ))
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Text("${widget.bill}€",
                style: const TextStyle(color: ColorText, fontSize: 30)),
            const SizedBox(
              height: 50,
            ),
            ClassicButton(
              text: "QRcode",
              width: 100,
              height: 50,
              sizeText: 20,
              elementsOpacity: _elementsOpacity,
              icon: Icons.qr_code_scanner_rounded,
              onTap: () {
                setState(() {
                  _elementsOpacity = 0;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QRcodePage()));
              },
              onAnimationEnd: () async {
                await Future.delayed(const Duration(milliseconds: 500));
                setState(() {
                  loadingBallAppear = true;
                });
              },
            ),
            const SizedBox(
              height: 100,
            ),
            ClassicButton(
              width: 100,
              height: 50,
              text: "NFCreader",
              sizeText: 20,
              elementsOpacity: _elementsOpacity,
              icon: Icons.nfc_rounded,
              onTap: () {
                setState(() {
                  _elementsOpacity = 0;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NFCReaderPage()));
              },
              onAnimationEnd: () async {
                await Future.delayed(const Duration(milliseconds: 500));
                setState(() {
                  loadingBallAppear = true;
                });
              },
            )
          ],
        ),
      )),
    );
  }
}
