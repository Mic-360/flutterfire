import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                child: const Text('Login'),
                onPressed: () => loggedin(),
              ),
              Flexible(child: Container(), flex: 1),
            ],
          )),
    );
  }
}
