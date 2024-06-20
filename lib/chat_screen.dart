import 'package:chatbot/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

import 'Providers/themeProvider.dart';

class ChatScreen extends StatefulWidget {
  final String title;
  final String? apiKey;
  const ChatScreen({super.key, required this.title, required this.apiKey});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        shadowColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: ShapeDecoration(
                  color: const Color(0xffab8afd),
                  image: const DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage(
                        "assets/CB ICON.png",
                      )),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
            const SizedBox.square(
              dimension: 10,
            ),
            Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        actions: [
          Consumer<ThemeProvider>(builder: (context, themevalue, child) {
            return FlutterSwitch(
              duration: const Duration(milliseconds: 1500),
              width: 40,
              height: 40,
              borderRadius: 15,
              toggleSize: 40,
              inactiveColor: Colors.transparent,
              activeColor: Colors.transparent,
              toggleColor: Colors.transparent,
              activeIcon:
                  const Icon(Icons.light_mode_rounded, color: Color(0xffffc400)),
              inactiveIcon:
                  const Icon(Icons.dark_mode_rounded, color: Color(0xffab8afd)),
              value: themevalue.darkTheme,
              onToggle: (value) {
                themevalue.toggleTheme();
              },
            );
          })
        ],
      ),
      body: ChatWidget(
        apiKey: widget.apiKey,
      ),
    );
  }
}
