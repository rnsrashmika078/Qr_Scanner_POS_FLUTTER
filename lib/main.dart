import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superbase_auth/services/crud.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

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

class AuthApp extends StatefulWidget {
  const AuthApp({super.key});

  @override
  State<AuthApp> createState() => _AuthApp();
}

class _AuthApp extends State<AuthApp> {
  Map<String, dynamic>? _authUserData;

  bool isOpen = false;
  String message = "";
  late IO.Socket socket;
  String messages = "INIT";
  late MobileScannerController camController;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;

    //cam controller intialization
    camController = MobileScannerController();

    socket = IO.io('http://192.168.43.222:3000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('❤️❤️❤️❤️connected');
      socket.emit('send_message', 'Hello from Flutter');
    });

    socket.on('receive_message', (data) {
      setState(() {
        messages = (data);
      });
    });

    socket.onDisconnect((_) => print('disconnected'));
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
      appBar: AppBar(title: Text("POS TERMINAL _ QR _ SCANNER ")),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: MobileScanner(
                controller: camController,
                onDetect: (barcodeCapture) {
                  final List<Barcode> barcodes = barcodeCapture.barcodes;

                  for (final barcode in barcodes) {
                    setState(() {
                      qrCode = barcode.rawValue!;
                    });
                  }
                  socket.emit("send_message", qrCode);
                  camController.stop();
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  children: [
                    // qrCode.isNotEmpty
                    //     ? ElevatedButton(
                    //         onPressed: () {
                    //           socket.emit("send_message", qrCode);
                    //         },
                    //         child: Icon(Icons.send),
                    //       )
                    //     : SizedBox(),
                    // Text("DONE", style: const TextStyle(fontSize: 18)),
                    ElevatedButton(
                      onPressed: () {
                        camController.start();
                      },
                      child: Icon(Icons.clear),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
