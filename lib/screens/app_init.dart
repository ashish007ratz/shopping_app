import 'package:flutter/material.dart';
import 'package:shopping_app/Storage/Storage.dart';
import 'package:shopping_app/screens/auth/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  @override
  void initState() {
    setUpApp();
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _scaleAnimation = Tween<double>(
      begin: 1.2,
      end: 1.0,
    ).animate(_controller);

    _colorAnimation = ColorTween(
      begin: Colors.yellow,
      end: Colors.orange,
    ).animate(_controller);

    _backgroundColorAnimation = ColorTween(
      begin: Color.fromRGBO(185, 242, 247, 1.0), // Light green
      end: Color.fromRGBO(170, 233, 238, 1.0), // Darker green
    ).animate(_controller);
    _controller.forward();
  }

  setUpApp()async{
    await storage.init();
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=> SignInPage()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColorAnimation.value,
      body: Center(
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset(
              'lib/assets/images/sun.png', // Replace with your sun image
              color: _colorAnimation.value,
            ),
          ),
        ),
      ),
    );
  }
}
