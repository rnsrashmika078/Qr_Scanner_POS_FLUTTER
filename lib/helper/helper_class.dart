import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:PosTerminal/main.dart';

Future<void> initSocket() async {
  try {
    socket = IO.io('http://192.168.43.222:3000', <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.onConnect((_) {
      print('❤️❤️❤️❤️connected');
      socket.emit('send_message', 'Hello from Flutter');
    });

    // socket.on('receive_message', (data) {
    //   setState(() {
    //     messages = (data);
    //   });
    // });

    socket.onDisconnect((_) => print('disconnected'));
  } catch (e) {
    print("😥😥😥😥😥 error while connected to sockets");
  }
}
