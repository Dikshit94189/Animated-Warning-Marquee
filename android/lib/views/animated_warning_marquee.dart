import 'package:flutter/material.dart';

class AnimatedWarningMarquee extends StatefulWidget {
  final String? text;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Duration scrollDuration;
  final Duration fadeDuration;

  const AnimatedWarningMarquee({
    super.key,
      this.text,
    this.textStyle,
    this.backgroundColor = Colors.amber,
    this.scrollDuration = const Duration(seconds: 8),
    this.fadeDuration = const Duration(seconds: 1),
  });

  @override
  State<AnimatedWarningMarquee> createState() => _AnimatedWarningMarqueeState();
}

class _AnimatedWarningMarqueeState extends State<AnimatedWarningMarquee>
    with TickerProviderStateMixin {
  late AnimationController _scrollController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  double _textWidth = 0;
  double _screenWidth = 0;

  @override
  void initState() {
    super.initState();

    // Fade-in animation controller
    _fadeController = AnimationController(
      vsync: this,
      duration: widget.fadeDuration,
    );

    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    // Scroll animation controller
    _scrollController = AnimationController(
      vsync: this,
      duration: widget.scrollDuration,
    );

    // Start the fade and scroll animations when built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
      _startScrolling();
    });
  }

  void _startScrolling() {
    _scrollController.repeat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scrollController,
      builder: (context, child) {
        return AnimatedOpacity(
          opacity: _fadeAnimation.value,
          duration: widget.fadeDuration,
          child: ClipRect(
            child: Container(
              color: widget.backgroundColor,
              height: 35,
              alignment: Alignment.centerLeft,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  _screenWidth = constraints.maxWidth;

                  // If text width is measured, animate based on it
                  final animationValue =
                      _scrollController.value * (_textWidth + _screenWidth);

                  return Stack(
                    children: [
                      Transform.translate(
                        offset: Offset(_screenWidth - animationValue, 0),
                        child: _buildMeasuredText(),
                      ),
                      // Duplicate text for seamless loop
                      Transform.translate(
                        offset: Offset(_screenWidth - animationValue + _textWidth + 50, 0),
                        child: _buildMeasuredText(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMeasuredText() {
    return Builder(
      builder: (context) {
        final textPainter = TextPainter(
          text: TextSpan(text: widget.text, style: widget.textStyle),
          textDirection: TextDirection.ltr,
        )..layout();

        _textWidth = textPainter.width;

        return Text(
          widget.text ?? "  Warning",
          style: widget.textStyle ??
              const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
        );
      },
    );
  }
}
