
import 'package:final_todo_firebase/auth/login/login.dart';
import 'package:final_todo_firebase/widgets/add_note.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
bool? isLogin;
// تشتغل ف حالة الباك background وال terminal
Future backgroundMessage(RemoteMessage remoteMessage)async
{
  print("66666666");
  print(remoteMessage.notification?.body);
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
);
  // تشتغل ف حاله ال تطبيق مغلق او ف الخلفية
  FirebaseMessaging.onBackgroundMessage(backgroundMessage);
  /////////////

// تستخدم عشان افتح ال notification فى حالة ال background

  var user = FirebaseAuth.instance.currentUser;
  if(user == null)
  {
    isLogin = false;
  }
  else
  {
    isLogin =true;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return     MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLogin == false ? const LoginScreen() : const HomePage(),
    );
  }
}
