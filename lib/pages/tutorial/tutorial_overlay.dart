// lib/pages/tutorial_overlay.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialService {
  static const String _tutorialKey = 'transport_tutorial_completed';

  static Future<bool> shouldShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_tutorialKey) ?? false);
  }

  static Future<void> completeTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tutorialKey, true);
  }

  static Future<void> resetTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tutorialKey);
  }
}

class TutorialOverlay {
  static Future<void> showTutorialIfNeeded(BuildContext context) async {
    if (await TutorialService.shouldShowTutorial()) {
      final steps = [
        TutorialStep(
          title: 'Welcome to Transport Booking',
          description: 'Book buses, trains, planes and ships all in one place',
          icon: Icons.directions_bus,
        ),
        TutorialStep(
          title: 'Search & Book',
          description: 'Find available routes and book your tickets easily',
          icon: Icons.search,
        ),
        TutorialStep(
          title: 'Manage Bookings',
          description: 'View and manage all your bookings in one place',
          icon: Icons.confirmation_num,
        ),
        TutorialStep(
          title: 'Your Profile',
          description: 'Update your personal information and preferences',
          icon: Icons.person,
        ),
      ];

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => TutorialCarousel(
          steps: steps,
          onComplete: () {
            TutorialService.completeTutorial();
            Navigator.of(context).pop();
          },
        ),
      );
    }
  }
}

class TutorialCarousel extends StatefulWidget {
  final List<TutorialStep> steps;
  final VoidCallback onComplete;

  const TutorialCarousel({
    required this.steps,
    required this.onComplete,
    super.key,
  });

  @override
  State<TutorialCarousel> createState() => _TutorialCarouselState();
}

class _TutorialCarouselState extends State<TutorialCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.steps.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final step = widget.steps[index];
                  return TutorialStepWidget(step: step);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: const Text('Back'),
                    )
                  else
                    const SizedBox(width: 80),
                  _buildPageIndicator(),
                  _currentPage < widget.steps.length - 1
                      ? TextButton(
                    onPressed: () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    child: const Text('Next'),
                  )
                      : TextButton(
                    onPressed: widget.onComplete,
                    child: const Text('Get Started'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.steps.length, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
        );
      }),
    );
  }
}

class TutorialStepWidget extends StatelessWidget {
  final TutorialStep step;

  const TutorialStepWidget({required this.step, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
            child: Icon(
              step.icon,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            step.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            step.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TutorialStep {
  final String title;
  final String description;
  final IconData icon;

  TutorialStep({
    required this.title,
    required this.description,
    required this.icon,
  });
}