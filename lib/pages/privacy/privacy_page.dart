// lib/pages/privacy/privacy_page.dart
import 'package:flutter/material.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('privacy_policy')!),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.translate('privacy_policy_title')!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.translate('privacy_policy_content')!,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}