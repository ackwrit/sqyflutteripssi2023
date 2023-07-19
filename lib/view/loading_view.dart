import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyLoading extends StatefulWidget {
  const MyLoading({super.key});

  @override
  State<MyLoading> createState() => _MyLoadingState();
}

class _MyLoadingState extends State<MyLoading> {
  //variable
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageView(
        children:[
          Center(
            child: Lottie.asset("assets/01.json"),
          ),
          Center(
            child: Lottie.asset("assets/02.json"),
          ),
          Center(
            child: Lottie.asset("assets/03.json"),
          ),
        ],
        controller: pageController,


      ),
    );
  }
}
