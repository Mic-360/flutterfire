import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/screens/login.dart';

class Home extends StatefulWidget {
  const Home(
      {super.key, required this.id, required this.email, required this.name});

  final String id;
  final String name;
  final String email;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> datas =
        FirebaseFirestore.instance.collection(widget.id).snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.name),
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut(); //!LogOut
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: datas,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Some fuckn error"),
                      duration: Duration(milliseconds: 1000),
                    ));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final List store = [];
                  snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map a = document.data() as Map<String, dynamic>;
                    store.add(a);
                    a['id'] = document.id;
                  }).toList();

                  return Column(
                    children: List.generate(
                      store.length,
                      (i) => Column(
                        children: [
                          Text(
                            store[i]['text'],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            store[i]['text'],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
