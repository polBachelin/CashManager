import 'package:cash_manager/components/widgets/email_field.dart';
import 'package:cash_manager/components/widgets/classic_button.dart';
import 'package:cash_manager/components/widgets/messages_screen.dart';
import 'package:cash_manager/components/widgets/password_field.dart';
import 'package:cash_manager/theme.dart';
import 'package:flutter/material.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

class ValidationPage extends StatefulWidget {
  const ValidationPage({super.key, required String title});

  @override
  State<ValidationPage> createState() => _ValidationPageState();
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'validation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ValidationPage(title: 'validation'),
    );
  }
}

class _ValidationPageState extends State<ValidationPage> {
  @override
  Widget build(BuildContext context) {
    var widget;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: TextButton(
          child: const Text('Confirm Dialog'),
          onPressed: () async {
            if (await confirm(context)) {
              return print('pressedOK');
            }
            return print('pressedCancel');
          },
        ),
      ),
    );
  }
}
