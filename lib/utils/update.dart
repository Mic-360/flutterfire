import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Update extends StatefulWidget {
  const Update({Key? key, required this.id, required this.collection})
      : super(key: key);

  final String id;
  final String collection;

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  final TextEditingController textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

     CollectionReference updater =
        FirebaseFirestore.instance.collection(widget.collection.toString());

    Future<void> updateUser(id, fText) {
      return updater
          .doc(id)
          .update({'text': fText})
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Info Updated'),
              ),
            ),
          )
          .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Failed to update user: $error"),
              ),
            ),
          );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update'),
      ),
      body: Form(
          key: _formKey,
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection(widget.collection.toString())
                .doc(widget.id)
                .get(),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                print('Something Went Wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var data = snapshot.data!.data();
              textController.text = data!['text'];

              return Column(
                children: [
                  TextButton(
                    child: const Text(
                      'Update to firebase',
                      style: TextStyle(color: Colors.amber),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () {
                       if (_formKey.currentState!.validate()) {
                        updateUser(widget.id, textController.text);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              );
            },
          )),
    );
  }
}
