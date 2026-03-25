import 'package:flutter/material.dart';
import 'package:PosTerminal/main.dart';
import 'package:PosTerminal/services/crud.dart';

class Store extends StatelessWidget {
  const Store({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: StoreBody()));
  }
}

class StoreBody extends StatefulWidget {
  const StoreBody({super.key});

  @override
  State<StoreBody> createState() => _StoreBody();
}

class _StoreBody extends State<StoreBody> {
  Map<String, dynamic>? _authUserData;
  final userId = supabase.auth.currentUser?.id;
  @override
  void initState() {
    super.initState();
    getMyUserData();
  }

  Future<void> getMyUserData() async {
    final data = await getUserData(userId!);
    setState(() {
      _authUserData = data;
    });
  }

  final authUser = supabase.auth.currentUser;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _authUserData?['dp'] != null
              ? Image.network(_authUserData?['dp'], width: 100, height: 100)
              : Image.asset(
                  "assets/images/google.png",
                  width: 100,
                  height: 100,
                ),

          Text(_authUserData?['user_id'].toString() ?? "NO DATA"),
          Text(_authUserData?['username'] ?? "NO DATA"),
          Text(_authUserData?['email'] ?? "NO DATA"),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
            child: Icon(Icons.arrow_back),
          ),
        ],
      ),
    );
  }
}
