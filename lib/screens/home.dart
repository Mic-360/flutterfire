import 'package:flutter/cupertino.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.email, required this.name});

  final String name;
  final String email;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.name),
    );
  }
}
