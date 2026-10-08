import 'dart:math';
import 'package:aarohan_app/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:aarohan_app/services/auth_services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'countdown_screen.dart';
import 'home_page.dart';

// Pure Flutter Vector Google "G" Logo
class GoogleLogoIcon extends StatelessWidget {
  final double size;
  const GoogleLogoIcon({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final paint = Paint()..style = PaintingStyle.fill;

    // Red
    paint.color = const Color(0xFFEA4335);
    final pathRed = Path()
      ..moveTo(w * 0.5, h * 0.21)
      ..cubicTo(w * 0.61, h * 0.21, w * 0.71, h * 0.25, w * 0.78, h * 0.31)
      ..lineTo(w * 0.92, h * 0.17)
      ..cubicTo(w * 0.81, h * 0.06, w * 0.67, 0, w * 0.5, 0)
      ..cubicTo(w * 0.31, 0, w * 0.14, h * 0.11, w * 0.06, h * 0.27)
      ..lineTo(w * 0.23, h * 0.40)
      ..cubicTo(w * 0.28, h * 0.29, w * 0.38, h * 0.21, w * 0.5, h * 0.21);
    canvas.drawPath(pathRed, paint);

    // Blue
    paint.color = const Color(0xFF4285F4);
    final pathBlue = Path()
      ..moveTo(w, h * 0.5)
      ..cubicTo(w, h * 0.44, w * 0.99, h * 0.38, w * 0.98, h * 0.32)
      ..lineTo(w * 0.5, h * 0.32)
      ..lineTo(w * 0.5, h * 0.52)
      ..lineTo(w * 0.78, h * 0.52)
      ..cubicTo(w * 0.77, h * 0.61, w * 0.71, h * 0.69, w * 0.62, h * 0.75)
      ..lineTo(w * 0.79, h * 0.88)
      ..cubicTo(w * 0.91, h * 0.77, w, h * 0.65, w, h * 0.5);
    canvas.drawPath(pathBlue, paint);

    // Green
    paint.color = const Color(0xFF34A853);
    final pathGreen = Path()
      ..moveTo(w * 0.5, h)
      ..cubicTo(w * 0.67, h, w * 0.81, h * 0.94, w * 0.91, h * 0.85)
      ..lineTo(w * 0.74, h * 0.72)
      ..cubicTo(w * 0.68, h * 0.76, w * 0.6, h * 0.79, w * 0.5, h * 0.79)
      ..cubicTo(w * 0.38, h * 0.79, w * 0.28, h * 0.71, w * 0.23, h * 0.60)
      ..lineTo(w * 0.06, h * 0.73)
      ..cubicTo(w * 0.14, h * 0.89, w * 0.31, h, w * 0.5, h);
    canvas.drawPath(pathGreen, paint);

    // Yellow
    paint.color = const Color(0xFFFBBC05);
    final pathYellow = Path()
      ..moveTo(w * 0.23, h * 0.60)
      ..cubicTo(w * 0.21, h * 0.54, w * 0.21, h * 0.46, w * 0.23, h * 0.40)
      ..lineTo(w * 0.06, h * 0.27)
      ..cubicTo(0, h * 0.39, 0, h * 0.61, w * 0.06, h * 0.73)
      ..lineTo(w * 0.23, h * 0.60);
    canvas.drawPath(pathYellow, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Background Painter with Connected Graphs and Ribbons
class TechFestBackgroundPainter extends CustomPainter {
  final double progress;

  TechFestBackgroundPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // 1. Deep Red-Black Dark Radial Background
    final bgPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0.0, -0.1),
        radius: 1.25,
        colors: [
          Color(0xFF260307),
          Color(0xFF0F0204),
          Color(0xFF050102),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // 2. Render Connected Node-Graph Clusters (Simple dots, no glow)
    _drawConnectedGraphs(canvas, size);

    // 3. Render Ribbons starting below the Aarohan logo text
    final double t = progress * 2 * pi;

    // Ribbon 1
    _drawRibbon(
      canvas,
      size,
      baseY: h * 0.85,
      amplitude1: 40,
      amplitude2: 25,
      frequency1: 1.2,
      frequency2: 2.1,
      phase: t,
      ribbonThickness: 50,
      color1: const Color(0xFFFF1E27).withOpacity(0.18),
      color2: const Color(0xFFFF5252).withOpacity(0.02),
      edgeColor: const Color(0xFFFF4D4D).withOpacity(0.55),
    );

    // Ribbon 2
    _drawRibbon(
      canvas,
      size,
      baseY: h * 0.45,
      amplitude1: 50,
      amplitude2: 30,
      frequency1: 0.9,
      frequency2: 1.7,
      phase: t + 1.8,
      ribbonThickness: 65,
      color1: const Color(0xFFFF2A32).withOpacity(0.15),
      color2: const Color(0xFF800000).withOpacity(0.02),
      edgeColor: const Color(0xFFFF3D00).withOpacity(0.45),
    );

    // Ribbon 3
    _drawRibbon(
      canvas,
      size,
      baseY: h * 0.65,
      amplitude1: 60,
      amplitude2: 20,
      frequency1: 1.5,
      frequency2: 2.8,
      phase: t * 0.8 + 3.2,
      ribbonThickness: 28,
      color1: const Color(0xFFFF7A7A).withOpacity(0.12),
      color2: Colors.transparent,
      edgeColor: const Color(0xFFFF8A8A).withOpacity(0.60),
    );
  }

  // Draw 4 distinct connected graph networks
  void _drawConnectedGraphs(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = const Color(0xFFFF1E27).withOpacity(0.18);

    final nodePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFFF6B6B).withOpacity(0.35);

    // 4 Distinct Graph Node Clusters
    final List<List<Offset>> graphClusters = [
      // Graph 1: Top Left
      [
        Offset(w * 0.08, h * 0.12),
        Offset(w * 0.20, h * 0.08),
        Offset(w * 0.16, h * 0.20),
        Offset(w * 0.28, h * 0.15),
      ],
      // Graph 2: Top Right
      [
        Offset(w * 0.74, h * 0.10),
        Offset(w * 0.88, h * 0.14),
        Offset(w * 0.80, h * 0.24),
        Offset(w * 0.92, h * 0.26),
      ],
      // Graph 3: Mid Right
      [
        Offset(w * 0.72, h * 0.48),
        Offset(w * 0.86, h * 0.42),
        Offset(w * 0.82, h * 0.58),
        Offset(w * 0.94, h * 0.52),
      ],
      // Graph 4: Bottom Left
      [
        Offset(w * 0.06, h * 0.72),
        Offset(w * 0.18, h * 0.66),
        Offset(w * 0.12, h * 0.82),
        Offset(w * 0.24, h * 0.76),
      ],
    ];

    // Edges linking nodes inside each cluster
    final List<List<List<int>>> clusterEdges = [
      [ [0, 1], [1, 2], [1, 3], [2, 3] ], // Edges for Graph 1
      [ [0, 1], [0, 2], [1, 3], [2, 3] ], // Edges for Graph 2
      [ [0, 1], [0, 2], [1, 3], [2, 3] ], // Edges for Graph 3
      [ [0, 1], [0, 2], [1, 3], [2, 3] ], // Edges for Graph 4
    ];

    for (int g = 0; g < graphClusters.length; g++) {
      final nodes = graphClusters[g];
      final edges = clusterEdges[g];

      // Draw Edges
      for (final edge in edges) {
        final p1 = nodes[edge[0]];
        final p2 = nodes[edge[1]];
        canvas.drawLine(p1, p2, linePaint);
      }

      // Draw Simple Dots (No Glow)
      for (final node in nodes) {
        canvas.drawCircle(node, 2.2, nodePaint);
      }
    }
  }

  void _drawRibbon(
      Canvas canvas,
      Size size, {
        required double baseY,
        required double amplitude1,
        required double amplitude2,
        required double frequency1,
        required double frequency2,
        required double phase,
        required double ribbonThickness,
        required Color color1,
        required Color color2,
        required Color edgeColor,
      }) {
    final double w = size.width;
    const int segments = 45;
    final double step = (w + 100) / segments;

    final List<Offset> topCurve = [];
    final List<Offset> bottomCurve = [];

    for (int i = 0; i <= segments; i++) {
      final double x = -50 + i * step;
      final double normX = x / w;

      final double wave1 =
          sin(normX * frequency1 * 2 * pi + phase) * amplitude1;
      final double wave2 =
          cos(normX * frequency2 * 2 * pi - phase * 0.7) * amplitude2;

      final double currentY = baseY + wave1 + wave2;

      final double thick =
          ribbonThickness * (0.6 + 0.4 * sin(normX * pi * 2 + phase));

      topCurve.add(Offset(x, currentY - thick * 0.5));
      bottomCurve.add(Offset(x, currentY + thick * 0.5));
    }

    final Path ribbonPath = Path();
    ribbonPath.moveTo(topCurve.first.dx, topCurve.first.dy);

    for (int i = 1; i < topCurve.length; i++) {
      final p0 = topCurve[i - 1];
      final p1 = topCurve[i];
      ribbonPath.quadraticBezierTo(
        p0.dx,
        p0.dy,
        (p0.dx + p1.dx) / 2,
        (p0.dy + p1.dy) / 2,
      );
    }
    ribbonPath.lineTo(topCurve.last.dx, topCurve.last.dy);

    for (int i = bottomCurve.length - 1; i >= 0; i--) {
      final p = bottomCurve[i];
      ribbonPath.lineTo(p.dx, p.dy);
    }
    ribbonPath.close();

    final ribbonPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color1, color2],
      ).createShader(Rect.fromLTWH(0, 0, w, size.height));

    canvas.drawPath(ribbonPath, ribbonPaint);

    final Path topEdgePath = Path();
    topEdgePath.moveTo(topCurve.first.dx, topCurve.first.dy);
    for (int i = 1; i < topCurve.length; i++) {
      final p0 = topCurve[i - 1];
      final p1 = topCurve[i];
      topEdgePath.quadraticBezierTo(
        p0.dx,
        p0.dy,
        (p0.dx + p1.dx) / 2,
        (p0.dy + p1.dy) / 2,
      );
    }

    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = edgeColor;

    canvas.drawPath(topEdgePath, edgePaint);
  }

  @override
  bool shouldRepaint(covariant TechFestBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _isPressed = false;

  late final AnimationController _entranceController;
  late final AnimationController _floatController;
  late final AnimationController _bgController;

  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _heroScale;
  late final Animation<double> _heroFade;
  late final List<Animation<double>> _pillFades;
  late final Animation<double> _buttonFade;
  late final Animation<Offset> _buttonSlide;

  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(-0.1, -0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic),
      ),
    );

    _heroFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.20, 0.55, curve: Curves.easeOut),
      ),
    );
    _heroScale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.20, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    _pillFades = List.generate(4, (i) {
      final start = 0.45 + (i * 0.08);
      final end = (start + 0.25).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _entranceController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.70, 1.0, curve: Curves.easeOut),
      ),
    );
    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.70, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    _floatAnimation = CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOutSine,
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _entranceController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (_isLoading) return;
    HapticFeedback.lightImpact();
    setState(() => _isLoading = true);

    try {
      final value = await AuthService().gSignIn();
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (value != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Splash()
          ),
        );
      } else {
        _showToast("Sign-in cancelled.");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showToast("Error: $e");
    }
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1E1A22),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text(
          msg,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: const Color(0xFF050102),
          body: Stack(
            children: [
              // Dynamic Ribbon & Graph Background
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _bgController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: TechFestBackgroundPainter(
                        progress: _bgController.value,
                      ),
                    );
                  },
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),

                      // Top Bar: Logo on Top Left
                      FadeTransition(
                        opacity: _headerFade,
                        child: SlideTransition(
                          position: _headerSlide,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Top Left Logo
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFF1E27)
                                              .withOpacity(0.35),
                                          blurRadius: 14,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      'assets/aarohan_logo.png',
                                      height: 60,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),

                              // Team Badge
                              /*Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF1E27)
                                      .withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFFF1E27)
                                        .withOpacity(0.35),
                                  ),
                                ),
                                child: Text(
                                  'BY TEAM AAVISHKAR',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFF6B6B),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),*/
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(height: 6.h),

                              // Central Hero Spot: Text Logo & Tagline
                              FadeTransition(
                                opacity: _heroFade,
                                child: ScaleTransition(
                                  scale: _heroScale,
                                  child: AnimatedBuilder(
                                    animation: _floatAnimation,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(
                                          0,
                                          80 + (_floatAnimation.value * 12),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,

                                          children: [
                                            // Red Backdrop Ambient Glow
                                            Container(
                                              width: 65.w,
                                              height: 20.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(100),
                                                gradient: RadialGradient(
                                                  colors: [
                                                    const Color(0xFFFF1E27)
                                                        .withOpacity(0.28),
                                                    const Color(0xFF800000)
                                                        .withOpacity(0.12),
                                                    Colors.transparent,
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Image.asset(
                                                  'assets/aarohan_text.png',
                                                  width: 70.w,
                                                  fit: BoxFit.contain,
                                                  filterQuality:
                                                  FilterQuality.high,
                                                ),
                                                const SizedBox(height: 14),
                                                Text(
                                                  'Rise by Instinct. Rule by Innovation',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 15,
                                                    color: Colors.white
                                                        .withOpacity(0.75),
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                                Container(

                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                                /*decoration: BoxDecoration(
                                  color: const Color(0xFFFF1E27)
                                      .withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFFF1E27)
                                        .withOpacity(0.35),
                                  ),
                                ),*/
                                child: Text(
                                  'BY TEAM AAVISHKAR',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFAC6A71),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              SizedBox(height: 7.h),

                              // Feature Pills
                              /*Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  _buildFeaturePill(
                                      Icons.stars_rounded, 'Events', 0),
                                  _buildFeaturePill(Icons.emoji_events_outlined,
                                      'Competitions', 1),
                                  _buildFeaturePill(
                                      Icons.groups_outlined, 'Workshops', 2),
                                  _buildFeaturePill(
                                      Icons.flash_on_outlined, 'Rock Night', 3),
                                ],
                              ),*/

                              SizedBox(height: 3.h),
                            ],
                          ),
                        ),
                      ),

                      // Google Sign-In Button
                      FadeTransition(
                        opacity: _buttonFade,
                        child: SlideTransition(
                          position: _buttonSlide,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTapDown: (_) =>
                                      setState(() => _isPressed = true),
                                  onTapUp: (_) =>
                                      setState(() => _isPressed = false),
                                  onTapCancel: () =>
                                      setState(() => _isPressed = false),
                                  onTap: _handleSignIn,
                                  child: AnimatedScale(
                                    scale: _isPressed ? 0.98 : 1.0,
                                    duration: const Duration(milliseconds: 100),
                                    child: Container(
                                      width: double.infinity,
                                      height: 54,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.black.withOpacity(0.45),
                                            blurRadius: 18,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: AnimatedSwitcher(
                                        duration:
                                        const Duration(milliseconds: 180),
                                        child: _isLoading
                                            ? Center(
                                          child: LoadingAnimationWidget
                                              .twoRotatingArc(
                                            color:
                                            const Color(0xFFFF1E27),
                                            size: 24,
                                          ),
                                        )
                                            : Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            const GoogleLogoIcon(
                                                size: 20),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Continue with Google',
                                              style: GoogleFonts.inter(
                                                fontSize: 15.5,
                                                fontWeight:
                                                FontWeight.w600,
                                                color: const Color(
                                                    0xFF1F1F1F),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeaturePill(IconData icon, String label, int index) {
    return FadeTransition(
      opacity: _pillFades[index],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF140508).withOpacity(0.80),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFFF1E27).withOpacity(0.25),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: const Color(0xFFFF3D00),
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.85),
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}