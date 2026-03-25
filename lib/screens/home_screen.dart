import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:PosTerminal/main.dart';
import 'package:PosTerminal/screens/store.dart';
import 'package:PosTerminal/services/auth.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic>? authUserData;
  const HomeScreen({super.key, required this.authUserData});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(authUserData?['name'] ?? "Not Signed in!"),
        SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
                await nativeGoogleSignIn();

                if (!context.mounted) {
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Store()),
                );
              } else {
                await supabase.auth.signInWithOAuth(OAuthProvider.google);
              }
            },
            child: Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,

              children: [
                Image.asset('assets/images/google.png', width: 25, height: 25),
                Text("Sign with Google"),
              ],
            ),
          ),
        ),
        ElevatedButton(onPressed: signOut, child: Icon(Icons.logout)),
      ],
    );
  }
}
