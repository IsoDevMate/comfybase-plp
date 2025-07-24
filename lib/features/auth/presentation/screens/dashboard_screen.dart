// // import 'package:flutter/material.dart';
// // import 'package:kenyanvalley/features/auth/presentation/screens/settings_screen.dart';
// // import 'package:provider/provider.dart';
// // import '../../../../core/theme/app_dimensions.dart';
// // import '../providers/auth_provider.dart';
// // import '../../../../core/theme/app_colors.dart';
// // import '../../../../core/theme/app_text_styles.dart';
// // import '../../../../core/theme/app_animations.dart';
// // import 'package:kenyanvalley/features/events/presentation/screens/events_list_screen.dart';
// // import 'package:kenyanvalley/features/auth/presentation/screens/profile_screen.dart';
// // import 'package:kenyanvalley/features/events/presentation/providers/events_provider.dart';
// // import 'package:kenyanvalley/features/events/data/models/event_model.dart';
// // import 'package:kenyanvalley/features/notes/presentation/screens/notes_list_screen.dart';
// // import 'package:intl/intl.dart';

// // class DashboardScreen extends StatefulWidget {
// //   const DashboardScreen({Key? key}) : super(key: key);

// //   @override
// //   State<DashboardScreen> createState() => _DashboardScreenState();
// // }

// // class _DashboardScreenState extends State<DashboardScreen>
// //     with TickerProviderStateMixin {
// //   late AnimationController _animationController;
// //   late List<Animation<double>> _cardAnimations;

// //   int _selectedIndex = 0;
// //   final PageController _pageController = PageController();

// //   @override
// //   void didChangeDependencies() {
// //     super.didChangeDependencies();
// //     // Fetch organizer events when the dashboard loads
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
// //       eventsProvider.getOrganizerEvents();
// //     });
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     _animationController = AnimationController(
// //       duration: AppAnimations.medium,
// //       vsync: this,
// //     );

// //     _cardAnimations = List.generate(
// //       4,
// //       (index) => AppAnimations.staggerAnimation(_animationController, index, 4),
// //     );

// //     _animationController.forward();
// //   }

// //   @override
// //   void dispose() {
// //     _animationController.dispose();
// //     _pageController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final authProvider = Provider.of<AuthProvider>(context);
// //     final user = authProvider.user;

// //     if (!authProvider.isLoggedIn || user == null) {
// //       WidgetsBinding.instance.addPostFrameCallback((_) {
// //         Navigator.pushReplacementNamed(context, '/login');
// //       });
// //       return const Scaffold(body: Center(child: CircularProgressIndicator()));
// //     }

// //     return Scaffold(
// //       backgroundColor: AppColors.background,
// //       body: SafeArea(
// //         child: PageView(
// //           controller: _pageController,
// //           onPageChanged: (index) {
// //             setState(() {
// //               _selectedIndex = index;
// //             });
// //           },
// //           children: [
// //             _buildDashboardHome(user),
// //             _buildEventsPage(),
// //             const ProfileScreen(),
// //             _buildSettingsPage(authProvider),
// //           ],
// //         ),
// //       ),
// //       bottomNavigationBar: _buildBottomNavigationBar(),
// //     );
// //   }

// //   Widget _buildDashboardHome(dynamic user) {
// //     return CustomScrollView(
// //       slivers: [
// //         _buildAppBar(user),
// //         SliverToBoxAdapter(
// //           child: Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
// //             child: GridView.count(
// //               shrinkWrap: true,
// //               physics: const NeverScrollableScrollPhysics(),
// //               crossAxisCount: 2,
// //               crossAxisSpacing: 16,
// //               mainAxisSpacing: 16,
// //               childAspectRatio: 1.5,
// //               children: [
// //                 _buildDashboardCard(
// //                   context,
// //                   title: 'Events',
// //                   icon: Icons.event,
// //                   onTap: () {
// //                     Navigator.pushNamed(context, '/events');
// //                   },
// //                 ),
// //                 _buildDashboardCard(
// //                   context,
// //                   title: 'Notes',
// //                   icon: Icons.note_alt,
// //                   onTap: () {
// //                     Navigator.pushNamed(context, '/notes');
// //                   },
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //         SliverToBoxAdapter(
// //           child: Padding(
// //             padding: const EdgeInsets.all(AppDimensions.paddingLg),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 _buildQuickStats(),
// //                 const SizedBox(height: AppDimensions.spacingLg),
// //                 _buildRecentEvents(),
// //                 const SizedBox(height: AppDimensions.spacingLg),
// //                 _buildQuickActions(),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildAppBar(dynamic user) {
// //     return SliverAppBar(
// //       expandedHeight: 120,
// //       floating: false,
// //       pinned: true,
// //       backgroundColor: AppColors.primary,
// //       flexibleSpace: FlexibleSpaceBar(
// //         background: Container(
// //           decoration: const BoxDecoration(
// //             gradient: LinearGradient(
// //               colors: [AppColors.primary, AppColors.secondary],
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //             ),
// //           ),
// //           child: Padding(
// //             padding: const EdgeInsets.all(AppDimensions.paddingLg),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               mainAxisAlignment: MainAxisAlignment.end,
// //               children: [
// //                 Text(
// //                   'Welcome back,',
// //                   style: AppTextStyles.bodyMedium.copyWith(
// //                     color: Colors.white70,
// //                   ),
// //                 ),
// //                 Text(
// //                   user.fullName ?? 'User',
// //                   style: AppTextStyles.headlineMedium.copyWith(
// //                     color: Colors.white,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //       actions: [
// //         IconButton(
// //           icon: const Icon(Icons.notifications_outlined, color: Colors.white),
// //           onPressed: () {
// //             // Handle notifications
// //           },
// //         ),
// //         IconButton(
// //           icon: const Icon(Icons.search, color: Colors.white),
// //           onPressed: () {
// //             // Handle search
// //           },
// //         ),
// //       ],
// //     );
// //   }

// //   // ADD THE MISSING _buildStatCard METHOD
// //   Widget _buildStatCard(
// //     String title,
// //     String value,
// //     IconData icon,
// //     Color color,
// //   ) {
// //     return Container(
// //       padding: const EdgeInsets.all(AppDimensions.paddingMd),
// //       decoration: BoxDecoration(
// //         color: AppColors.surface,
// //         borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
// //         boxShadow: [
// //           BoxShadow(
// //             color: AppColors.textPrimary.withOpacity(0.05),
// //             blurRadius: 10,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.all(AppDimensions.paddingSm),
// //             decoration: BoxDecoration(
// //               color: color.withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
// //             ),
// //             child: Icon(icon, color: color, size: AppDimensions.iconSm),
// //           ),
// //           const SizedBox(height: AppDimensions.spacingSm),
// //           Text(
// //             value,
// //             style: AppTextStyles.headlineSmall.copyWith(
// //               fontWeight: FontWeight.bold,
// //               color: AppColors.textPrimary,
// //             ),
// //           ),
// //           Text(
// //             title,
// //             style: AppTextStyles.bodySmall.copyWith(
// //               color: AppColors.textSecondary,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildQuickStats() {
// //     return Consumer<EventsProvider>(
// //       builder: (context, eventsProvider, _) {
// //         final events = eventsProvider.events;
// //         final now = DateTime.now();
// //         final upcomingEvents = events.where((event) =>
// //           event.endDate.isAfter(now)
// //         ).length;

// //         // Calculate total attendees by summing the length of attendees list for each event
// //         final totalAttendees = events.fold<int>(0, (sum, event) => sum + event.attendees.length);

// //         return Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Quick Stats',
// //               style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: AppDimensions.spacingMd),
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: AnimatedBuilder(
// //                     animation: _cardAnimations[0],
// //                     builder: (context, child) {
// //                       return Transform.scale(
// //                         scale: _cardAnimations[0].value,
// //                         child: _buildStatCard(
// //                           'Total Events',
// //                           '${events.length}',
// //                           Icons.event,
// //                           AppColors.primary,
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 ),
// //                 const SizedBox(width: AppDimensions.spacingMd),
// //                 Expanded(
// //                   child: AnimatedBuilder(
// //                     animation: _cardAnimations[1],
// //                     builder: (context, child) {
// //                       return Transform.scale(
// //                         scale: _cardAnimations[1].value,
// //                         child: _buildStatCard(
// //                           'Total Attendees',
// //                           totalAttendees.toString(),
// //                           Icons.people,
// //                           AppColors.secondary,
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: AppDimensions.spacingMd),
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: AnimatedBuilder(
// //                     animation: _cardAnimations[2],
// //                     builder: (context, child) {
// //                       return Transform.scale(
// //                         scale: _cardAnimations[2].value,
// //                         child: _buildStatCard(
// //                           'Upcoming',
// //                           '$upcomingEvents',
// //                           Icons.calendar_today,
// //                           AppColors.success,
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 ),
// //                 const SizedBox(width: AppDimensions.spacingMd),
// //                 const Spacer(),
// //               ],
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildDashboardCard(
// //     BuildContext context, {
// //     required String title,
// //     required IconData icon,
// //     required VoidCallback onTap,
// //   }) {
// //     return Card(
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: InkWell(
// //         onTap: onTap,
// //         borderRadius: BorderRadius.circular(12),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(icon, size: 40, color: Theme.of(context).primaryColor),
// //             const SizedBox(height: 8),
// //             Text(
// //               title,
// //               style: Theme.of(context).textTheme.titleMedium?.copyWith(
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildEventCard({
// //     required String title,
// //     required String date,
// //     required String location,
// //     required int attendees,
// //     required int? price,
// //     required String? imageUrl,
// //     required bool isUpcoming,
// //   }) {
// //     return Card(
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(16.0),
// //       ),
// //       child: InkWell(
// //         onTap: () {
// //           // Navigate to event details when tapped
// //           // Navigator.pushNamed(context, '/event-details', arguments: eventId);
// //         },
// //         borderRadius: BorderRadius.circular(16.0),
// //         child: Container(
// //           width: 300,
// //           margin: const EdgeInsets.all(1),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // Event Image
// //               Stack(
// //                 children: [
// //                   ClipRRect(
// //                     borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
// //                     child: Container(
// //                       height: 140,
// //                       width: double.infinity,
// //                       color: AppColors.primary.withOpacity(0.1),
// //                       child: imageUrl != null && imageUrl.isNotEmpty
// //                           ? Image.network(
// //                               imageUrl,
// //                               fit: BoxFit.cover,
// //                               errorBuilder: (context, error, stackTrace) => _buildDefaultEventImage(),
// //                             )
// //                           : _buildDefaultEventImage(),
// //                     ),
// //                   ),
// //                   if (isUpcoming)
// //                     Positioned(
// //                       top: 8,
// //                       right: 8,
// //                       child: Container(
// //                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //                         decoration: BoxDecoration(
// //                           color: AppColors.success.withOpacity(0.9),
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                         child: Text(
// //                           'Upcoming',
// //                           style: AppTextStyles.bodySmall.copyWith(
// //                             color: Colors.white,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                 ],
// //               ),

// //               // Event Details
// //               Padding(
// //                 padding: const EdgeInsets.all(12.0),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     // Event Title
// //                     Text(
// //                       title,
// //                       style: AppTextStyles.titleMedium.copyWith(
// //                         fontWeight: FontWeight.bold,
// //                         color: AppColors.textPrimary,
// //                       ),
// //                       maxLines: 2,
// //                       overflow: TextOverflow.ellipsis,
// //                     ),

// //                     const SizedBox(height: 8),

// //                     // Date and Time
// //                     Row(
// //                       children: [
// //                         Icon(
// //                           Icons.calendar_today,
// //                           size: 16,
// //                           color: AppColors.textSecondary,
// //                         ),
// //                         const SizedBox(width: 6),
// //                         Expanded(
// //                           child: Text(
// //                             date,
// //                             style: AppTextStyles.bodySmall.copyWith(
// //                               color: AppColors.textSecondary,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),

// //                     const SizedBox(height: 6),

// //                     // Location
// //                     if (location.isNotEmpty) ...[
// //                       Row(
// //                         children: [
// //                           Icon(
// //                             Icons.location_on,
// //                             size: 16,
// //                             color: AppColors.textSecondary,
// //                           ),
// //                           const SizedBox(width: 6),
// //                           Expanded(
// //                             child: Text(
// //                               location,
// //                               style: AppTextStyles.bodySmall.copyWith(
// //                                 color: AppColors.textSecondary,
// //                               ),
// //                               maxLines: 1,
// //                               overflow: TextOverflow.ellipsis,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 6),
// //                     ],

// //                     // Attendees and Price
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         // Attendees
// //                         Row(
// //                           children: [
// //                             Icon(
// //                               Icons.people,
// //                               size: 16,
// //                               color: AppColors.textSecondary,
// //                             ),
// //                             const SizedBox(width: 4),
// //                             Text(
// //                               '$attendees ${attendees == 1 ? 'attendee' : 'attendees'}' ,
// //                               style: AppTextStyles.bodySmall.copyWith(
// //                                 color: AppColors.textSecondary,
// //                               ),
// //                             ),
// //                           ],
// //                         ),

// //                         // Price
// //                         if (price != null && price > 0)
// //                           Container(
// //                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //                             decoration: BoxDecoration(
// //                               color: AppColors.primary.withOpacity(0.1),
// //                               borderRadius: BorderRadius.circular(12),
// //                             ),
// //                             child: Text(
// //                               'KSH ${price.toStringAsFixed(2)}',
// //                               style: AppTextStyles.bodySmall.copyWith(
// //                                 color: AppColors.primary,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                           )
// //                         else
// //                           Container(
// //                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //                             decoration: BoxDecoration(
// //                               color: Colors.green.withOpacity(0.1),
// //                               borderRadius: BorderRadius.circular(12),
// //                             ),
// //                             child: Text(
// //                               'Free',
// //                               style: AppTextStyles.bodySmall.copyWith(
// //                                 color: Colors.green,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                           ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildRecentEvents() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Text(
// //               'Recent Events',
// //               style: AppTextStyles.titleLarge.copyWith(
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             TextButton(
// //               onPressed: () {
// //                 // Navigate to all events
// //                 _pageController.jumpToPage(1);
// //               },
// //               child: Text(
// //                 'View All',
// //                 style: AppTextStyles.bodyMedium.copyWith(
// //                   color: AppColors.primary,
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //         const SizedBox(height: AppDimensions.spacingMd),
// //         Consumer<EventsProvider>(
// //           builder: (context, eventsProvider, _) {
// //             if (eventsProvider.isLoading && eventsProvider.events.isEmpty) {
// //               return const Center(child: CircularProgressIndicator());
// //             }

// //             if (eventsProvider.error != null) {
// //               return Center(
// //                 child: Text(
// //                   'Error loading events: ${eventsProvider.error}',
// //                   style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
// //                 ),
// //               );
// //             }

// //             if (eventsProvider.events.isEmpty) {
// //               return Center(
// //                 child: Text(
// //                   'No events found. Create your first event!',
// //                   style: AppTextStyles.bodyMedium,
// //                 ),
// //               );
// //             }

// //             // Sort events by date (newest first)
// //             final sortedEvents = List<EventModel>.from(eventsProvider.events)
// //               ..sort((a, b) => b.startDate.compareTo(a.startDate));

// //             // Take up to 5 most recent events
// //             final recentEvents = sortedEvents.take(5).toList();

// //             return SizedBox(
// //               height: 320, // Increased height for better card visibility
// //               child: ListView.builder(
// //                 scrollDirection: Axis.horizontal,
// //                 itemCount: recentEvents.length,
// //                 itemBuilder: (context, index) {
// //                   final event = recentEvents[index];
// //                   final isUpcoming = event.startDate.isAfter(DateTime.now());
// //                   final dateFormat = DateFormat('MMM d, y • h:mm a');
// //                   final dateString = dateFormat.format(event.startDate);

// //                   // FIXED: Handle the venueName property issue
// //                   String location = 'Location not specified';
// //                   if (event.location != null) {
// //                     // Check if the location has the required properties
// //                     // If venueName doesn't exist, try alternative properties or use a fallback
// //                     final loc = event.location!;
// //                     if (loc.city != null) {
// //                       // Try to build location string with available properties
// //                       location = loc.city!;
// //                       // Add venue name if it exists (you may need to check your EventLocation model)
// //                       // This assumes you might have a 'name' or 'venue' property instead of 'venueName'
// //                       // location = '${loc.name ?? 'Venue'}, ${loc.city}';
// //                     }
// //                   }

// //                   return _buildEventCard(
// //                     title: event.title,
// //                     date: dateString,
// //                     location: location,
// //                     attendees: event.attendees?.length ?? 0,
// //                     price: event.ticketPrice?.toInt(),
// //                     imageUrl: event.coverImage,
// //                     isUpcoming: isUpcoming,
// //                   );
// //                 },
// //               ),
// //             );
// //           },
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildDefaultEventImage() {
// //     return Container(
// //       color: AppColors.primary.withOpacity(0.1),
// //       child: const Center(
// //         child: Icon(
// //           Icons.event,
// //           size: 50,
// //           color: AppColors.primary,
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildQuickActions() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           'Quick Actions',
// //           style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
// //         ),
// //         const SizedBox(height: AppDimensions.spacingMd),
// //         GridView.count(
// //           crossAxisCount: 2,
// //           shrinkWrap: true,
// //           physics: const NeverScrollableScrollPhysics(),
// //           crossAxisSpacing: AppDimensions.spacingMd,
// //           mainAxisSpacing: AppDimensions.spacingMd,
// //           childAspectRatio: 1.5,
// //           children: [
// //             _buildActionCard(
// //               'Create Event',
// //               Icons.add_circle_outline,
// //               AppColors.primary,
// //               () {
// //                 Navigator.pushNamed(context, '/events/create');
// //               },
// //             ),
// //             _buildActionCard(
// //               'View Analytics',
// //               Icons.bar_chart,
// //               AppColors.secondary,
// //               () {
// //                 // Handle view analytics
// //               },
// //             ),
// //             _buildActionCard(
// //               'Manage Attendees',
// //               Icons.group,
// //               AppColors.success,
// //               () {
// //                 // Handle manage attendees
// //               },
// //             ),
// //             _buildActionCard('Settings', Icons.settings, AppColors.error, () {
// //               // Handle settings
// //             }),
// //           ],
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildActionCard(
// //     String title,
// //     IconData icon,
// //     Color color,
// //     VoidCallback onTap,
// //   ) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         padding: const EdgeInsets.all(AppDimensions.paddingMd),
// //         decoration: BoxDecoration(
// //           color: AppColors.surface,
// //           borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
// //           boxShadow: [
// //             BoxShadow(
// //               color: AppColors.textPrimary.withOpacity(0.05),
// //               blurRadius: 10,
// //               offset: const Offset(0, 2),
// //             ),
// //           ],
// //         ),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(AppDimensions.paddingMd),
// //               decoration: BoxDecoration(
// //                 color: color.withOpacity(0.1),
// //                 borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
// //               ),
// //               child: Icon(icon, color: color, size: AppDimensions.iconMd),
// //             ),
// //             const SizedBox(height: AppDimensions.spacingMd),
// //             Text(
// //               title,
// //               style: AppTextStyles.bodyMedium.copyWith(
// //                 fontWeight: FontWeight.w600,
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildEventsPage() {
// //     return const EventsListPage();
// //   }

// //   Widget _buildSettingsPage(AuthProvider authProvider) {
// //     return const SettingsPage();
// //   }

// //   Widget _buildBottomNavigationBar() {
// //     return BottomNavigationBar(
// //       currentIndex: _selectedIndex,
// //       onTap: (index) {
// //         setState(() {
// //           _selectedIndex = index;
// //           _pageController.jumpToPage(index);
// //         });
// //       },
// //       items: const [
// //         BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
// //         BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
// //         BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
// //         BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
// //       ],
// //       selectedItemColor: AppColors.primary,
// //       unselectedItemColor: AppColors.textSecondary,
// //       showUnselectedLabels: true,
// //       type: BottomNavigationBarType.fixed,
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:kenyanvalley/features/auth/presentation/screens/settings_screen.dart';
// import 'package:provider/provider.dart';
// import '../../../../core/theme/app_dimensions.dart';
// import '../providers/auth_provider.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/theme/app_text_styles.dart';
// import '../../../../core/theme/app_animations.dart';
// import 'package:kenyanvalley/features/events/presentation/screens/events_list_screen.dart';
// import 'package:kenyanvalley/features/auth/presentation/screens/profile_screen.dart';
// import 'package:kenyanvalley/features/events/presentation/providers/events_provider.dart';
// import 'package:kenyanvalley/features/events/data/models/event_model.dart';
// import 'package:kenyanvalley/features/notes/presentation/screens/notes_list_screen.dart';
// import 'package:intl/intl.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({Key? key}) : super(key: key);

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late List<Animation<double>> _cardAnimations;

//   int _selectedIndex = 0;
//   final PageController _pageController = PageController();

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
//       eventsProvider.getOrganizerEvents();
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: AppAnimations.medium,
//       vsync: this,
//     );

//     _cardAnimations = List.generate(
//       4,
//       (index) => AppAnimations.staggerAnimation(_animationController, index, 4),
//     );

//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final user = authProvider.user;

//     if (!authProvider.isLoggedIn || user == null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Navigator.pushReplacementNamed(context, '/login');
//       });
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: PageView(
//           controller: _pageController,
//           onPageChanged: (index) {
//             setState(() {
//               _selectedIndex = index;
//             });
//           },
//           children: [
//             _buildDashboardHome(user),
//             _buildEventsPage(),
//             const ProfileScreen(),
//             _buildSettingsPage(authProvider),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _buildBottomNavigationBar(),
//     );
//   }

//   Widget _buildDashboardHome(dynamic user) {
//     return CustomScrollView(
//       slivers: [
//         _buildAppBar(user),
//         SliverToBoxAdapter(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Main Action Cards - Simplified and More Prominent
//                 _buildMainActionCards(),
//                 const SizedBox(height: 32),

//                 // Quick Stats Section
//                 _buildQuickStats(),
//                 const SizedBox(height: 32),

//                 // Recent Events Section
//                 _buildRecentEvents(),
//                 const SizedBox(height: 32),

//                 // Quick Actions Section (Removed Settings)
//                 _buildQuickActions(),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAppBar(dynamic user) {
//     return SliverAppBar(
//       expandedHeight: 140,
//       floating: false,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: AppColors.primary,
//       flexibleSpace: FlexibleSpaceBar(
//         background: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [AppColors.primary, AppColors.secondary],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: const BorderRadius.only(
//               bottomLeft: Radius.circular(24),
//               bottomRight: Radius.circular(24),
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Text(
//                   'Welcome back,',
//                   style: AppTextStyles.bodyMedium.copyWith(
//                     color: Colors.white.withOpacity(0.8),
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   user.fullName ?? 'User',
//                   style: AppTextStyles.headlineMedium.copyWith(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 28,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       actions: [
//         Container(
//           margin: const EdgeInsets.only(right: 8),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: IconButton(
//             icon: const Icon(Icons.notifications_outlined, color: Colors.white),
//             onPressed: () {
//               // Handle notifications
//             },
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.only(right: 16),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: IconButton(
//             icon: const Icon(Icons.search, color: Colors.white),
//             onPressed: () {
//               // Handle search
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMainActionCards() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildMainActionCard(
//             title: 'Events',
//             subtitle: 'Manage your events',
//             icon: Icons.event_outlined,
//             color: AppColors.primary,
//             onTap: () => Navigator.pushNamed(context, '/events'),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: _buildMainActionCard(
//             title: 'Notes',
//             subtitle: 'Quick notes',
//             icon: Icons.note_alt_outlined,
//             color: AppColors.secondary,
//             onTap: () => Navigator.pushNamed(context, '/notes'),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMainActionCard({
//     required String title,
//     required String subtitle,
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       height: 120,
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: color.withOpacity(0.2),
//           width: 1,
//         ),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(20),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     icon,
//                     color: color,
//                     size: 24,
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: AppTextStyles.titleMedium.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//                     Text(
//                       subtitle,
//                       style: AppTextStyles.bodySmall.copyWith(
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatCard(
//     String title,
//     String value,
//     IconData icon,
//     Color color,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.textPrimary.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(icon, color: color, size: 20),
//               ),
//               Icon(
//                 Icons.trending_up,
//                 color: Colors.green,
//                 size: 16,
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             value,
//             style: AppTextStyles.headlineMedium.copyWith(
//               fontWeight: FontWeight.bold,
//               color: AppColors.textPrimary,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             title,
//             style: AppTextStyles.bodyMedium.copyWith(
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickStats() {
//     return Consumer<EventsProvider>(
//       builder: (context, eventsProvider, _) {
//         final events = eventsProvider.events;
//         final now = DateTime.now();
//         final upcomingEvents = events.where((event) =>
//           event.endDate.isAfter(now)
//         ).length;

//         final totalAttendees = events.fold<int>(0, (sum, event) => sum + event.attendees.length);

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Overview',
//               style: AppTextStyles.titleLarge.copyWith(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 24,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: AnimatedBuilder(
//                     animation: _cardAnimations[0],
//                     builder: (context, child) {
//                       return Transform.scale(
//                         scale: _cardAnimations[0].value,
//                         child: _buildStatCard(
//                           'Total Events',
//                           '${events.length}',
//                           Icons.event_outlined,
//                           AppColors.primary,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: AnimatedBuilder(
//                     animation: _cardAnimations[1],
//                     builder: (context, child) {
//                       return Transform.scale(
//                         scale: _cardAnimations[1].value,
//                         child: _buildStatCard(
//                           'Total Attendees',
//                           totalAttendees.toString(),
//                           Icons.people_outline,
//                           AppColors.secondary,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             AnimatedBuilder(
//               animation: _cardAnimations[2],
//               builder: (context, child) {
//                 return Transform.scale(
//                   scale: _cardAnimations[2].value,
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.45,
//                     child: _buildStatCard(
//                       'Upcoming Events',
//                       '$upcomingEvents',
//                       Icons.calendar_today_outlined,
//                       AppColors.success,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildEventCard({
//     required String title,
//     required String date,
//     required String location,
//     required int attendees,
//     required int? price,
//     required String? imageUrl,
//     required bool isUpcoming,
//   }) {
//     return Container(
//       width: 280,
//       margin: const EdgeInsets.only(right: 16),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.textPrimary.withOpacity(0.08),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {
//             // Navigate to event details
//           },
//           borderRadius: BorderRadius.circular(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Event Image with Status Badge
//               Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//                     child: Container(
//                       height: 140,
//                       width: double.infinity,
//                       color: AppColors.primary.withOpacity(0.1),
//                       child: imageUrl != null && imageUrl.isNotEmpty
//                           ? Image.network(
//                               imageUrl,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) => _buildDefaultEventImage(),
//                             )
//                           : _buildDefaultEventImage(),
//                     ),
//                   ),
//                   if (isUpcoming)
//                     Positioned(
//                       top: 12,
//                       right: 12,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: AppColors.success,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           'Upcoming',
//                           style: AppTextStyles.bodySmall.copyWith(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 11,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),

//               // Event Details
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: AppTextStyles.titleMedium.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.textPrimary,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 12),

//                     // Date
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.schedule_outlined,
//                           size: 16,
//                           color: AppColors.textSecondary,
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             date,
//                             style: AppTextStyles.bodySmall.copyWith(
//                               color: AppColors.textSecondary,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),

//                     // Location
//                     if (location.isNotEmpty) ...[
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.location_on_outlined,
//                             size: 16,
//                             color: AppColors.textSecondary,
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               location,
//                               style: AppTextStyles.bodySmall.copyWith(
//                                 color: AppColors.textSecondary,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                     ],

//                     // Bottom Row - Attendees and Price
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.people_outline,
//                               size: 16,
//                               color: AppColors.textSecondary,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               '$attendees',
//                               style: AppTextStyles.bodySmall.copyWith(
//                                 color: AppColors.textSecondary,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: price != null && price > 0
//                                 ? AppColors.primary.withOpacity(0.1)
//                                 : Colors.green.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             price != null && price > 0
//                                 ? 'KSH $price'
//                                 : 'Free',
//                             style: AppTextStyles.bodySmall.copyWith(
//                               color: price != null && price > 0
//                                   ? AppColors.primary
//                                   : Colors.green,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRecentEvents() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Recent Events',
//               style: AppTextStyles.titleLarge.copyWith(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 24,
//               ),
//             ),
//             TextButton.icon(
//               onPressed: () {
//                 _pageController.jumpToPage(1);
//               },
//               icon: const Icon(Icons.arrow_forward, size: 16),
//               label: Text(
//                 'View All',
//                 style: AppTextStyles.bodyMedium.copyWith(
//                   color: AppColors.primary,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         Consumer<EventsProvider>(
//           builder: (context, eventsProvider, _) {
//             if (eventsProvider.isLoading && eventsProvider.events.isEmpty) {
//               return const SizedBox(
//                 height: 200,
//                 child: Center(child: CircularProgressIndicator()),
//               );
//             }

//             if (eventsProvider.error != null) {
//               return Container(
//                 height: 200,
//                 decoration: BoxDecoration(
//                   color: AppColors.error.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.error_outline, color: AppColors.error, size: 48),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Error loading events',
//                         style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }

//             if (eventsProvider.events.isEmpty) {
//               return Container(
//                 height: 200,
//                 decoration: BoxDecoration(
//                   color: AppColors.surface,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.event_outlined, color: AppColors.textSecondary, size: 48),
//                       const SizedBox(height: 16),
//                       Text(
//                         'No events yet',
//                         style: AppTextStyles.titleMedium.copyWith(
//                           color: AppColors.textPrimary,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Create your first event to get started',
//                         style: AppTextStyles.bodyMedium.copyWith(
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }

//             final sortedEvents = List<EventModel>.from(eventsProvider.events)
//               ..sort((a, b) => b.startDate.compareTo(a.startDate));
//             final recentEvents = sortedEvents.take(5).toList();

//             return SizedBox(
//               height: 300,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.only(left: 4),
//                 itemCount: recentEvents.length,
//                 itemBuilder: (context, index) {
//                   final event = recentEvents[index];
//                   final isUpcoming = event.startDate.isAfter(DateTime.now());
//                   final dateFormat = DateFormat('MMM d, y • h:mm a');
//                   final dateString = dateFormat.format(event.startDate);

//                   String location = 'Location not specified';
//                   if (event.location != null) {
//                     final loc = event.location!;
//                     if (loc.city != null) {
//                       location = loc.city!;
//                     }
//                   }

//                   return _buildEventCard(
//                     title: event.title,
//                     date: dateString,
//                     location: location,
//                     attendees: event.attendees?.length ?? 0,
//                     price: event.ticketPrice?.toInt(),
//                     imageUrl: event.coverImage,
//                     isUpcoming: isUpcoming,
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildDefaultEventImage() {
//     return Container(
//       color: AppColors.primary.withOpacity(0.1),
//       child: Center(
//         child: Icon(
//           Icons.event_outlined,
//           size: 40,
//           color: AppColors.primary.withOpacity(0.7),
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickActions() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Quick Actions',
//           style: AppTextStyles.titleLarge.copyWith(
//             fontWeight: FontWeight.bold,
//             fontSize: 24,
//           ),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Expanded(
//               child: _buildActionCard(
//                 'Create Event',
//                 Icons.add_circle_outline,
//                 AppColors.primary,
//                 () {
//                   Navigator.pushNamed(context, '/events/create');
//                 },
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: _buildActionCard(
//                 'Analytics',
//                 Icons.bar_chart_outlined,
//                 AppColors.secondary,
//                 () {
//                   // Handle view analytics
//                 },
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         SizedBox(
//           width: MediaQuery.of(context).size.width * 0.45,
//           child: _buildActionCard(
//             'Manage Attendees',
//             Icons.group_outlined,
//             AppColors.success,
//             () {
//               // Handle manage attendees
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildActionCard(
//     String title,
//     IconData icon,
//     Color color,
//     VoidCallback onTap,
//   ) {
//     return Container(
//       height: 100,
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: color.withOpacity(0.2),
//           width: 1,
//         ),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(icon, color: color, size: 24),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   title,
//                   style: AppTextStyles.bodyMedium.copyWith(
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textPrimary,
//                   ),
//                   textAlign: TextAlign.center,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEventsPage() {
//     return const EventsListPage();
//   }

//   Widget _buildSettingsPage(AuthProvider authProvider) {
//     return const SettingsPage();
//   }

//   Widget _buildBottomNavigationBar() {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.textPrimary.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//             _pageController.jumpToPage(index);
//           });
//         },
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard_outlined),
//             activeIcon: Icon(Icons.dashboard),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.event_outlined),
//             activeIcon: Icon(Icons.event),
//             label: 'Events',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outline),
//             activeIcon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings_outlined),
//             activeIcon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//         selectedItemColor: AppColors.primary,
//         unselectedItemColor: AppColors.textSecondary,
//         showUnselectedLabels: true,
//         type: BottomNavigationBarType.fixed,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:kenyanvalley/features/auth/presentation/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_animations.dart';
import 'package:kenyanvalley/features/events/presentation/screens/events_list_screen.dart';
import 'package:kenyanvalley/features/auth/presentation/screens/profile_screen.dart';
import 'package:kenyanvalley/features/events/presentation/providers/events_provider.dart';
import 'package:kenyanvalley/features/events/data/models/event_model.dart';
import 'package:kenyanvalley/features/notes/presentation/screens/notes_list_screen.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:kenyanvalley/core/theme/app_dimensions.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late List<Animation<double>> _cardAnimations;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
      eventsProvider.getOrganizerEvents();
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _cardAnimations = List.generate(
      6,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.1,
            0.6 + (index * 0.1),
            curve: Curves.elasticOut,
          ),
        ),
      ),
    );

    _floatingAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (!authProvider.isLoggedIn || user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            _buildDashboardHome(user),
            _buildEventsPage(),
            const ProfileScreen(),
            _buildSettingsPage(authProvider),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildModernBottomBar(),
    );
  }

  Widget _buildDashboardHome(dynamic user) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryLight.withOpacity(0.1),
            AppColors.background,
          ],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          _buildHeader(user),
          SliverPadding(
            padding: const EdgeInsets.all(AppDimensions.paddingLg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats Dashboard
                _buildStatsDashboard(),
                const SizedBox(height: AppDimensions.spacingXl),

                // Quick Actions Grid
                _buildQuickActions(),
                const SizedBox(height: AppDimensions.spacingXl),

                // Recent Events
                _buildRecentEvents(),
                const SizedBox(height: AppDimensions.spacingXl),

                // Additional Actions
                _buildAdditionalActions(),
                const SizedBox(height: 100), // Space for FAB
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(dynamic user) {
    return SliverAppBar(
      expandedHeight: 160,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primary.withOpacity(0.9),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryLight,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.paddingLg,
                AppDimensions.paddingLg,
                AppDimensions.paddingLg,
                AppDimensions.paddingMd,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '✨ Welcome back',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.fullName ?? 'User',
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, color: Colors.white),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: Colors.white),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildStatsDashboard() {
    return Consumer<EventsProvider>(
      builder: (context, eventsProvider, _) {
        final events = eventsProvider.events;
        final now = DateTime.now();
        final upcomingEvents = events.where((event) => event.endDate.isAfter(now)).length;
        final totalAttendees = events.fold<int>(0, (sum, event) => sum + event.attendees.length);

        return AnimatedBuilder(
          animation: _floatingAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatingAnimation.value),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingLg),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          '${events.length}',
                          'Total Events',
                          Icons.event_note,
                          AppColors.primary,
                          0,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 60,
                        color: AppColors.outline,
                      ),
                      Expanded(
                        child: _buildStatItem(
                          '$totalAttendees',
                          'Attendees',
                          Icons.people,
                          AppColors.secondary,
                          1,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 60,
                        color: AppColors.outline,
                      ),
                      Expanded(
                        child: _buildStatItem(
                          '$upcomingEvents',
                          'Upcoming',
                          Icons.schedule,
                          AppColors.success,
                          2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, Color color, int index) {
    return AnimatedBuilder(
      animation: _cardAnimations[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _cardAnimations[index].value,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingLg),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: AppDimensions.spacingMd,
          mainAxisSpacing: AppDimensions.spacingMd,
          childAspectRatio: 1.2,
          children: [
            _buildActionCard(
              'Create Event',
              Icons.add_circle,
              AppColors.primary,
              () => Navigator.pushNamed(context, '/events/create'),
              0,
            ),
            _buildActionCard(
              'View Events',
              Icons.event,
              AppColors.secondary,
              () => _pageController.jumpToPage(1),
              1,
            ),
            _buildActionCard(
              'Notes',
              Icons.note_alt,
              AppColors.success,
              () => Navigator.pushNamed(context, '/notes'),
              2,
            ),
            _buildActionCard(
              'Analytics',
              Icons.bar_chart,
              AppColors.error,
              () {},
              3,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap, int index) {
    return AnimatedBuilder(
      animation: _cardAnimations[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _cardAnimations[index].value,
          child: Card(
            elevation: 2,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 32),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Events',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => _pageController.jumpToPage(1),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingLg),
        Consumer<EventsProvider>(
          builder: (context, eventsProvider, _) {
            if (eventsProvider.isLoading && eventsProvider.events.isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingXl),
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            if (eventsProvider.events.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingXl),
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 60,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No events yet',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your first event to get started',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            final sortedEvents = List<EventModel>.from(eventsProvider.events)
              ..sort((a, b) => b.startDate.compareTo(a.startDate));
            final recentEvents = sortedEvents.take(3).toList();

            return SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recentEvents.length,
                itemBuilder: (context, index) {
                  final event = recentEvents[index];
                  return _buildEventCard(event, index);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventCard(EventModel event, int index) {
    final isUpcoming = event.startDate.isAfter(DateTime.now());
    final dateFormat = DateFormat('MMM d, y');
    final dateString = dateFormat.format(event.startDate);

    String location = 'Location not specified';
    if (event.location != null && event.location!.city != null) {
      location = event.location!.city!;
    }

    return AnimatedBuilder(
      animation: _cardAnimations[index % _cardAnimations.length],
      builder: (context, child) {
        return Transform.scale(
          scale: _cardAnimations[index % _cardAnimations.length].value,
          child: Container(
            width: 280,
            margin: const EdgeInsets.only(right: AppDimensions.marginMd),
            child: Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Image
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppDimensions.radiusLg),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.7),
                          AppColors.primaryLight.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: event.coverImage != null && event.coverImage!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(AppDimensions.radiusLg),
                            ),
                            child: Image.network(
                              event.coverImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildDefaultEventImage(),
                            ),
                          )
                        : _buildDefaultEventImage(),
                  ),

                  // Event Details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.paddingMd),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isUpcoming)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Upcoming',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          const SizedBox(height: 8),

                          Text(
                            event.title,
                            style: AppTextStyles.titleSmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  dateString,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          if (location.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    location,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const Spacer(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.outline.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.people,
                                      size: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${event.attendees?.length ?? 0}',
                                      style: AppTextStyles.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: event.ticketPrice != null && event.ticketPrice! > 0
                                      ? AppColors.primary.withOpacity(0.1)
                                      : AppColors.success.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  event.ticketPrice != null && event.ticketPrice! > 0
                                      ? 'KSH ${event.ticketPrice!.toInt()}'
                                      : 'Free',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: event.ticketPrice != null && event.ticketPrice! > 0
                                        ? AppColors.primary
                                        : AppColors.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefaultEventImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.3),
            AppColors.primaryLight.withOpacity(0.3),
          ],
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLg),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.event,
          size: 40,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildAdditionalActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'More Actions',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingLg),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Analytics',
                Icons.trending_up,
                AppColors.secondary,
                () {},
                4,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingMd),
            Expanded(
              child: _buildActionCard(
                'Attendees',
                Icons.group_add,
                AppColors.success,
                () {},
                5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/events/create'),
            backgroundColor: AppColors.primary,
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 28,
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernBottomBar() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.marginMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _pageController.jumpToPage(index);
            });
          },
          elevation: 0,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.dashboard_outlined, 0),
              activeIcon: _buildNavIcon(Icons.dashboard, 0),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.event_outlined, 1),
              activeIcon: _buildNavIcon(Icons.event, 1),
              label: 'Events',
            ),
            const BottomNavigationBarItem(
              icon: SizedBox(width: 56), // Space for FAB
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.person_outline, 2),
              activeIcon: _buildNavIcon(Icons.person, 2),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.settings_outlined, 3),
              activeIcon: _buildNavIcon(Icons.settings, 3),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        size: 24,
      ),
    );
  }

  Widget _buildEventsPage() {
    return const EventsListPage();
  }

  Widget _buildSettingsPage(AuthProvider authProvider) {
    return const SettingsPage();
  }
}
