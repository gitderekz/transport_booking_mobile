// lib/widgets/neu_dropdown.dart
import 'package:flutter/material.dart';

class NeuDropdown<T> extends StatelessWidget {
  final T? value;
  final String? hint;
  final List<DropdownMenuItem<T>>? items;
  final ValueChanged<T?>? onChanged;
  final IconData? icon;
  final double borderRadius;

  const NeuDropdown({
    super.key,
    this.value,
    this.hint,
    this.items,
    this.onChanged,
    this.icon,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonFormField<T>(
          value: value,
          hint: hint != null
              ? Text(
            hint!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          )
              : null,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: icon != null
                ? Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            )
                : null,
          ),
          style: Theme.of(context).textTheme.bodyLarge,
          dropdownColor: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(borderRadius),
          icon: Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}