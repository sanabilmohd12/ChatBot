import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chatbot/Providers/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'chat_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(AIApp(
    apiKey: dotenv.env['API_KEY'],
  ));
}


class AIApp extends StatelessWidget {
  const AIApp({super.key, this.apiKey});

  final String? apiKey;

  @override
  Widget build(BuildContext context) {
    print(apiKey);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        )
      ],
      child: Consumer<ThemeProvider>(
          builder: (context, ThemeProvider themevalue, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "ChatBot",
            theme: themevalue.darkTheme ? dark : light,
            home: AnimatedSplashScreen(
                splashIconSize: 200,
                backgroundColor: themevalue.darkTheme
                    ? const Color(0xff302b48)
                    : const Color(0xffefeafc),
                splash: Lottie.asset(
                  "assets/chatbot.json",
                ),
                nextScreen: ChatScreen(title: 'ChatBot', apiKey: apiKey))
            // ChatScreen(title: 'ChatBot',apiKey: apiKey),
            );
      }),
    );
  }
}

