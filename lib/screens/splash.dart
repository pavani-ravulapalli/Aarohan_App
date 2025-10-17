import 'dart:async';
import 'package:aarohan_app/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // 🔹 Rotation animation for the ring
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // 🔹 Navigate to Dashboard after 2 seconds
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return SafeArea(
          child: Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage("assets/aarohan_splash.png"),
                  colorFilter: ColorFilter.mode(
                    const Color.fromARGB(40, 0, 5, 26),
                    BlendMode.srcOver,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 11.h),
                  Padding(
                    padding: const EdgeInsets.only(left: 13.5),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        RotationTransition(
                          turns: _controller,
                          child: Image.asset(
                            'assets/ring.png',
                            width: 64.w,
                            height: 64.w,
                          ),
                        ),
                        Image.asset(
                          'assets/ar.png',
                          width: 40.w,
                          height: 40.w,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // 🔹 Aarohan text logo
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      'assets/aarohan_text.png',
                      height: 90,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // 🔹 Subtitle
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      'By Team Aavishkar',
                      style: TextStyle(
                        fontFamily: 'Bayon',
                        fontSize: 22,
                        letterSpacing: 1.5,
                        color: Color(0xFFACB9C9),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
