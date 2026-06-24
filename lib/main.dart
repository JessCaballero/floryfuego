import 'package:floryfuego/screens/homescreeen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flor y Fuego",

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), 
        Locale('en', 'US'), 
      ],
      locale: const Locale('es', 'ES'),

      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF211111),
         textTheme: GoogleFonts.plusJakartaSansTextTheme(
          Theme.of(context).textTheme,
         ),
       ),
        home: Homescreeen(),
    ); 
  }


}
