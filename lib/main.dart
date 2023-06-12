import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:wallpaper_app/controllers/wallpaper_controller.dart';
import 'package:wallpaper_app/screens/home_screen.dart';

//2D0yUgDN4FyVFiUCiNC2ok2H6fFV8AnkMug2xI5DEQqjCBuBE6qoJr0x
Future<void> main() async {
  sqfliteFfiInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WillpaperController())
      ],
      child: MaterialApp(
          title: 'Wallpaper App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomeScreen()),
    );
  }
}
