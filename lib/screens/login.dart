import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire/screens/home.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String email;
  final TextEditingController _emailController = TextEditingController();
  late String password;
  final TextEditingController _passwordController = TextEditingController();
  final loginKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  late GoogleSignInAccount userObject;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> loggedin() async {
      try {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            padding: EdgeInsets.all(20),
            content: Text('Login Successful'),
            leading: Icon(Icons.agriculture_outlined),
            backgroundColor: Colors.green,
            actions: <Widget>[
              // TextButton(
              //   onPressed: null,
              //   child: Text('DISMISS'),
              // ),
            ],
          ),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            padding: EdgeInsets.all(20),
            content: Text('Login Unsuccessful: ${e.code}'),
            leading: Icon(Icons.agriculture_outlined),
            backgroundColor: Colors.red,
            actions: <Widget>[
              // TextButton(
              //   onPressed: null,
              //   child: Text('DISMISS'),
              // ),
            ],
          ),
        );
      }
      {}
    }

    return Scaffold(
      appBar: AppBar(title: Text('Login Page')),
      backgroundColor: Colors.blueGrey,
      body: Form(
        key: loginKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(child: Container(), flex: 1),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your Email',
                ),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter the Mail Address';
                  }
                  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                      .hasMatch(value)) {
                    return 'Please Enter a Valid Mail';
                  }
                },
              ),
            ),
            // SizedBox(height: 20.0,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your Password',
                ),
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) =>
                    value!.length < 6 ? 'Password is too short' : null,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  if (loginKey.currentState!.validate()) {
                    email = _emailController.text;
                    password = _passwordController.text;
                    loggedin();
                  }
                }),
            SizedBox(
              height: 20.0,
            ),
            TextButton(
              child: Text('Google Sign in'),
              onPressed: () async {
                final GoogleSignInAccount googleUser =
                    await GoogleSignIn().signIn().then((value) {
                  setState(() {
                    userObject = value!;
                  });
                  return userObject;
                });

                final GoogleSignInAuthentication googleAuth =
                    await googleUser.authentication;

                auth.signInWithCredential(GoogleAuthProvider.credential(
                    accessToken: googleAuth.accessToken,
                    idToken: googleAuth.idToken));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(
                      email: userObject.email,
                      name: userObject.displayName.toString(),
                    ),
                  ),
                );
              },
            ),
            Flexible(child: Container(), flex: 1),
          ],
        ),
      ),
    );
  }
}
