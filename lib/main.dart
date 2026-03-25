import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:PosTerminal/helper/helper_class.dart';
import 'package:PosTerminal/screens/dashboard_screen.dart';
import 'package:PosTerminal/services/crud.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: AuthApp());
  }
}

late IO.Socket socket;

class AuthApp extends StatefulWidget {
  const AuthApp({super.key});

  @override
  State<AuthApp> createState() => _AuthApp();
}

class _AuthApp extends State<AuthApp> {
  Map<String, dynamic>? _authUserData;
  bool isOpen = false;
  String message = "";
  String messages = "INIT";
  // String qrResult = '{"name": "Rashmika", "age": 23}';
  // Map<String, dynamic> data = {};
  // String name = "";
  // int age = 0;

  @override
  void initState() {
    super.initState();
    initSocket();

    // setState(() {
    //   data = jsonDecode(qrResult);
    //   age = data['age'];
    //   name = data['name'];
    // });

    supabase.auth.onAuthStateChange.listen((data) async {
      final user = data.session?.user;
      final newUserData = data.session?.user.userMetadata;
      setState(() {
        _authUserData = newUserData;
      });

      if (data.event == AuthChangeEvent.signedIn && user != null) {
        await insertData(user.id);
      }
    });
  }

  String qrCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pos Terminal",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: Center(child: DashboardScreen()),
    );
  }
}
