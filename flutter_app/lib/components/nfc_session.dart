import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

Future<void> startSessions({
  required BuildContext context,
  required Future<String?> Function(NfcTag) handleTag,
  String alertMessage = 'Hold your device near the item.',
}) async {
  if (!(await NfcManager.instance.isAvailable())) {
    return showDialog(
      context: context,
      builder: (context) => _UnavailableDialog(),
    );
  }
  return showDialog(
    context: context,
    builder: (context) => _NfcSessionDialog(alertMessage, handleTag),
  );
}

class _UnavailableDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: const Text('Check your NFC it might be turned off'),
      actions: [
        TextButton(
          child: const Text('Ok'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}

class _NfcSessionDialog extends StatefulWidget {
  const _NfcSessionDialog(this.alertMessage, this.tagResult);

  final String alertMessage;
  final Future<String?> Function(NfcTag tag) tagResult;

  @override
  State<_NfcSessionDialog> createState() => _NfcDialogState();
}

class _NfcDialogState extends State<_NfcSessionDialog> {
  String? _alertMessage;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    NfcManager.instance.startSession(
      onDiscovered: (tag) async {
        try {
          final result = await widget.tagResult(tag);
          if (result == null) return;
          setState(() => _alertMessage = result);
        } catch (e) {
          await NfcManager.instance.stopSession().catchError((_) {/* no op */});
          setState(() => _errorMessage = '$e');
        }
      },
    ).catchError((e) => setState(() => _errorMessage = '$e'));
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession().catchError((_) {/* no op */});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _errorMessage?.isNotEmpty == true
            ? 'Error'
            : _alertMessage?.isNotEmpty == true
                ? 'Success'
                : 'Ready to scan',
      ),
      content: Text(
        _errorMessage?.isNotEmpty == true
            ? _errorMessage!
            : _alertMessage?.isNotEmpty == true
                ? _alertMessage!
                : widget.alertMessage,
      ),
      actions: [
        TextButton(
          child: Text(
            _errorMessage?.isNotEmpty == true
                ? 'GOT IT'
                : _alertMessage?.isNotEmpty == true
                    ? 'OK'
                    : 'CANCEL',
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
