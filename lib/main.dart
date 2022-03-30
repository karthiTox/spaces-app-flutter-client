import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spaces/pages/auth/login_page.dart';
import 'package:spaces/pages/auth/auth_provider.dart';
import 'package:spaces/pages/auth/singup_page.dart';
import 'package:spaces/pages/auth/userid_page.dart';
import 'package:spaces/pages/chats/chat_cards_page.dart';
import 'package:spaces/pages/chats/chats_page.dart';
import 'package:spaces/pages/chats/chats_provider.dart';
import 'package:spaces/pages/chats/confirm_chat_page.dart';
import 'package:spaces/pages/chats/create_chat_page.dart';
import 'package:spaces/pages/chats/messages_page.dart';
import 'package:spaces/pages/splash.dart';
import 'package:spaces/pages/theme.dart';
import 'package:spaces/utilities/injector.dart';

void main() async {
  try {
    // WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp(
    //   options: const FirebaseOptions(
    //     apiKey: "AIzaSyDGc5x1BPMh3LbMkJ0YMSC2dMlgbL4GRJs",
    //     projectId: "spaces-dc4e8",
    //     messagingSenderId: "364364851396",
    //     appId: "1:364364851396:web:0f39e0ec68d6c12b884191",
    //   ),
    // );
    // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //   print(event);
    // });

    await setupLocator();
    runApp(const MyApp());
  } on PlatformException catch (e) {
    print(e.details.toString() + "\n" + e.message.toString() + "\n" + e.code);
    throw e;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData.dark().copyWith(
      colorScheme: const ColorScheme.dark().copyWith(
        primary: AppTheme.colorPrimary,
        onPrimary: AppTheme.colorOnPrimary,
        secondary: AppTheme.colorSecondary,
      ),
      scaffoldBackgroundColor: AppTheme.colorBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppTheme.colorBackground,
        foregroundColor: AppTheme.colorOnBackground,
        elevation: 0.0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(50)),
            backgroundColor:
                MaterialStateProperty.all<Color>(AppTheme.colorPrimary),
            foregroundColor:
                MaterialStateProperty.all<Color>(AppTheme.colorOnPrimary)),
      ),
      textTheme: AppTheme.textTheme,
      inputDecorationTheme: AppTheme.inputDecorationTheme,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(locator.get(), locator.get()),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              ChatsProvider(locator.get(), locator.get(), locator.get()),
        ),
      ],
      builder: (innerCtx, _) => MaterialApp(
          title: 'Spaces',
          theme: themeData,
          initialRoute:
              Provider.of<AuthProvider>(innerCtx, listen: false).isAuth()
                  ? '/chats/main'
                  : '/auth/login',
          routes: {
            '/splash': (innerCtx) => const Splash(),
            '/auth/login': (innerCtx) => const LoginPage(),
            '/auth/signup': (innerCtx) => const SignupPage(),
            '/auth/userId': (innerCtx) => const UserIdPage(),
            '/chats/main': (innerCtx) => const ChatsPage(),
            '/chats/create': (innerCtx) => const CreateChatPage(),
            '/chats/create/confirm': (innerCtx) => const ConfirmChatPage(),
            '/chats/cards': (innerCtx) => const ChatCardsPage(),
            '/chats/messages': (innerCtx) => const MessagesPage(),
          }),
    );
  }
}

class CustomHttpOveriders extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
