import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:PosTerminal/main.dart';

final user = supabase.auth.currentUser;

Future<void> insertData(String userId) async {
  await supabase.from(dotenv.env['SUPABASE_TABLE']!).upsert({
    'user_id': user?.id,
    'email': user?.email,
    'username': user?.userMetadata?['full_name'] ?? user?.userMetadata?['name'],
    'dp': user?.userMetadata?['avatar_url'],
  }, onConflict: 'user_id');
}

Future<Map<String, dynamic>?> getUserData(String userId) async {
  Map<String, dynamic>? user = await supabase
      .from(dotenv.env['SUPABASE_TABLE']!)
      .select('user_id,username, dp,email')
      .eq('user_id', userId)
      .maybeSingle();

  if (user!.isNotEmpty) {
    return user;
  }
  return null;
}

Future<List<Map<String, dynamic>>> getAllUsers() async {
  return await supabase.from(dotenv.env['SUPABASE_TABLE']!).select();
}
