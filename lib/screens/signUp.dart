import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/screens/home.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String email;
  late String password;
  late String confirmed;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final loginKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  late GoogleSignInAccount userObject;
  bool hiddenPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> SignUp() async {
      try {
        await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Signed In"),
          duration: Duration(milliseconds: 1000),
        ));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed with code: ${e.code}"),
          duration: const Duration(milliseconds: 1000),
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Form(
        key: loginKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal)),
                  hintText: 'email',
                ),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Email';
                  }
                  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                      .hasMatch(value)) {
                    return 'Please enter a valid Email';
                  }
                },
              ),
              TextFormField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: hiddenPassword,
                decoration:  InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  hintText: 'password',
                ),
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) =>
                    value!.length < 6 ? 'Password is too short' : null,
              ),
              TextFormField(
                  onChanged: (value) {
                    confirmed = value;
                  },
                  obscureText: hiddenPassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal)),
                    hintText: 'Confirm Password',
                    suffixIcon: IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            hiddenPassword = !hiddenPassword;
                          });
                        }),
                  ),
                  controller: _confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'Length is short';
                    }
                    if (password != confirmed) {
                      return 'Passwords do not match';
                    }
                  }),
              TextButton(
                child: const Text('Login'),
                onPressed: () {
                  if (loginKey.currentState!.validate()) {
                    email = _emailController.text;
                    password = _passwordController.text;
                    SignUp();
                  }
                },
              ),
              SizedBox(height: 40.0,),
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
            ],
          ),
        ),
      ),
    );
  }
}
