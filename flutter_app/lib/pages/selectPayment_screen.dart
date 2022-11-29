import 'package:cash_manager/components/widgets/email_field.dart';
import 'package:cash_manager/components/widgets/get_started_button.dart';
import 'package:cash_manager/components/widgets/messages_screen.dart';
import 'package:cash_manager/components/widgets/password_field.dart';
import 'package:cash_manager/theme.dart';
import 'package:flutter/material.dart';

class SelectPayment extends StatefulWidget {
  const SelectPayment({super.key});

  @override
  State<SelectPayment> createState() => _SelectPaymentState();
}

class _SelectPaymentState extends State<SelectPayment> {
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
              height: 40,
            ),
            Container(
              child: Row(
                children: [
                  FloatingActionButton.extended(
                    label: const Text(
                      'QRcode',
                      selectionColor: ColorText,
                    ),
                    backgroundColor: ColorButton,
                    icon: const Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 24.0,
                      color: ColorText,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
