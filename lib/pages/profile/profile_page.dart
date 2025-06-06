// lib/pages/profile/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_booking/blocs/auth/auth_bloc.dart';
import 'package:transport_booking/blocs/theme/theme_bloc.dart';
import 'package:transport_booking/blocs/language/language_bloc.dart';
import 'package:transport_booking/config/routes.dart';
import 'package:transport_booking/models/user.dart';
import 'package:transport_booking/repositories/user_repository.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';

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
        SnackBar(content: Text('Failed to load profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('profile')!),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.login, (route) => false,
              );
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
          ? const Center(child: Text('User not found'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserCard(context),
            const SizedBox(height: 24),
            _buildPreferencesSection(context),
            const SizedBox(height: 24),
            _buildAccountActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_user!.firstName} ${_user!.lastName}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  _user!.email ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.editProfile);
                  },
                  child: Text(AppLocalizations.of(context)!.translate('edit_profile')!),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.translate('preferences')!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.translate('dark_mode')!),
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (value) {
                    context.read<ThemeBloc>().add(
                      ChangeTheme(themeMode: value ? ThemeMode.dark : ThemeMode.light),
                    );
                  },
                );
              },
            ),
            BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, state) {
                return DropdownButtonFormField<String>(
                  value: state is LanguageChanged ? state.locale.languageCode : 'en',
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.translate('language')!,
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountActions(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.translate('account')!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.history),
              title: Text(AppLocalizations.of(context)!.translate('booking_history')!),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.tickets);
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: Text(AppLocalizations.of(context)!.translate('help')!),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.help);
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: Text(AppLocalizations.of(context)!.translate('privacy')!),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.privacy);
              },
            ),
          ],
        ),
      ),
    );
  }
}
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