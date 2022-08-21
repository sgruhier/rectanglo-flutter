import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/themes.dart';
import '../data/controller/assets_controller.dart';

class PopButton extends StatefulWidget {
  final String? text;
  final VoidCallback onTap;
  final LinearGradient? gradientColor;
  final Color color;
  final Color? textColor;
  final Color? shadowColor;
  final Widget? child;
  final EdgeInsets? padding;
  final Border? border;
  final double? radius;
  final bool enableShadow;
  final MainAxisAlignment? axisAlignment;

  const PopButton({
    Key? key,
    required this.onTap,
    this.text,
    this.gradientColor,
    this.color = Themes.primary,
    this.textColor,
    this.shadowColor,
    this.child,
    this.padding,
    this.border,
    this.enableShadow = false,
    this.radius,
    this.axisAlignment = MainAxisAlignment.center,
  }) : super(key: key);

  @override
  _PopButtonState createState() => _PopButtonState();
}

class _PopButtonState extends State<PopButton>
    with SingleTickerProviderStateMixin {
  final AssetsController assetsController = Get.put(AssetsController());
  late AnimationController poppingAnimationController;

  @override
  void dispose() {
    poppingAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    poppingAnimationController = AnimationController(
      vsync: this,
      value: 1,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius ?? 6),
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(16),
        child: Center(
          child: widget.child ??
              Text(
                widget.text ?? '',
                style: Themes().white14?.apply(
                      color: widget.textColor ?? Themes.black,
                    ),
              ),
        ),
      ),
    );

    Widget container = AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      decoration: BoxDecoration(
        border: widget.border,
        color: widget.color,
        borderRadius: BorderRadius.circular(widget.radius ?? 6),
        gradient: widget.gradientColor,
        boxShadow: [
          if (widget.enableShadow)
            BoxShadow(
              color: (widget.shadowColor ?? widget.color.withOpacity(0.05)),
              offset: const Offset(0, 4),
              blurRadius: 12,
            )
        ],
      ),
      child: child,
    );

    return GestureDetector(
      onTapCancel: () {
        poppingAnimationController.animateTo(1);
      },
      onTapDown: (_) {
        assetsController.playPositiveTap();
        poppingAnimationController.animateTo(0.9);
      },
      onTapUp: (_) {
        poppingAnimationController.animateTo(1).whenComplete(() {
          widget.onTap();
        });
      },
      child: AnimatedBuilder(
        animation: poppingAnimationController,
        builder: (context, _) {
          return Transform.scale(
            scale: poppingAnimationController.value,
            child: container,
          );
        },
      ),
    );
  }
}
