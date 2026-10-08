import 'home_page.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class CountdownScreen extends StatefulWidget {
  final DateTime? targetTime;
  final Widget? nextPage;

  const CountdownScreen({
    super.key,
    this.targetTime,
    this.nextPage,
  });

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;
  late final DateTime _targetDate;

  @override
  void initState() {
    super.initState();
    // Default target time set to 9th October 2026
    _targetDate = widget.targetTime ?? DateTime(2026, 10, 9);
    _calculateTimeLeft();
    _startTimer();
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    final difference = _targetDate.difference(now);

    if (difference.isNegative || difference == Duration.zero) {
      setState(() => _timeLeft = Duration.zero);
      _onCountdownFinished();
    } else {
      setState(() => _timeLeft = difference);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final difference = _targetDate.difference(now);

      if (difference.isNegative || difference == Duration.zero) {
        timer.cancel();
        if (mounted) {
          setState(() => _timeLeft = Duration.zero);
        }
        _onCountdownFinished();
      } else {
        if (mounted) {
          setState(() => _timeLeft = difference);
        }
      }
    });
  }

  void _onCountdownFinished() {
    _timer?.cancel();
    if (mounted) {
      if (widget.nextPage != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => widget.nextPage!),
        );
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours.remainder(24);
    final minutes = _timeLeft.inMinutes.remainder(60);
    final seconds = _timeLeft.inSeconds.remainder(60);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Background Image with Relative Fill
          Positioned.fill(
            child: Image.asset(
              'assets/images/lastbg.png',
              fit: BoxFit.cover,
            ),
          ),

          // 2. Positioned Widget for the AAROHAN Logo
          Positioned(
            top: 13.h,
            left: 12.w,
            child: SizedBox(
              width: 75.w,
              child: Image.asset(
                'assets/images/AAROHAN26.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Text(
                  "AAROHAN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),

          // 3. Positioned Widget for the Tagline
          Positioned(
            top: 28.h,
            left: 11.w,
            child: Text(
              "RISE BY INSTINCT. RULE BY INNOVATION.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11.sp,
                fontStyle: FontStyle.italic,
                letterSpacing: 1.2,
              ),
            ),
          ),

          // 4. Central Frame with Scaled-Up Timer
          Center(
            child: SizedBox(
              width: 95.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.dstOut,
                    ),
                    child: Image.asset(
                      'assets/images/frame-removebg-preview.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF140C10).withValues(alpha: 0.9),
                          border: Border.all(
                            color: const Color(0xFFE52E4D),
                            width: 12.5,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        colors: [Colors.white, Colors.white],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.modulate,
                    child: Image.asset(
                      'assets/images/frame-removebg-preview.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 1.5.h,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTimeUnit(
                              days.toString().padLeft(2, '0'), "DAYS"),
                          _buildColon(),
                          _buildTimeUnit(
                              hours.toString().padLeft(2, '0'), "HOURS"),
                          _buildColon(),
                          _buildTimeUnit(
                              minutes.toString().padLeft(2, '0'), "MINS"),
                          _buildColon(),
                          _buildTimeUnit(
                              seconds.toString().padLeft(2, '0'), "SECS"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 5. Bottom Dates Pill Banner with Relative Sizing
          /*Positioned(
            bottom: 27.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.2.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  border: Border.all(
                    color: const Color(0xFFE52E4D).withValues(alpha: 0.6),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "The Countdown Has Begun!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        shadows: [
                          Shadow(
                            color: const Color(0xFFFF3B5C).withValues(alpha: 0.9),
                            blurRadius: 20,
                          ),
                          Shadow(
                            color: const Color(0xFFE52E4D).withValues(alpha: 0.8),
                            blurRadius: 36,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 0.4.h),
                    Text(
                      "Are You Ready?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        shadows: [
                          Shadow(
                            color: const Color(0xFFFF3B5C).withValues(alpha: 0.8),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),*/
          // Bottom Text Block (Pill Removed)
          Positioned(
            bottom: 30.h,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "The Countdown Has Begun!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.5,
                    /*shadows: [
                      Shadow(
                        color: const Color(0xFFFF3B5C).withValues(alpha: 0.9),
                        blurRadius: 20,
                      ),
                      Shadow(
                        color: const Color(0xFFE52E4D).withValues(alpha: 0.8),
                        blurRadius: 36,
                      ),
                    ],*/
                  ),
                ),
                SizedBox(height: 0.1.h),
                Text(
                  "Are You Ready?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    color: Colors.redAccent,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.5,
                    /*foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2.0
                      ..color = Colors.white.withOpacity(0.8),*/
                    /*shadows: [
                      Shadow(
                        color: Colors.white.withOpacity(0.9),
                        blurRadius: 20,
                      ),
                      Shadow(
                        color: Colors.white.withValues(alpha: 0.6),
                        blurRadius: 36,
                      ),
                    ],*/
                  ),
                ),
      
              ],
            ),
          ),

           
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildGlowValue(value),
        SizedBox(height: 0.8.h),
        _buildLabel(label),
      ],
    );
  }

  Widget _buildGlowValue(String value) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w900,
        fontFamily: 'monospace',
        color: Colors.white,
        shadows: [
          Shadow(
            color: const Color(0xFFFF3B5C).withValues(alpha: 0.9),
            blurRadius: 20,
          ),
          Shadow(
            color: const Color(0xFFE52E4D).withValues(alpha: 0.8),
            blurRadius: 36,
          ),
        ],
      ),
    );
  }

  Widget _buildColon() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.5.w),
      child: Text(
        ":",
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: const Color(0xFFFF3B5C).withValues(alpha: 0.9),
              blurRadius: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: const Color(0xFFFF4D6D),
        fontSize: 9.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: 2.0,
        shadows: [
          Shadow(
            color: const Color(0xFFE52E4D).withValues(alpha: 0.8),
            blurRadius: 12,
          ),
        ],
      ),
    );
  }
}