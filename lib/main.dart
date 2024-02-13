import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vblogmobile/config/router.config.dart';
import 'package:vblogmobile/provider/theme.provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: ThemeClass.themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'VBlog App',
            themeMode: currentMode,
            theme: ThemeClass.lightTheme,
            darkTheme: ThemeClass.darkTheme,
            routerConfig: router(),
          );
        });
  }
}
