import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/pantallas/InicioPage.dart';
import 'package:lsu_app/servicios/AuthService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LSU',
      //home: AuthService().handleAuth(),
      home: InicioPage(),
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Color.fromRGBO(239, 243, 248, 1.0)
      ),
    );
  }
}
