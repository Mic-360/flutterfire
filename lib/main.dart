import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/screens/home.dart';
import 'package:flutterfire/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _init = Firebase.initializeApp();
  late StreamSubscription<User?> user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((event) {});
  }

  @override
  void dispose() {
    super.dispose();
    user.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error'),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Flutter fire',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              primarySwatch: Colors.blue,
            ),
            home: FirebaseAuth.instance.currentUser == null
                ? const Login()
                : Home(
                    email: FirebaseAuth.instance.currentUser!.email.toString(),
                    name: FirebaseAuth.instance.currentUser!.displayName
                        .toString(),
                    id: FirebaseAuth.instance.currentUser!.uid,
                  ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
