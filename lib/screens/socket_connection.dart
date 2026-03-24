import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketConnection extends StatefulWidget {
  const SocketConnection({super.key});

  @override
  State<SocketConnection> createState() => _Dashboard();
}

class _Dashboard extends State<SocketConnection> {
  bool isOpen = false;
  String message = "";
  late IO.Socket socket;
  List<String> messages = [];
  @override
  void initState() {
    super.initState();
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('connected');
      // socket.emit('send_message', 'Hello from Flutter');
    });

    socket.on('receive_message', (data) {
      setState(() {
        messages.add(data);
      });
    });

    socket.onDisconnect((_) => print('disconnected'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  Text(message),
                  // Text(messages.isNotEmpty ? messages[0] : ""),
                  TextField(
                    onSubmitted: (value) {
                      socket.emit('send_message', value);
                      setState(() {
                        message = value;
                      });
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => ScannerScreen()),
                      // );
                    },
                    icon: const Icon(Icons.camera, size: 50),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
