## Supabase Google authentication in flutter

### Step 1: Setup Google API Service Project

```yaml
https://console.cloud.google.com/apis/dashboard?authuser=2&orgonly=true&project=flutter-486109&supportedpurview=project
```

### Step 2: Create auth service

```bash
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:PosTerminal/main.dart';

Future<void> nativeGoogleSignIn() async {
  await dotenv.load();
  final webClientId = dotenv.env['WEB_CLIENT_ID']!;
  final iosClientId = dotenv.env['IOS_CLIENT_ID']!;
  final googleSignIn = GoogleSignIn(
    clientId: iosClientId,
    serverClientId: webClientId,
  );

  final googleUser = await googleSignIn.signIn();
  final googleAuth = await googleUser!.authentication;
  final accessToken = googleAuth.accessToken;
  final idToken = googleAuth.idToken;

  if (accessToken == null) {
    throw 'No access token found.';
  }

  if (idToken == null) {
    throw 'No ID token found.';
  }

  await supabase.auth.signInWithIdToken(
    provider: OAuthProvider.google,
    idToken: idToken,
    accessToken: accessToken,
  )}
```

### Step 2: Create auth service

```bash
String? _userId;
  String? _username;
  String? _email;
  @override
  void initState() {
    super.initState();
    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        _userId = data.session?.user.id;
        _username = data.session?.user.userMetadata?['full_name'];
        _email = data.session?.user.email;
      });
    })

child: ElevatedButton(
onPressed: () async {
if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
await nativeGoogleSignIn();
} else {
await supabase.auth.signInWithOAuth(OAuthProvider.google);
}
},
);

```

### Step 3: Dependencies

```yaml
google_sign_in: ^5.4.0
supabase_flutter: ^2.12.0
flutter_dotenv: ^6.0.0
```
