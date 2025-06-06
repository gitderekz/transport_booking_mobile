// lib/widgets/neu_button.dart
import 'package:flutter/material.dart';

class NeuButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double elevation;

  const NeuButton({
    super.key,
    required this.child,
    this.onPressed,
    this.gradient,
    this.borderRadius = 12,
    this.padding,
    this.elevation = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(borderRadius),
      elevation: elevation,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: gradient,
            color: gradient == null
                ? Theme.of(context).colorScheme.surface
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}