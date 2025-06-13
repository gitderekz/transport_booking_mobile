// lib/pages/profile/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_booking/blocs/auth/auth_bloc.dart';
import 'package:transport_booking/blocs/language/language_bloc.dart';
import 'package:transport_booking/blocs/theme/theme_bloc.dart';
import 'package:transport_booking/config/routes.dart';
import 'package:transport_booking/models/user.dart';
import 'package:transport_booking/repositories/user_repository.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';
import 'package:transport_booking/widgets/glass_card.dart';
import 'package:transport_booking/widgets/main_navigation.dart';
import 'package:transport_booking/widgets/neu_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userRepo = context.read<UserRepository>();
    try {
      final user = await userRepo.fetchProfile();
      setState(() {
        _user = user;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load profile'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
                Theme.of(context).colorScheme.primary.withOpacity(0.05),
              ],
            ),
          ),
        ),

        // Content
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              GlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildProfileHeader(context),
                      const SizedBox(height: 24),
                      _buildProfileActions(context),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate('preferences')!,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildThemeSwitch(context),
                      const SizedBox(height: 16),
                      _buildLanguageDropdown(context),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate('account')!,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildAccountItem(
                        context,
                        Icons.history,
                        AppLocalizations.of(context)!.translate('booking_history')!,
                            () {
                              final mainNav = context.findAncestorStateOfType<MainNavigationState>();
                              mainNav?.onItemTapped(3);
                              //     Navigator.pushNamed(context, AppRoutes.tickets)
                            },
                      ),
                      _buildAccountItem(
                        context,
                        Icons.help_outline,
                        AppLocalizations.of(context)!.translate('help')!,
                            () => Navigator.pushNamed(context, AppRoutes.help),
                      ),
                      _buildAccountItem(
                        context,
                        Icons.privacy_tip_outlined,
                        AppLocalizations.of(context)!.translate('privacy')!,
                            () => Navigator.pushNamed(context, AppRoutes.privacy),
                      ),
                      _buildAccountItem(
                        context,
                        Icons.logout,
                        AppLocalizations.of(context)!.translate('logout')!,
                            () {
                          context.read<AuthBloc>().add(AuthLogoutRequested());
                          Navigator.pushNamedAndRemoveUntil(
                            context, AppRoutes.login, (route) => false,
                          );
                        },
                        isLogout: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
            image: DecorationImage(
              image: _user?.profilePicture != null
                  ? NetworkImage(_user!.profilePicture!)
                  : AssetImage('assets/images/default_profile.png') as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _user != null
                    ? '${_user!.firstName} ${_user!.lastName}'
                    : 'Guest User',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _user?.email ?? 'Not logged in',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: NeuButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.editProfile),
            child: Text(
              AppLocalizations.of(context)!.translate('edit_profile')!,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSwitch(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('dark_mode')!,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                context.read<ThemeBloc>().add(
                  ChangeTheme(themeMode: value ? ThemeMode.dark : ThemeMode.light),
                );
              },
              activeColor: Theme.of(context).colorScheme.primary,
            );
          },
        ),
      ],
    );
  }

  Widget _buildLanguageDropdown(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return DropdownButtonFormField<String>(
          value: state is LanguageChanged ? state.locale.languageCode : 'en',
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.translate('language')!,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
          ),
          items: const [
            DropdownMenuItem(value: 'en', child: Text('English')),
            DropdownMenuItem(value: 'sw', child: Text('Swahili')),
            DropdownMenuItem(value: 'es', child: Text('Spanish')),
            DropdownMenuItem(value: 'fr', child: Text('French')),
          ],
          onChanged: (String? value) {
            if (value != null) {
              context.read<LanguageBloc>().add(
                ChangeLanguage(locale: Locale(value)),
              );
            }
          },
          style: Theme.of(context).textTheme.bodyLarge,
          dropdownColor: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        );
      },
    );
  }

  Widget _buildAccountItem(
      BuildContext context,
      IconData icon,
      String text,
      VoidCallback onTap, {
        bool isLogout = false,
      }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: isLogout
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: isLogout
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isLogout
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
      ),
      onTap: onTap,
    );
  }
}



// // lib/pages/profile/profile_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:transport_booking/blocs/auth/auth_bloc.dart';
// import 'package:transport_booking/blocs/theme/theme_bloc.dart';
// import 'package:transport_booking/blocs/language/language_bloc.dart';
// import 'package:transport_booking/config/routes.dart';
// import 'package:transport_booking/models/user.dart';
// import 'package:transport_booking/repositories/user_repository.dart';
// import 'package:transport_booking/utils/localization/app_localizations.dart';
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   User? _user;
//   bool _loading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUser();
//   }
//
//   Future<void> _loadUser() async {
//     final userRepo = context.read<UserRepository>();
//     try {
//       final user = await userRepo.fetchProfile();
//       setState(() {
//         _user = user;
//         _loading = false;
//       });
//     } catch (e) {
//       setState(() => _loading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load profile')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.translate('profile')!),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               context.read<AuthBloc>().add(AuthLogoutRequested());
//               Navigator.pushNamedAndRemoveUntil(
//                 context, AppRoutes.login, (route) => false,
//               );
//             },
//           ),
//         ],
//       ),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : _user == null
//           ? const Center(child: Text('User not found'))
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildUserCard(context),
//             const SizedBox(height: 24),
//             _buildPreferencesSection(context),
//             const SizedBox(height: 24),
//             _buildAccountActions(context),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildUserCard(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             const CircleAvatar(
//               radius: 40,
//               backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
//             ),
//             const SizedBox(width: 16),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '${_user!.firstName} ${_user!.lastName}',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//                 Text(
//                   _user!.email ?? '',
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//                 const SizedBox(height: 8),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, AppRoutes.editProfile);
//                   },
//                   child: Text(AppLocalizations.of(context)!.translate('edit_profile')!),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPreferencesSection(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               AppLocalizations.of(context)!.translate('preferences')!,
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 16),
//             BlocBuilder<ThemeBloc, ThemeState>(
//               builder: (context, state) {
//                 return SwitchListTile(
//                   title: Text(AppLocalizations.of(context)!.translate('dark_mode')!),
//                   value: Theme.of(context).brightness == Brightness.dark,
//                   onChanged: (value) {
//                     context.read<ThemeBloc>().add(
//                       ChangeTheme(themeMode: value ? ThemeMode.dark : ThemeMode.light),
//                     );
//                   },
//                 );
//               },
//             ),
//             BlocBuilder<LanguageBloc, LanguageState>(
//               builder: (context, state) {
//                 return DropdownButtonFormField<String>(
//                   value: state is LanguageChanged ? state.locale.languageCode : 'en',
//                   decoration: InputDecoration(
//                     labelText: AppLocalizations.of(context)!.translate('language')!,
//                   ),
//                   items: const [
//                     DropdownMenuItem(value: 'en', child: Text('English')),
//                     DropdownMenuItem(value: 'sw', child: Text('Swahili')),
//                     DropdownMenuItem(value: 'es', child: Text('Spanish')),
//                     DropdownMenuItem(value: 'fr', child: Text('French')),
//                   ],
//                   onChanged: (String? value) {
//                     if (value != null) {
//                       context.read<LanguageBloc>().add(
//                         ChangeLanguage(locale: Locale(value)),
//                       );
//                     }
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAccountActions(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               AppLocalizations.of(context)!.translate('account')!,
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 16),
//             ListTile(
//               leading: const Icon(Icons.history),
//               title: Text(AppLocalizations.of(context)!.translate('booking_history')!),
//               onTap: () {
//                 Navigator.pushNamed(context, AppRoutes.tickets);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.help),
//               title: Text(AppLocalizations.of(context)!.translate('help')!),
//               onTap: () {
//                 Navigator.pushNamed(context, AppRoutes.help);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.privacy_tip),
//               title: Text(AppLocalizations.of(context)!.translate('privacy')!),
//               onTap: () {
//                 Navigator.pushNamed(context, AppRoutes.privacy);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // *************************


// ********************************



// // lib/pages/profile/profile_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:transport_booking/blocs/auth/auth_bloc.dart';
// import 'package:transport_booking/blocs/theme/theme_bloc.dart';
// import 'package:transport_booking/blocs/language/language_bloc.dart';
// import 'package:transport_booking/config/routes.dart';
// import 'package:transport_booking/utils/localization/app_localizations.dart';
//
// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.translate('profile')!),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               context.read<AuthBloc>().add(AuthLogoutRequested());
//               Navigator.pushNamedAndRemoveUntil(
//                   context, AppRoutes.login, (route) => false);
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildUserCard(context),
//             const SizedBox(height: 24),
//             _buildPreferencesSection(context),
//             const SizedBox(height: 24),
//             _buildAccountActions(context),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildUserCard(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             const CircleAvatar(
//               radius: 40,
//               backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
//             ),
//             const SizedBox(width: 16),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'John Doe', // Replace with actual user name
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//                 Text(
//                   'user@example.com', // Replace with actual user email
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//                 const SizedBox(height: 8),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, AppRoutes.editProfile);
//                   },
//                   child: Text(AppLocalizations.of(context)!.translate('edit_profile')!),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPreferencesSection(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               AppLocalizations.of(context)!.translate('preferences')!,
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 16),
//             BlocBuilder<ThemeBloc, ThemeState>(
//               builder: (context, state) {
//                 return
//                   // In lib/pages/profile/profile_page.dart, update the theme toggle:
//                   SwitchListTile(
//                     title: Text(AppLocalizations.of(context)!.translate('dark_mode')!),
//                     value: Theme.of(context).brightness == Brightness.dark,
//                     onChanged: (value) {
//                       context.read<ThemeBloc>().add(
//                         ChangeTheme(themeMode: value ? ThemeMode.dark : ThemeMode.light),
//                       );
//                     },
//                   );
//                 //   SwitchListTile(
//                 //   title: Text(AppLocalizations.of(context)!.translate('dark_mode')!),
//                 //   value: state.themeMode == ThemeMode.dark,
//                 //   onChanged: (value) {
//                 //     context.read<ThemeBloc>().add(
//                 //       value ? ThemeChanged(ThemeMode.dark) : ThemeChanged(ThemeMode.light),
//                 //     );
//                 //   },
//                 // );
//               },
//             ),
//             BlocBuilder<LanguageBloc, LanguageState>(
//               builder: (context, state) {
//                 return DropdownButtonFormField<String>(
//                   value: state is LanguageChanged ? state.locale.languageCode : 'en',
//                   decoration: InputDecoration(
//                     labelText: AppLocalizations.of(context)!.translate('language')!,
//                   ),
//                   items: const [
//                     DropdownMenuItem(value: 'en', child: Text('English')),
//                     DropdownMenuItem(value: 'sw', child: Text('Swahili')),
//                     DropdownMenuItem(value: 'es', child: Text('Spanish')),
//                     DropdownMenuItem(value: 'fr', child: Text('French')),
//                   ],
//                   onChanged: (String? value) {
//                     if (value != null) {
//                       context.read<LanguageBloc>().add(
//                         ChangeLanguage(locale:Locale(value)),
//                       );
//                     }
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAccountActions(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               AppLocalizations.of(context)!.translate('account')!,
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 16),
//             ListTile(
//               leading: const Icon(Icons.history),
//               title: Text(AppLocalizations.of(context)!.translate('booking_history')!),
//               onTap: () {
//                 Navigator.pushNamed(context, AppRoutes.tickets);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.help),
//               title: Text(AppLocalizations.of(context)!.translate('help')!),
//               onTap: () {
//                 Navigator.pushNamed(context, AppRoutes.help);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.privacy_tip),
//               title: Text(AppLocalizations.of(context)!.translate('privacy')!),
//               onTap: () {
//                 Navigator.pushNamed(context, AppRoutes.privacy);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }