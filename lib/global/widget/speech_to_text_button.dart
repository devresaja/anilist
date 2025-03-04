import 'dart:async';
import 'package:anilist/constant/app_color.dart';
import 'package:anilist/constant/divider.dart';
import 'package:anilist/widget/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextButton extends StatefulWidget {
  final Function(String) onResult;
  const SpeechToTextButton({super.key, required this.onResult});

  @override
  State<SpeechToTextButton> createState() => _SpeechToTextButtonState();
}

class _SpeechToTextButtonState extends State<SpeechToTextButton> {
  final _speech = SpeechToText();
  bool _isListening = false;
  bool _isDialogOpen = false;
  final ValueNotifier<String?> _textResult = ValueNotifier<String?>(null);
  Timer? _silenceTimer;

  Future<void> _startListening() async {
    _textResult.value = null;
    bool available = await _speech.initialize(
      onStatus: _onSpeechStatus,
      onError: (error) => debugPrint('Speech error: $error'),
    );

    if (available) {
      setState(() {
        _isListening = true;
        _isDialogOpen = true;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppColor.secondary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: TextWidget(
              'Listening',
              fontSize: 16,
            ),
            contentPadding:
                EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 10),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpinKitWave(color: AppColor.primary, size: 40),
                divide8,
                ValueListenableBuilder<String?>(
                  valueListenable: _textResult,
                  builder: (context, value, child) {
                    return TextWidget(value ?? 'Say something...');
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: _stopListening,
                child: TextWidget(
                  'Stop',
                  color: AppColor.error,
                ),
              ),
            ],
          );
        },
      ).then(
        (value) {
          setState(() {
            _isDialogOpen = false;
          });
          if (_isListening) {
            _speech.stop();
          }
        },
      );

      _speech.listen(
        onResult: (result) {
          _textResult.value = result.recognizedWords;
          _resetSilenceTimer();
        },
      );
    }
  }

  void _resetSilenceTimer() {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(Duration(seconds: 1), () {
      _stopListening();
    });
  }

  void _onSpeechStatus(String status) {
    if (status == 'done') {
      _stopListening();
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
    _silenceTimer?.cancel();
    if (_isDialogOpen) {
      Navigator.pop(context);
    }
    if (_textResult.value != null) {
      widget.onResult(_textResult.value!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: _isListening ? null : _startListening,
        icon: Icon(
          Icons.mic,
          size: 28,
          color: Colors.grey,
        ));
  }
}
