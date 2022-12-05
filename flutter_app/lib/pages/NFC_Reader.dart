import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:nfc_manager/nfc_manager.dart';

class NFCReaderPage extends StatefulWidget {
  const NFCReaderPage({super.key});

  @override
  State<StatefulWidget> createState() => NFCReaderPageState();
}

class NFCReaderPageState extends State<NFCReaderPage> {
  ValueNotifier<dynamic> result = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Ready to scan a NFC tag')),
        body: SafeArea(
          child: FutureBuilder<bool>(
            future: NfcManager.instance.isAvailable(),
            builder: (context, ss) => ss.data != true
                ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
                : Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.vertical,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.all(8),
                          constraints: BoxConstraints.expand(),
                          decoration: BoxDecoration(border: Border.all()),
                          // child: SingleChildScrollView(
                          //   child: ValueListenableBuilder<dynamic>(
                          //     valueListenable: result,
                          //     builder: (context, value, _) =>
                          //         Text('${value ?? ''}'),
                          //   ),
                          // ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
