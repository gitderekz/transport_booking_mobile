// lib/widgets/main_scaffold.dart
import 'package:flutter/material.dart';
import 'package:transport_booking/config/routes.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';
import 'package:transport_booking/widgets/main_navigation.dart';

class MainScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final bool extendBody;
  final bool showBottomNav;

  const MainScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.extendBody = true,
    this.showBottomNav = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: extendBody,
      body: body,
      // bottomNavigationBar: showBottomNav ? const MainNavigation() : null,
      floatingActionButton: _buildBookNowFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBookNowFAB(BuildContext context) {
    return FloatingActionButton(
      // onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
      onPressed: () => Navigator.pop(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      heroTag: 'search_fab', // disables Hero animation
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF6A3CBC), Color(0xFF461B93)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6A3CBC).withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              // Icons.route,
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            // Text(AppLocalizations.of(context)!.translate('trips')!,)//'Book'
          ],
        ),
      ),
    );
  }

}