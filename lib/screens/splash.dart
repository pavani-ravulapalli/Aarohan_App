import 'dart:async';
import 'dart:math';
import 'package:aarohan_app/screens/countdown_screen.dart';
import 'package:aarohan_app/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();

    // Smooth background animation controller
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // 🔹 Navigate to Countdown Screen targeting October 9, 2026
    Timer(const Duration(milliseconds: 2800), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CountdownScreen(
            targetTime: DateTime(2026, 10, 9),
            nextPage:  Dashboard(),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: const Color(0xFF050102),
          body: Stack(
            children: [
              // 1. Dynamic Minimalist Red-Black Background
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _bgController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _MinimalCyberSplashPainter(
                        progress: _bgController.value,
                      ),
                    );
                  },
                ),
              ),

              // 2. Centered Foreground Content
              Positioned.fill(
                child: SafeArea(
                  child: SizedBox.expand(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2),

                        // Aarohan Text Logo & Team Badge
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Aarohan Text Logo Image
                            Image.asset(
                              'assets/aarohan_text.png',
                              width: 75.w,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                              errorBuilder: (context, error, stackTrace) => Text(
                                'AAROHAN',
                                style: GoogleFonts.orbitron(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 4,
                                ),
                              ),
                            ),

                            SizedBox(height: 2.2.h),

                            // Subtitle Badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.5.w,
                                vertical: 0.8.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF1E27).withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFFFF1E27).withOpacity(0.35),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF1E27).withOpacity(0.12),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Text(
                                'BY TEAM AAVISHKAR',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFFF6B6B),
                                  letterSpacing: 2.2,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(flex: 3),

                        // Minimal Progress Bar
                        Padding(
                          padding: EdgeInsets.only(bottom: 3.h),
                          child: SizedBox(
                            width: 38.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.white.withOpacity(0.08),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFFFF1E27),
                                ),
                                minHeight: 2.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Minimal Cyber Background Painter
class _MinimalCyberSplashPainter extends CustomPainter {
  final double progress;

  _MinimalCyberSplashPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // 1. Dark Radial Background
    final bgPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, -0.1),
        radius: 1.25,
        colors: [
          Color.lerp(
            const Color(0xFF2B0308),
            const Color(0xFF38040B),
            (sin(progress * 2 * pi) + 1) / 2,
          )!,
          const Color(0xFF0F0204),
          const Color(0xFF050102),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // 2. Subtle Scanning Laser Sweep
    final double scanY = (progress * h * 1.2) - (h * 0.1);
    final scanLinePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          const Color(0xFFFF1E27).withOpacity(0.22),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, scanY - 1, w, 2));

    canvas.drawRect(Rect.fromLTWH(0, scanY - 1, w, 2), scanLinePaint);

    // 3. Floating Ambient Particles
    final rand = Random(42);
    final particlePaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      final double xRatio = rand.nextDouble();
      final double yRatio = rand.nextDouble();
      final double speed = rand.nextDouble() * 0.4 + 0.2;
      final double pSize = rand.nextDouble() * 1.5 + 0.8;

      final double currY = ((yRatio - (progress * speed)) % 1.0) * h;
      final double currX = xRatio * w;
      final double opacity = sin((currY / h) * pi) * 0.55;

      particlePaint.color = const Color(0xFFFF3D00).withOpacity(opacity.clamp(0.0, 1.0));
      canvas.drawCircle(Offset(currX, currY), pSize, particlePaint);
    }

    // 4. Vector Grid
    final gridPaint = Paint()
      ..color = const Color(0xFFFF1E27).withOpacity(0.03)
      ..strokeWidth = 0.8;

    const double step = 50;
    for (double x = 0; x < w; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), gridPaint);
    }
    for (double y = 0; y < h; y += step) {
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MinimalCyberSplashPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}