import 'package:cash_manager/components/nfc_session.dart';
import 'package:cash_manager/components/widgets/classic_button.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';

class TagModel with ChangeNotifier {
  NfcTag? tag;

  Future<String?> handleTag(NfcTag tag) async {
    this.tag = tag;

    notifyListeners();
    return 'Read is completed';
  }
}

class NFCReaderPage extends StatefulWidget {
  const NFCReaderPage({super.key});

  @override
  State<StatefulWidget> createState() => _NFCReaderPageState();
}

class _NFCReaderPageState extends State<StatefulWidget> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  NfcTag? tag;

  static Widget withDependency() => ChangeNotifierProvider<TagModel>(
        create: (context) => TagModel(),
        child: const NFCReaderPage(),
      );

  Future<String?> handleTag(NfcTag tag) async {
    debugPrint("Cool : ${tag.data}");
    Ndef? def = Ndef.from(tag);
    if (def == null) {
      return 'Read completed but tag is not compatible with NDEF';
    }
    Iterable<int> iterable = def.cachedMessage?.records.first.payload ?? [];
    String str = String.fromCharCodes(iterable);
    return 'Read: $str';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tag - Read'),
        ),
        body: SafeArea(
          child: Column(children: [
            ClassicButton(
              text: "Start scan",
              onTap: () =>
                  startSessions(context: context, handleTag: handleTag),
              elementsOpacity: 1,
            )
          ]),
        ));
  }
}
