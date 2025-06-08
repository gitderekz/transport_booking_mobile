// lib/pages/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_booking/blocs/auth/auth_bloc.dart';
import 'package:transport_booking/blocs/booking/booking_bloc.dart';
import 'package:transport_booking/config/routes.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';
import 'package:transport_booking/widgets/glass_card.dart';
import 'package:transport_booking/widgets/transport_type_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 320,
          floating: true,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            // title: Text(AppLocalizations.of(context)!.translate('home')!),
            background: _buildProfileHeader(context),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildTransportTypes(context),
                const SizedBox(height: 24),
                _buildPopularRoutes(context),
                const SizedBox(height: 24),
                _buildRecentBookings(context),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.secondary.withOpacity(0.7),
            Theme.of(context).colorScheme.error.withOpacity(0.3),
          ],
        ),
      ),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state is AuthAuthenticated ? state.user : null;
          return Padding(
            padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 16),
            child: GlassCard(
              borderRadius: 16,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            image: DecorationImage(
                              image: user?.profilePicture != null
                                  ? NetworkImage(user!.profilePicture!)
                                  : const AssetImage('assets/images/default_profile.png') as ImageProvider,
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
                                user != null
                                    ? '${user.firstName} ${user.lastName}'
                                    : AppLocalizations.of(context)!.translate('welcome')!,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (user != null)
                                Text(
                                  user.email ?? user.phone ?? '',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              // if (user != null)
                              //   Text(
                              //     '${user.age} ${user.gender} ${user.themePref} ${user.languagePref} ',
                              //     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              //       color: Colors.white.withOpacity(0.8),
                              //     ),
                              //   ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildStatItem(
                          context,
                          Icons.confirmation_number,
                          '5',
                          AppLocalizations.of(context)!.translate('trips')!,
                        ),
                        _buildStatItem(
                          context,
                          Icons.star,
                          '4.8',
                          AppLocalizations.of(context)!.translate('rating')!,
                        ),
                        _buildStatItem(
                          context,
                          Icons.workspace_premium,
                          'Gold',
                          AppLocalizations.of(context)!.translate('tier')!,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportTypes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   AppLocalizations.of(context)!.translate('book_ride')!,
        //   style: Theme.of(context).textTheme.titleLarge?.copyWith(
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            TransportTypeCard(
              icon: Icons.directions_bus,
              title: AppLocalizations.of(context)!.translate('bus')!,
              color: Colors.blue,
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.search,
                arguments: {'transportType': 'bus'},
              ),
            ),
            TransportTypeCard(
              icon: Icons.train,
              title: AppLocalizations.of(context)!.translate('train')!,
              color: Colors.green,
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.search,
                arguments: {'transportType': 'train'},
              ),
            ),
            TransportTypeCard(
              icon: Icons.airplanemode_active,
              title: AppLocalizations.of(context)!.translate('plane')!,
              color: Colors.purple,
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.search,
                arguments: {'transportType': 'plane'},
              ),
            ),
            TransportTypeCard(
              icon: Icons.directions_boat,
              title: AppLocalizations.of(context)!.translate('ship')!,
              color: Colors.orange,
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.search,
                arguments: {'transportType': 'ship'},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPopularRoutes(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.translate('popular_routes')!,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(AppLocalizations.of(context)!.translate('see_all')!),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildRouteCard(context, 'Nairobi', 'Kilimanjaro', Icons.directions_bus),
                _buildRouteCard(context, 'Dar es Salaam', 'Zanzibar', Icons.directions_boat),
                _buildRouteCard(context, 'Dodoma', 'Dar es Salaam', Icons.train),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard(BuildContext context, String from, String to, IconData icon) {
    return Container(
      width: 180,
      // margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(8.0),
      child: GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: /*Theme.of(context).colorScheme.primary.withOpacity(0.1)*/const Color(0xFFF44336).withOpacity(0.2),
                ),
                child: Icon(icon, color: /*Theme.of(context).colorScheme.primary*/ const Color(0xFFFF7043)),
              ),
              const SizedBox(height: 16),
              Text(
                '$from → $to',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Tsh 25000/=',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFFF44336)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentBookings(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state is BookingsLoaded && state.bookings.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate('recent_trips')!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.tickets);
                    },
                    child: Text(AppLocalizations.of(context)!.translate('see_all')!),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...state.bookings.take(2).map((booking) =>
                  GlassCard(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        ),
                        child: Icon(
                          _getTransportIcon(booking.route.transportType??'bus'),
                          color: /*Theme.of(context).colorScheme.primary*/_getStatusColor(booking.status),
                        ),
                      ),
                      title: Text('${booking.route.origin} → ${booking.route.destination}'),
                      subtitle: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                              decoration: BoxDecoration(
                                color: _getStatusColor(booking.status),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('${booking.date} • ${booking.status}')
                          ),
                        ],
                      ),
                      trailing: Text(
                        'Tsh ${booking.totalPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: _getStatusColor(booking.status),),
                      ),
                      onTap: () {
                        // Navigate to booking details
                      },
                    ),
                  ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  IconData _getTransportIcon(String type) {
    switch (type.toLowerCase()) {
      case 'bus': return Icons.directions_bus;
      case 'train': return Icons.train;
      case 'plane': return Icons.airplanemode_active;
      case 'ship': return Icons.directions_boat;
      default: return Icons.directions_transit;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}




// // lib/pages/home/home_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:transport_booking/blocs/auth/auth_bloc.dart';
// import 'package:transport_booking/blocs/booking/booking_bloc.dart';
// import 'package:transport_booking/config/routes.dart';
// import 'package:transport_booking/models/booking.dart';
// import 'package:transport_booking/utils/localization/app_localizations.dart';
// import 'package:transport_booking/widgets/main_navigation.dart';
// import 'package:transport_booking/widgets/glass_card.dart';
//
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       body: Stack(
//         children: [
//           // Background gradient
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Theme.of(context).colorScheme.primary.withOpacity(0.1),
//                   Theme.of(context).colorScheme.primary.withOpacity(0.05),
//                 ],
//               ),
//             ),
//           ),
//
//           // Floating circles decoration
//           Positioned(
//             top: -50,
//             right: -30,
//             child: Container(
//               width: 150,
//               height: 150,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: -80,
//             left: -50,
//             child: Container(
//               width: 200,
//               height: 200,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
//               ),
//             ),
//           ),
//
//           // Content
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 const SizedBox(height: 16),
//                 _buildWelcomeCard(context),
//                 const SizedBox(height: 24),
//                 _buildTransportTypes(context),
//                 const SizedBox(height: 24),
//                 _buildPopularRoutes(context),
//                 const SizedBox(height: 24),
//                 _buildRecentBookings(context),
//                 const SizedBox(height: 80), // Space for FAB
//               ],
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: _buildBookNowFAB(context),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: const CustomBottomNav(),
//     );
//   }
//
//   Widget _buildWelcomeCard(BuildContext context) {
//     return GlassCard(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             BlocBuilder<AuthBloc, AuthState>(
//               builder: (context, state) {
//                 if (state is AuthAuthenticated) {
//                   return Text(
//                     '${AppLocalizations.of(context)!.translate('welcome_back')!}, ${state.user.firstName}',
//                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   );
//                 }
//                 return Text(
//                   AppLocalizations.of(context)!.translate('welcome')!,
//                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 8),
//             Text(
//               AppLocalizations.of(context)!.translate('home_subtitle')!,
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTransportTypes(BuildContext context) {
//     return GlassCard(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               AppLocalizations.of(context)!.translate('transport_types')!,
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             GridView.count(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisCount: 2,
//               childAspectRatio: 1.5,
//               crossAxisSpacing: 16,
//               mainAxisSpacing: 16,
//               children: [
//                 _buildTransportTypeCard(
//                   context,
//                   Icons.directions_bus,
//                   AppLocalizations.of(context)!.translate('bus')!,
//                   Colors.blue,
//                 ),
//                 _buildTransportTypeCard(
//                   context,
//                   Icons.train,
//                   AppLocalizations.of(context)!.translate('train')!,
//                   Colors.green,
//                 ),
//                 _buildTransportTypeCard(
//                   context,
//                   Icons.airplanemode_active,
//                   AppLocalizations.of(context)!.translate('plane')!,
//                   Colors.purple,
//                 ),
//                 _buildTransportTypeCard(
//                   context,
//                   Icons.directions_boat,
//                   AppLocalizations.of(context)!.translate('ship')!,
//                   Colors.orange,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTransportTypeCard(BuildContext context, IconData icon, String title, Color color) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.pushNamed(
//           context,
//           AppRoutes.search,
//           arguments: {'transportType': title.toLowerCase()},
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [color.withOpacity(0.2), color.withOpacity(0.4)],
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 40, color: color),
//               const SizedBox(height: 8),
//               Text(
//                 title,
//                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPopularRoutes(BuildContext context) {
//     return GlassCard(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   AppLocalizations.of(context)!.translate('popular_routes')!,
//                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {},
//                   child: Text(AppLocalizations.of(context)!.translate('see_all')!),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             _buildRouteItem(context, 'Nairobi', 'Mombasa', 'From Tsh 25', Icons.directions_bus),
//             _buildRouteItem(context, 'Dar es Salaam', 'Zanzibar', 'From Tsh 50', Icons.directions_boat),
//             _buildRouteItem(context, 'Nairobi', 'Kisumu', 'From Tsh 30', Icons.train),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRouteItem(BuildContext context, String from, String to, String price, IconData icon) {
//     return ListTile(
//       leading: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
//         ),
//         child: Icon(icon, color: Theme.of(context).colorScheme.primary),
//       ),
//       title: Text('$from → $to'),
//       subtitle: Text(price),
//       trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary),
//       onTap: () {
//         Navigator.pushNamed(
//           context,
//           AppRoutes.search,
//           arguments: {'from': from, 'to': to},
//         );
//       },
//     );
//   }
//
//   Widget _buildRecentBookings(BuildContext context) {
//     return BlocBuilder<BookingBloc, BookingState>(
//       builder: (context, state) {
//         if (state is BookingsLoaded && state.bookings.isNotEmpty) {
//           return GlassCard(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         AppLocalizations.of(context)!.translate('recent_bookings')!,
//                         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, AppRoutes.tickets);
//                         },
//                         child: Text(AppLocalizations.of(context)!.translate('see_all')!),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   ...state.bookings.take(3).map((booking) => _buildBookingItem(context, booking)),
//                 ],
//               ),
//             ),
//           );
//         }
//         return const SizedBox.shrink();
//       },
//     );
//   }
//
//   Widget _buildBookingItem(BuildContext context, Booking booking) {
//     return ListTile(
//       leading: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
//         ),
//         child: Icon(
//           _getTransportIcon(booking.route.transportType??'bus'),
//           color: Theme.of(context).colorScheme.primary,
//         ),
//       ),
//       title: Text('${booking.route.origin} → ${booking.route.destination}'),
//       subtitle: Text('${booking.date} • ${booking.status}'),
//       trailing: Text('Tsh ${booking.totalPrice.toStringAsFixed(2)}'),
//       onTap: () {
//         // Navigate to booking details
//       },
//     );
//   }
//
//   IconData _getTransportIcon(String type) {
//     switch (type.toLowerCase()) {
//       case 'bus':
//         return Icons.directions_bus;
//       case 'train':
//         return Icons.train;
//       case 'plane':
//         return Icons.airplanemode_active;
//       case 'ship':
//         return Icons.directions_boat;
//       default:
//         return Icons.directions_transit;
//     }
//   }
//
//   Widget _buildBookNowFAB(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
//       backgroundColor: Theme.of(context).colorScheme.primary,
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Container(
//         width: 56,
//         height: 56,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: const LinearGradient(
//             colors: [Color(0xFF6A3CBC), Color(0xFF461B93)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF6A3CBC).withOpacity(0.3),
//               blurRadius: 10,
//               spreadRadius: 2,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Icon(
//           Icons.search,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
// // *************************



// // lib/pages/home/home_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:transport_booking/blocs/auth/auth_bloc.dart';
// import 'package:transport_booking/blocs/booking/booking_bloc.dart';
// import 'package:transport_booking/config/routes.dart';
// import 'package:transport_booking/utils/localization/app_localizations.dart';
//
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 200,
//             pinned: true,
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.settings),
//                 onPressed: () => Navigator.pushNamed(context, AppRoutes.setting),
//               ),
//             ],
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text(AppLocalizations.of(context)!.translate('welcome')!),
//               background: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Theme.of(context).colorScheme.primary,
//                       Theme.of(context).colorScheme.secondary,
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: BlocBuilder<AuthBloc, AuthState>(
//                 builder: (context, state) {
//                   if (state is AuthAuthenticated) {
//                     return Text(
//                       '${AppLocalizations.of(context)!.translate('logged_in_as')!} ${state.user.email ?? state.user.phone}',
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     );
//                   }
//                   return ElevatedButton(
//                     onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
//                     child: Text(AppLocalizations.of(context)!.translate('login')!),
//                   );
//                 },
//               ),
//             ),
//           ),
//           SliverPadding(
//             padding: const EdgeInsets.all(16),
//             sliver: SliverGrid(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 childAspectRatio: 1,
//               ),
//               delegate: SliverChildListDelegate([
//                 _buildTransportCard(
//                   context,
//                   Icons.directions_bus,
//                   AppLocalizations.of(context)!.translate('bus')!,
//                   Colors.purple,
//                       () => _navigateToTransportType(context, 'bus'),
//                 ),
//                 _buildTransportCard(
//                   context,
//                   Icons.train,
//                   AppLocalizations.of(context)!.translate('train')!,
//                   Colors.blue,
//                       () => _navigateToTransportType(context, 'train'),
//                 ),
//                 _buildTransportCard(
//                   context,
//                   Icons.airplanemode_active,
//                   AppLocalizations.of(context)!.translate('plane')!,
//                   Colors.orange,
//                       () => _navigateToTransportType(context, 'plane'),
//                 ),
//                 _buildTransportCard(
//                   context,
//                   Icons.directions_boat,
//                   AppLocalizations.of(context)!.translate('ship')!,
//                   Colors.teal,
//                       () => _navigateToTransportType(context, 'ship'),
//                 ),
//               ]),
//             ),
//           ),
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             sliver: SliverToBoxAdapter(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     AppLocalizations.of(context)!.translate('popular_routes')!,
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   const SizedBox(height: 16),
//                   _buildPopularRoutes(context),
//                 ],
//               ),
//             ),
//           ),
//           const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTransportCard(
//       BuildContext context,
//       IconData icon,
//       String title,
//       Color color,
//       VoidCallback onTap,
//       ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               color.withOpacity(0.7),
//               color.withOpacity(0.9),
//             ],
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: color.withOpacity(0.3),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 48, color: Colors.white),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPopularRoutes(BuildContext context) {
//     final popularRoutes = [
//       {'from': 'Nairobi', 'to': 'Mombasa', 'price': 'KSH 1,500'},
//       {'from': 'Dar es Salaam', 'to': 'Arusha', 'price': 'TZS 25,000'},
//       {'from': 'Kampala', 'to': 'Jinja', 'price': 'UGX 15,000'},
//     ];
//
//     return Column(
//       children: popularRoutes.map((route) {
//         return Card(
//           margin: const EdgeInsets.only(bottom: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 2,
//           child: ListTile(
//             contentPadding: const EdgeInsets.all(16),
//             leading: Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(
//                   colors: [
//                     Theme.of(context).colorScheme.primary,
//                     Theme.of(context).colorScheme.secondary,
//                   ],
//                 ),
//               ),
//               child: const Icon(Icons.arrow_forward, color: Colors.white),
//             ),
//             title: Text('${route['from']} → ${route['to']}'),
//             subtitle: Text(route['price']!),
//             trailing: IconButton(
//               icon: const Icon(Icons.arrow_forward_ios, size: 16),
//               onPressed: () => _navigateToRouteDetails(context, route),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
//
//   void _navigateToTransportType(BuildContext context, String type) {
//     // context.read<BookingBloc>().add(TransportTypeSelected(type));
//     Navigator.pushNamed(context, AppRoutes.search);
//   }
//
//   void _navigateToRouteDetails(BuildContext context, Map<String, String> route) {
//     // TODO: Implement route details navigation
//   }
// }
// // ************************



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../blocs/auth/auth_bloc.dart';
// import '../../blocs/booking/booking_bloc.dart';
// import '../../blocs/language/language_bloc.dart';
// import '../../blocs/theme/theme_bloc.dart';
// import '../../config/routes.dart';
// import '../../widgets/main_navigation.dart';
// import '../../utils/localization/app_localizations.dart';
//
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.translate('home')!),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: () {
//               Navigator.pushNamed(context, AppRoutes.setting);
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               AppLocalizations.of(context)!.translate('welcome')!,
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, AppRoutes.search);
//               },
//               child: Text(
//                   AppLocalizations.of(context)!.translate('book_now')!),
//             ),
//             const SizedBox(height: 16),
//             BlocBuilder<AuthBloc, AuthState>(
//               builder: (context, state) {
//                 if (state is AuthAuthenticated) {
//                   return Text(
//                     '${AppLocalizations.of(context)!.translate('logged_in_as')!} ${state.user.email ?? state.user.phone}',
//                   );
//                 }
//                 return ElevatedButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, AppRoutes.login);
//                   },
//                   child: Text(
//                       AppLocalizations.of(context)!.translate('login')!),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: const CustomBottomNav(),
//     );
//   }
// }