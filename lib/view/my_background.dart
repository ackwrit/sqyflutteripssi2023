import 'package:flutter/material.dart';
import 'package:ipssisqy2023/controller/custom_path.dart';
import 'package:ipssisqy2023/globale.dart';

class MyBackground extends StatefulWidget {
  const MyBackground({super.key});

  @override
  State<MyBackground> createState() => _MyBackgroundState();
}

class _MyBackgroundState extends State<MyBackground> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyCustomPath(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/girl.jpg"),
            fit: BoxFit.fill
          )
        ),
      ),
    );
  }
}
