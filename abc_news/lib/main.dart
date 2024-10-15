import 'package:abc_news/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = ValueNotifier<bool>(false);

    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, isDarkTheme, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blueGrey,
          ),
          home: Scaffold(
            appBar: AppBar(
              title: const Text("ABC News"),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(isDarkTheme ? Icons.dark_mode : Icons.light_mode),
                  onPressed: () {
                    themeNotifier.value = !isDarkTheme;
                  },
                ),
              ],
            ),
            body: const Home(),
          ),
        );
      },
    );
  }
}