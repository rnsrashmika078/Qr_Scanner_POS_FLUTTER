import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:PosTerminal/main.dart';
import 'dart:convert';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScanner();
}

class _QrScanner extends State<QrScanner> {
  bool isOpen = true;
  String qrCode = "";
  late MobileScannerController camController;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    //cam controller intialization
    camController = MobileScannerController();
  }

  Map<String, dynamic> parsedData = {};
  String name = "";
  String imageUrl = "";
  String rawValue = "";
  String price = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QR Scanner")),
      body: Center(
        child: Column(
          children: [
            isOpen
                ? Expanded(
                    flex: 4,
                    child: MobileScanner(
                      controller: camController,
                      onDetect: (barcodeCapture) {
                        final List<Barcode> barcodes = barcodeCapture.barcodes;
                        for (final barcode in barcodes) {
                          setState(() {
                            rawValue = barcode.rawValue!;
                          });
                        }
                        setState(() {
                          parsedData = jsonDecode(rawValue);
                          imageUrl = parsedData['image'];
                          name = parsedData['name'];
                          price = parsedData['price'].toString();
                        });
                        socket.emit("send_message", qrCode);
                        camController.stop();
                        setState(() {
                          isOpen = false;
                        });
                      },
                    ),
                  )
                : Expanded(
                    flex: 1,
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 300,
                            child: Image(
                              image: AssetImage('assets/images$imageUrl'),
                            ),
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Rs. $price",
                            style: const TextStyle(fontSize: 24),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              camController.start();
                              setState(() {
                                isOpen = true;
                              });
                            },
                            child: Icon(Icons.done, size: 30),
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
