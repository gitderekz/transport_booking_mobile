// lib/pages/onboarding/onboarding_page.dart
import 'package:flutter/material.dart';
import 'package:transport_booking/config/routes.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      title: 'Welcome to TransportX',
      description: 'Book buses, trains, planes and ships with ease',
      image: 'assets/images/onboarding1.png',
      color: Colors.purple,
    ),
    OnboardingItem(
      title: 'Real-time Tracking',
      description: 'Track your transport in real-time with our advanced system',
      image: 'assets/images/onboarding2.png',
      color: Colors.blue,
    ),
    OnboardingItem(
      title: 'Easy Payments',
      description: 'Secure and hassle-free payment options',
      image: 'assets/images/onboarding3.png',
      color: Colors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingItems.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return _buildOnboardingPage(_onboardingItems[index]);
            },
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingItems.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentPage == index
                            ? _onboardingItems[index].color
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _onboardingItems.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.pushReplacementNamed(context, AppRoutes.login);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _onboardingItems[_currentPage].color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      _currentPage < _onboardingItems.length - 1
                          ? AppLocalizations.of(context)!.translate('next')!
                          : AppLocalizations.of(context)!.translate('get_started')!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                  child: Text(
                    AppLocalizations.of(context)!.translate('skip')!,
                    style: TextStyle(
                      color: _onboardingItems[_currentPage].color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingItem item) {
    return Container(
      color: item.color.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(item.image, height: 300),
          const SizedBox(height: 40),
          Text(
            item.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: item.color,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              item.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String image;
  final Color color;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
  });
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../blocs/language/language_bloc.dart';
// import '../../config/routes.dart';
// import '../../utils/localization/app_localizations.dart';
//
// class OnboardingPage extends StatelessWidget {
//   const OnboardingPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.directions_bus, size: 100),
//             const SizedBox(height: 32),
//             Text(
//               AppLocalizations.of(context)!.translate('welcome')!,
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 32.0),
//               child: Text(
//                 AppLocalizations.of(context)!.translate('onboarding_message')!,
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.bodyLarge,
//               ),
//             ),
//             const SizedBox(height: 32),
//             BlocBuilder<LanguageBloc, LanguageState>(
//               builder: (context, state) {
//                 Locale currentLocale = const Locale('en');
//                 if (state is LanguageChanged) {
//                   currentLocale = state.locale;
//                 }
//                 return DropdownButton<Locale>(
//                   value: currentLocale,
//                   items: const [
//                     DropdownMenuItem(
//                       value: Locale('en'),
//                       child: Text('English'),
//                     ),
//                     DropdownMenuItem(
//                       value: Locale('sw'),
//                       child: Text('Swahili'),
//                     ),
//                     DropdownMenuItem(
//                       value: Locale('es'),
//                       child: Text('Spanish'),
//                     ),
//                     DropdownMenuItem(
//                       value: Locale('fr'),
//                       child: Text('French'),
//                     ),
//                   ],
//                   onChanged: (locale) {
//                     if (locale != null) {
//                       context.read<LanguageBloc>().add(ChangeLanguage(locale: locale));
//                     }
//                   },
//                 );
//               },
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushReplacementNamed(context, AppRoutes.login);
//               },
//               child: Text(AppLocalizations.of(context)!.translate('get_started')!),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }