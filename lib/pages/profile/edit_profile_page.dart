// lib/pages/profile/edit_profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transport_booking/blocs/auth/auth_bloc.dart';
import 'package:transport_booking/models/user.dart';
import 'package:transport_booking/widgets/custom_bottom_nav.dart';
import 'package:transport_booking/widgets/glass_card.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _profilePicture;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _firstNameController = TextEditingController(text: authState.user.firstName);
      _lastNameController = TextEditingController(text: authState.user.lastName);
      _emailController = TextEditingController(text: authState.user.email);
      _phoneController = TextEditingController(text: authState.user.phone);
      _profilePicture = authState.user.profilePicture;
    } else {
      _firstNameController = TextEditingController();
      _lastNameController = TextEditingController();
      _emailController = TextEditingController();
      _phoneController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
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
                        _buildProfilePicture(context),
                        const SizedBox(height: 24),
                        _buildProfileForm(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }

  Widget _buildProfilePicture(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
            image: _profilePicture != null
                ? DecorationImage(
              image: NetworkImage(_profilePicture!),
              fit: BoxFit.cover,
            )
                : const DecorationImage(
              image: AssetImage('assets/images/default_profile.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
          ),
          child: IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
            onPressed: _pickImage,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(
              labelText: 'First Name',
              prefixIcon: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(
              labelText: 'Last Name',
              prefixIcon: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email, color: Theme.of(context).colorScheme.primary),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            readOnly: true,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Phone',
              prefixIcon: Icon(Icons.phone, color: Theme.of(context).colorScheme.primary),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
              child: const Text('SAVE CHANGES', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Upload image and update profile picture
      setState(() {
        _profilePicture = pickedFile.path;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Update profile logic
      final updatedUser = User(
        id: '',
        uuid: '',
        email: _emailController.text,
        phone: _phoneController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        isVerified: true,
        languagePref: 'en',
        themePref: 'system',
        profilePicture: _profilePicture,
      );

      // context.read<AuthBloc>().add(UpdateProfile(updatedUser));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}



// // lib/pages/profile/edit_profile_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:transport_booking/blocs/auth/auth_bloc.dart';
// import 'package:transport_booking/blocs/language/language_bloc.dart';
// import 'package:transport_booking/blocs/theme/theme_bloc.dart';
// import 'package:transport_booking/models/user.dart';
// import 'package:transport_booking/utils/localization/app_localizations.dart';
//
// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({super.key});
//
//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }
//
// class _EditProfilePageState extends State<EditProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _firstNameController;
//   late TextEditingController _lastNameController;
//   late TextEditingController _emailController;
//   late TextEditingController _phoneController;
//
//   @override
//   void initState() {
//     super.initState();
//     final user = context.read<AuthBloc>().state.user;
//     _firstNameController = TextEditingController(text: user?.firstName);
//     _lastNameController = TextEditingController(text: user?.lastName);
//     _emailController = TextEditingController(text: user?.email);
//     _phoneController = TextEditingController(text: user?.phone);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.translate('edit_profile')!),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: _saveProfile,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               _buildGlassCard(
//                 context,
//                 Column(
//                   children: [
//                     _buildProfilePicture(),
//                     const SizedBox(height: 24),
//                     _buildTextFormField(
//                       context,
//                       _firstNameController,
//                       AppLocalizations.of(context)!.translate('first_name')!,
//                       Icons.person,
//                     ),
//                     const SizedBox(height: 16),
//                     _buildTextFormField(
//                       context,
//                       _lastNameController,
//                       AppLocalizations.of(context)!.translate('last_name')!,
//                       Icons.person,
//                     ),
//                     const SizedBox(height: 16),
//                     _buildTextFormField(
//                       context,
//                       _emailController,
//                       AppLocalizations.of(context)!.translate('email')!,
//                       Icons.email,
//                       enabled: false,
//                     ),
//                     const SizedBox(height: 16),
//                     _buildTextFormField(
//                       context,
//                       _phoneController,
//                       AppLocalizations.of(context)!.translate('phone')!,
//                       Icons.phone,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),
//               _buildGlassCard(
//                 context,
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       AppLocalizations.of(context)!.translate('preferences')!,
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                     const SizedBox(height: 16),
//                     _buildThemeSwitch(context),
//                     const SizedBox(height: 16),
//                     _buildLanguageDropdown(context),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _saveProfile,
//                   style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     backgroundColor: Theme.of(context).colorScheme.primary,
//                   ),
//                   child: Text(
//                     AppLocalizations.of(context)!.translate('save_changes')!,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGlassCard(BuildContext context, Widget child) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             spreadRadius: 2,
//           ),
//         ],
//         border: Border.all(
//           color: Colors.white.withOpacity(0.2),
//           width: 1,
//         ),
//       ),
//       child: child,
//     );
//   }
//
//   Widget _buildProfilePicture() {
//     return Center(
//       child: Stack(
//         children: [
//           Container(
//             width: 100,
//             height: 100,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.grey[300],
//               image: const DecorationImage(
//                 image: AssetImage('assets/images/profile_placeholder.png'),
//                 fit: BoxFit.cover,
//               ),
//               border: Border.all(
//                 color: Colors.white,
//                 width: 2,
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             right: 0,
//             child: Container(
//               padding: const EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//               child: const Icon(Icons.edit, size: 16, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTextFormField(
//       BuildContext context,
//       TextEditingController controller,
//       String label,
//       IconData icon, {
//         bool enabled = true,
//       }) {
//     return TextFormField(
//       controller: controller,
//       enabled: enabled,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         filled: true,
//         fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return AppLocalizations.of(context)!.translate('field_required')!;
//         }
//         return null;
//       },
//     );
//   }
//
//   Widget _buildThemeSwitch(BuildContext context) {
//     return BlocBuilder<ThemeBloc, ThemeState>(
//       builder: (context, state) {
//         return SwitchListTile(
//           title: Text(AppLocalizations.of(context)!.translate('dark_mode')!),
//           value: state.themeMode == ThemeMode.dark,
//           onChanged: (value) {
//             context.read<ThemeBloc>().add(
//               ChangeTheme(themeMode: value ? ThemeMode.dark : ThemeMode.light),
//             );
//           },
//           secondary: Icon(
//             state.themeMode == ThemeMode.dark ? Icons.nightlight : Icons.wb_sunny,
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildLanguageDropdown(BuildContext context) {
//     return BlocBuilder<LanguageBloc, LanguageState>(
//       builder: (context, state) {
//         return DropdownButtonFormField<String>(
//           value: state.locale.languageCode,
//           decoration: InputDecoration(
//             labelText: AppLocalizations.of(context)!.translate('language')!,
//             prefixIcon: const Icon(Icons.language),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             filled: true,
//             fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
//           ),
//           items: const [
//             DropdownMenuItem(value: 'en', child: Text('English')),
//             DropdownMenuItem(value: 'sw', child: Text('Swahili')),
//             DropdownMenuItem(value: 'es', child: Text('Spanish')),
//             DropdownMenuItem(value: 'fr', child: Text('French')),
//           ],
//           onChanged: (value) {
//             if (value != null) {
//               context.read<LanguageBloc>().add(ChangeLanguage(Locale(value)));
//             }
//           },
//         );
//       },
//     );
//   }
//
//   void _saveProfile() {
//     if (_formKey.currentState!.validate()) {
//       final updatedUser = User(
//         id: context.read<AuthBloc>().state.user!.id,
//         uuid: context.read<AuthBloc>().state.user!.uuid,
//         firstName: _firstNameController.text,
//         lastName: _lastNameController.text,
//         email: _emailController.text,
//         phone: _phoneController.text,
//         isVerified: context.read<AuthBloc>().state.user!.isVerified,
//         languagePref: context.read<LanguageBloc>().state.locale.languageCode,
//         themePref: context.read<ThemeBloc>().state.themeMode == ThemeMode.dark ? 'dark' : 'light',
//         profilePicture: context.read<AuthBloc>().state.user!.profilePicture,
//       );
//
//       context.read<AuthBloc>().add(UpdateProfile(updatedUser));
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(AppLocalizations.of(context)!.translate('profile_updated')!)),
//       );
//     }
//   }
// }