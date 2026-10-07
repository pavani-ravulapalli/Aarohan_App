import 'home_page.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  late final DateTime _targetDate;

  @override
  void initState() {
    super.initState();
    // Default target time set to 9th October 2026
    _targetDate = widget.targetTime ?? DateTime(2026, 10, 9);
    _calculateTimeLeft();
    _startTimer();
    _initVideoPlayer();
  }

  void _initVideoPlayer() async {
    _videoController =
        VideoPlayerController.asset('assets/videos/countdown_bg.mp4');
    try {
      await _videoController.initialize();
      _videoController.setLooping(true);
      _videoController.setVolume(0.0);
      _videoController.play();
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Error initializing video player: $e");
    }
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
          // 1. Full-Screen Background Video Loop
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

          // 2. Top-Left Larger Metallic AR Logo
          Positioned(
            top: 10,
            left: 10,
            child: SafeArea(
              child: Image.asset(
                'assets/aarohan_logo.png',
                width: 92, // Increased logo size from 70 to 92
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Text(
                  "AR",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),

          // 3. Central Frame with Scaled-Up Timer
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.95, // Wider container
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
                        height: 280,
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

                  // Timer Units Layer (Scales dynamically inside expanded frame)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 10.0, // Expanded vertical padding for large frame fit
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
        const SizedBox(height: 6),
        _buildLabel(label),
      ],
    );
  }

  Widget _buildGlowValue(String value) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 36, // Increased number size from 36 to 52
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
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Text(
        ":",
        style: TextStyle(
          fontSize: 44, // Increased colon size from 32 to 44
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
        fontSize: 12, // Increased label font size from 10 to 12
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