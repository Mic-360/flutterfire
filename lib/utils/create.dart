import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Add extends StatefulWidget {
  const Add({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final TextEditingController textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String text = 'none';
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference reference =
        FirebaseFirestore.instance.collection(widget.id);

    Object add() {
      try {
        return reference.add({
          'text': text,
        }).then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('added data to firestore database'),
            ),
          ),
        );
      } on FirebaseException catch (e) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.code),
          ),
        );
      }
    }

    return Scaffold(
      body: Form(
        child: Column(
          children: [
            TextButton(
              child: const Text(
                'Add to firebase',
                style: TextStyle(color: Colors.amber),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    text:
                    text;
                  });
                  add();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
