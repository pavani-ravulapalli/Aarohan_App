import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:sizer/sizer.dart';
import 'package:aarohan_app/services/auth_services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aarohan_app/widgets/background_beams.dart';
import 'package:aarohan_app/screens/countdown_screen.dart';
import 'package:aarohan_app/screens/home_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(); // continuous rotation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /*void _handleSignIn() async {
    setState(() => _isLoading = true);

    AuthService authService = AuthService();
    authService.gSignIn().then((value) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (value != null) {
        // Navigate to the CountdownScreen instead of direct '/home'
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => CountdownScreen(
              // Set your desired target date & time here
              targetTime: DateTime.now().add(const Duration(seconds:15)), // Example: 15 seconds from now
              nextPage: HomePage(),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sign-in failed. Please try again."),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }*/
  void _handleSignIn() async {
    print("=== DEBUG: Login Button Pressed ===");
    setState(() => _isLoading = true);

    AuthService authService = AuthService();
    authService.gSignIn().then((value) {
      print("=== DEBUG: gSignIn returned value: $value ===");
      
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (value != null) {
        print("=== DEBUG: Navigating to CountdownScreen ===");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => CountdownScreen(
              // Set to 60 seconds from NOW for testing
              targetTime: DateTime.now().add(const Duration(seconds: 60)),
              nextPage: HomePage(),
            ),
          ),
        );
      } else {
        print("=== DEBUG: Sign-In failed or was cancelled by user ===");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sign-in failed. Please try again."),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }).catchError((error) {
      print("=== DEBUG: Exception in gSignIn: $error ===");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 11.h),

                    // 🔹 Spinning ring + static AR logo
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
                          Padding(
                            padding: const EdgeInsets.only(left: 5.5),
                            child: Image.asset(
                              'assets/ar.png',
                              width: 45.w,
                              height: 45.w,
                            ),
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

                    SizedBox(height: 7.h),

                    // 🔹 Sign-in button
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Animated beam border layer
                        SizedBox(
                          width: 60.w,
                          height: 7.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CustomPaint(
                              painter: BeamsPainter(
                                activeBeams: const [], // This will animate dynamically
                              ),
                              child: const SizedBox.expand(),
                            ),
                          ),
                        ),

                        // Button itself
                        Opacity(
                          opacity: _isLoading ? 0.8 : 1.0,
                          child: IgnorePointer(
                            ignoring: _isLoading,
                            child: Container(
                              width: 60.w,
                              height: 7.h,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: OutlineGradientButton(
                                onTap: _handleSignIn,
                                strokeWidth: 2,
                                radius: const Radius.circular(15),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromRGBO(167, 196, 252, 1),
                                    Color.fromRGBO(177, 196, 252, 1),
                                    Color.fromRGBO(193, 195, 252, 1),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                child: _isLoading
                                    ? Center(
                                        child: LoadingAnimationWidget
                                            .staggeredDotsWave(
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 8),
                                            child: Image.asset(
                                              'assets/google-logo.png',
                                              width: 28,
                                              height: 28,
                                            ),
                                          ),
                                          ShaderMask(
                                            shaderCallback: (bounds) =>
                                                const LinearGradient(
                                              colors: [
                                                Color.fromRGBO(
                                                    167, 196, 252, 1),
                                                Color.fromRGBO(
                                                    177, 196, 252, 1),
                                                Color.fromRGBO(
                                                    193, 195, 252, 1),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ).createShader(Rect.fromLTWH(
                                                    0,
                                                    0,
                                                    bounds.width,
                                                    bounds.height)),
                                            child: const Text(
                                              'Sign In With Google',
                                              style: TextStyle(
                                                fontFamily: 'Staat',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 21,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    //Opacity( opacity: _isLoading ? 0.8 : 1.0, child: IgnorePointer( ignoring: _isLoading, child: Container( width: 60.w, height: 7.h, decoration: BoxDecoration( color: Colors.transparent, borderRadius: BorderRadius.circular(15), boxShadow: [ BoxShadow( color: Colors.white.withOpacity(0.08), blurRadius: 12, spreadRadius: 2, offset: const Offset(0, 3), ), ], ), child: OutlineGradientButton( onTap: _handleSignIn, strokeWidth: 2, radius: const Radius.circular(15), gradient: const LinearGradient( colors: [ Color.fromARGB(200, 255, 255, 255), Color.fromARGB(80, 255, 255, 255), ], begin: Alignment.topLeft, end: Alignment.bottomRight, ), child: _isLoading ? Center( child: LoadingAnimationWidget .staggeredDotsWave( color: Colors.white, size: 40, ), ) : Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [ Padding( padding: const EdgeInsets.fromLTRB( 0, 8, 0, 8), child: Image.asset( 'assets/google.png', width: 28, height: 28, ), ), ShaderMask( shaderCallback: (bounds) => const LinearGradient( colors: [ Color.fromRGBO(167, 196, 252, 1), Color.fromRGBO(177, 196, 252, 1), Color.fromRGBO(193, 195, 252, 1), ], begin: Alignment.topLeft, end: Alignment.bottomRight, ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)), child: const Text( 'Sign In With Google', style: TextStyle( fontFamily: 'Staat', color: Colors .white, fontWeight: FontWeight.w400, fontSize: 21, letterSpacing: 0.5, ), ), ) ], ), ), ), ), ),

                    SizedBox(height: 5.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
