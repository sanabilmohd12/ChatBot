import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

import 'message_widget.dart';

class ChatWidget extends StatefulWidget {
  final String? apiKey;
  const ChatWidget({super.key, required this.apiKey});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  final ScrollController _scrollController = ScrollController();
  bool _loading = false;

  final FocusNode _textfieldFocus = FocusNode();
  final TextEditingController _textController = TextEditingController();
  final List<({Image? image, String? text, bool fromUser})> _generatedContent = [];

  @override
  void initState() {
    _model = GenerativeModel(
        model: 'gemini-1.5-flash-latest', apiKey: widget.apiKey ?? '');
    _chat = _model.startChat();
    super.initState();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 750),
          curve: Curves.easeInOutCirc),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: widget.apiKey?.isNotEmpty ?? false
                ? ListView.builder(
                    itemCount: _generatedContent.length,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      final content = _generatedContent[index];
                      return MessageWidget(
                        image: content.image,
                        text: content.text,
                        isfromUser: content.fromUser,
                      );
                    },
                  )
                : ListView(
                    children: const [Text("No API Key Found")],
                  ),
          ),
          Container(
            foregroundDecoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18))),
            width: width / 1,
            decoration: ShapeDecoration(
                shadows: [
                  BoxShadow(
                      color: Theme.of(context).colorScheme.primary,
                      spreadRadius: 1,
                      blurRadius: 8,
                      blurStyle: BlurStyle.outer)
                ],
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18))),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    // autofocus: true,
                    onSubmitted: _sendMessage,
                    focusNode: _textfieldFocus,
                    controller: _textController,
                    decoration: const InputDecoration(
                        hintText: "Spit it out",
                        contentPadding: EdgeInsets.all(15),
                        border: InputBorder.none),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _pickImage();
                  },
                  icon: Icon(
                    Icons.image_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                if (!_loading)
                  IconButton(
                    onPressed: () {
                      _sendMessage(_textController.text);
                    },
                    icon: Icon(
                      Icons.send_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                else
                  SpinKitRipple(color: Theme.of(context).colorScheme.primary,)
                  // SpinKitSpinningLines(size: 40,
                  //   duration: Duration(seconds: 3),
                  //   color: Theme.of(context).colorScheme.primary,
                  // )
                // SpinKitWaveSpinner(curve: Curves.decelerate,
                //   waveColor: Theme.of(context).colorScheme.primary,
                //   trackColor: Theme.of(context).colorScheme.primary,
                //   color: Theme.of(context).colorScheme.secondary,
                // )
                // CircularProgressIndicator(
                //   strokeWidth: 2,
                //   strokeCap: StrokeCap.square,
                // )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _sendMessage(String message) async {
    setState(() {
      _loading = true;
    });

    try {
      _generatedContent.add((image: null, text: message, fromUser: true));
      final response = await _chat.sendMessage(
        Content.text(message),
      );
      final text = response.text;
      _generatedContent.add((image: null, text: text, fromUser: false));
      if (text == null) {
        showError("No Response");
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
      }
    } catch (e) {
      showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textfieldFocus.requestFocus();
    }
  }

  Future<dynamic> showError(String message) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Something Went wrong", style: TextStyle(fontSize: 20)),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"))
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _loading = true;
      });

      try {
        final bytes = await image.readAsBytes();
        final content = [
          Content.multi(
              [TextPart(_textController.text), DataPart('image.jpeg', bytes)])
        ];

        _generatedContent.add((
          text: _textController.text,
          image: Image.memory(bytes),
          fromUser: true
        ));

        var response = await _model.generateContent(content);
        var text = response.text;

        _generatedContent.add((image: null, text: text, fromUser: false));

        if (text == null) {
          showError("No Response");
          return;
        } else {
          setState(() {
            _loading = false;
            _scrollDown();
          });
        }
      } catch (e) {
        showError(e.toString());
        setState(() {
          _loading = false;
        });
      } finally {
        _textController.clear();
        setState(() {
          _loading = false;
        });
        _textfieldFocus.requestFocus();
      }
    }
  }
}
