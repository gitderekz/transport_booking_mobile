import 'package:flutter/material.dart';

import 'app_localizations.dart';

extension LocalizationExtension on String {
  String translate(BuildContext context) {
    return AppLocalizations.of(context)?.translate(this) ?? this;
  }
}