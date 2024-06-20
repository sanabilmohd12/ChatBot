import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MessageWidget extends StatelessWidget {
  final String? text;
  final Image? image;
  final bool isfromUser;
  const MessageWidget(
      {super.key, this.text, this.image, required this.isfromUser});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isfromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 520),
            decoration: BoxDecoration(
              color: isfromUser ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
              borderRadius: isfromUser
                  ? const BorderRadius.only(
                      topRight: Radius.elliptical(50, 105),
                      topLeft: Radius.elliptical(50, 105),
                      bottomRight: Radius.circular(2),
                      bottomLeft: Radius.elliptical(50, 105),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.elliptical(50, 105),
                      topLeft: Radius.elliptical(50, 105),
                      bottomRight: Radius.elliptical(50, 105),
                      bottomLeft: Radius.circular(2),
                    ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            margin: isfromUser
                ? const EdgeInsets.only(bottom: 20, left: 25)
                : const EdgeInsets.only(bottom: 20, right: 25),
            child: Column(
              children: [
                if (text case final text?)
                  MarkdownBody(
                    data: text,
                  ),
                if (image case final image?) image,
              ],
            ),
          ),
        )
      ],
    );
  }
}
