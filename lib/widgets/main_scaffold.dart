// lib/widgets/main_scaffold.dart
import 'package:flutter/material.dart';
import 'package:transport_booking/config/routes.dart';
import 'package:transport_booking/widgets/custom_bottom_nav.dart';

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
      bottomNavigationBar: showBottomNav ? const CustomBottomNav() : null,
      floatingActionButton: _buildBookNowFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBookNowFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
        child: Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
    );
  }

}