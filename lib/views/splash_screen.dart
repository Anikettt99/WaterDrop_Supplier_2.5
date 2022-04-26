import 'dart:async';
import 'package:flutter/material.dart';
import 'package:waterdrop_supplier/views/landing_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  var timer;


  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.easeIn);

    timer = Timer(
        const Duration(milliseconds: 2000),
        () => Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (c, a1, a2) => const LandingPage(),
                transitionsBuilder: (c, anim, a2, child) => FadeTransition(
                      opacity: anim,
                      child: child,
                    ),
              transitionDuration: const Duration(milliseconds: 2000)
            )));


    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    timer.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation!,
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Image.asset('assets/Supplier Logo.png'),
      ),
    );
  }
}
