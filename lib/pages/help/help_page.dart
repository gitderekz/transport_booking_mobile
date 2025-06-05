// lib/pages/help/help_page.dart
import 'package:flutter/material.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('help')!),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpSection(
              context,
              AppLocalizations.of(context)!.translate('booking_help')!,
              AppLocalizations.of(context)!.translate('booking_help_content')!,
            ),
            _buildHelpSection(
              context,
              AppLocalizations.of(context)!.translate('payment_help')!,
              AppLocalizations.of(context)!.translate('payment_help_content')!,
            ),
            _buildHelpSection(
              context,
              AppLocalizations.of(context)!.translate('cancellation_help')!,
              AppLocalizations.of(context)!.translate('cancellation_help_content')!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection(BuildContext context, String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }
}