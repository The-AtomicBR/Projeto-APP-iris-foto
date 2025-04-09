import 'package:flutter/material.dart';
import 'package:flutter_iris/manual_screen.dart';
import 'package:flutter_iris/user_info_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:flutter_iris/Camera/camera_screen.dart'; // Importação correta

final Logger logger = Logger();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Iris Foto IA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      home: const SplashScreen(),
      routes: {
        '/manual': (context) => const ManualScreen(),
        '/user_info': (context) => const UserInfoScreen(),
        '/camera': (context) => const CameraScreen(), // ✅ Agora está correto
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'IRIS FOTO IA',
              style: GoogleFonts.roboto(
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Desenvolvido por Necessary Development',
              style: GoogleFonts.roboto(fontSize: 20, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Text(
              'VERSÃO BETA 1.0.9',
              style: GoogleFonts.roboto(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/user_info');
              },
              child: const Text('Próximo'),
            ),
          ],
        ),
      ),
    );
  }
}
