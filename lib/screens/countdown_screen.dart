/*import 'dart:async';
import 'package:flutter/material.dart';

class CountdownScreen extends StatefulWidget {
  /// Target time when the countdown ends.
  final DateTime targetTime;

  /// Callback or navigation destination when the countdown reaches 0.
  final Widget nextPage;

  const CountdownScreen({
    super.key,
    required this.targetTime,
    required this.nextPage,
  });

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _startTimer();
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    final difference = widget.targetTime.difference(now);

    if (difference.isNegative || difference == Duration.zero) {
      setState(() {
        _timeLeft = Duration.zero;
      });
      _onCountdownFinished();
    } else {
      setState(() {
        _timeLeft = difference;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final difference = widget.targetTime.difference(now);

      if (difference.isNegative || difference == Duration.zero) {
        timer.cancel();
        setState(() {
          _timeLeft = Duration.zero;
        });
        _onCountdownFinished();
      } else {
        setState(() {
          _timeLeft = difference;
        });
      }
    });
  }

  void _onCountdownFinished() {
    _timer?.cancel();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => widget.nextPage),
      );
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Red & Dark Grey Gradient Theme
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E1E24), // Dark Charcoal Grey
              Color(0xFFB71C1C), // Deep Crimson Red
              Color(0xFF121212), // Pitch Grey/Black
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'AAROHAN',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'EVENT STARTS IN',
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 2,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 48),

              // Countdown Cards Display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimeCard(days.toString().padLeft(2, '0'), 'DAYS'),
                  _buildColon(),
                  _buildTimeCard(hours.toString().padLeft(2, '0'), 'HOURS'),
                  _buildColon(),
                  _buildTimeCard(minutes.toString().padLeft(2, '0'), 'MINS'),
                  _buildColon(),
                  _buildTimeCard(seconds.toString().padLeft(2, '0'), 'SECS'),
                ],
              ),

              const SizedBox(height: 48),

              // Skip / Force Enter Button (Optional for testing)
              TextButton(
                onPressed: _onCountdownFinished,
                child: const Text(
                  'Skip to Home',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColon() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white54,
        ),
      ),
    );
  }

  Widget _buildTimeCard(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withValues(alpha: 0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            letterSpacing: 1,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }
}*/

import 'home_page.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CountdownScreen extends StatefulWidget {
  final DateTime targetTime;
  final Widget nextPage;

  const CountdownScreen({
    super.key,
    required this.targetTime,
    required this.nextPage,
  });

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _startTimer();
    _initVideoPlayer();
  }

  void _initVideoPlayer() async {
    _videoController = VideoPlayerController.asset('assets/videos/countdown_bg.mp4');
    try {
      await _videoController.initialize();
      _videoController.setLooping(true);
      _videoController.setVolume(0.0);
      _videoController.play();
      setState(() {
        _isVideoInitialized = true;
      });
    } catch (e) {
      debugPrint("Error initializing video player: $e");
    }
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    final difference = widget.targetTime.difference(now);

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
      final difference = widget.targetTime.difference(now);

      if (difference.isNegative || difference == Duration.zero) {
        timer.cancel();
        setState(() => _timeLeft = Duration.zero);
        _onCountdownFinished();
      } else {
        setState(() => _timeLeft = difference);
      }
    });
  }

  void _onCountdownFinished() {
    _timer?.cancel();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => widget.nextPage),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _videoController.dispose();
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
          // 1. Full-Screen Background Rotating Wheel Video Loop (Edge-to-Edge)
          Positioned.fill(
            child: _isVideoInitialized
                ? SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _videoController.value.size.width,
                        height: _videoController.value.size.height,
                        child: VideoPlayer(_videoController),
                      ),
                    ),
                  )
                : Container(color: Colors.black),
          ),

          // 2. Top-Left Metallic AR Logo
          Positioned(
            top: 48,
            left: 24,
            child: SafeArea(
              child: Image.asset(
                'assets/images/AR.png',
                width: 70,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Text(
                  "AR",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),

          // 3. Central Frame with Solid/Textured Center and Transparent Outer Space
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.92,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Frame Image (Using BlendMode.screen or .plus to make the dark/black outer areas transparent while keeping the center solid/textured)
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.dstOut,
                    ),
                    child: Image.asset(
                      'assets/images/frame-removebg-preview.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 140,
                        decoration: BoxDecoration(
                          color: const Color(0xFF140C10).withValues(alpha: 0.9),
                          border: Border.all(color: const Color(0xFFE52E4D), width: 1.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),

                  // Actual Visible Frame Layer (Using standard blend to keep center intact)
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

                  // Timer Numbers & Labels Layer perfectly aligned inside the frame
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Numbers Row
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildGlowValue(days.toString().padLeft(2, '0')),
                              _buildColon(),
                              _buildGlowValue(hours.toString().padLeft(2, '0')),
                              _buildColon(),
                              _buildGlowValue(minutes.toString().padLeft(2, '0')),
                              _buildColon(),
                              _buildGlowValue(seconds.toString().padLeft(2, '0')),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Spaced Labels Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildLabel("DAYS"),
                            _buildLabel("HOURS"),
                            _buildLabel("MINS"),
                            _buildLabel("SECS"),
                          ],
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),

          // 4. Skip Button (Bottom)
          Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton(
                onPressed: _onCountdownFinished,
                child: const Text(
                  "SKIP TO HOME >",
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowValue(String value) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w900,
        fontFamily: 'monospace',
        color: Colors.white,
        shadows: [
          Shadow(
            color: const Color(0xFFFF3B5C).withValues(alpha: 0.9),
            blurRadius: 16,
          ),
          Shadow(
            color: const Color(0xFFE52E4D).withValues(alpha: 0.8),
            blurRadius: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildColon() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        ":",
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: const Color(0xFFFF3B5C).withValues(alpha: 0.9),
              blurRadius: 16,
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
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
        shadows: [
          Shadow(
            color: const Color(0xFFE52E4D).withValues(alpha: 0.8),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
}