// lib/widgets/gradient_appbar.dart
import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final double elevation;

  const GradientAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      actions: actions,
      elevation: elevation,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.tertiary,
            ],
            stops: const [0.1, 0.5, 0.9],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}