import 'package:flutter/material.dart';
import 'package:kenyanvalley/features/auth/presentation/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_demsions.dart';
import '../providers/auth_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_animations.dart';
import 'package:kenyanvalley/features/events/presentation/screens/events_list_screen.dart';
import 'package:kenyanvalley/features/auth/presentation/screens/profile_screen.dart';
import 'package:kenyanvalley/features/events/presentation/providers/events_provider.dart';
import 'package:kenyanvalley/features/events/data/models/event_model.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _cardAnimations;

  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch organizer events when the dashboard loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
      eventsProvider.getOrganizerEvents();
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );

    _cardAnimations = List.generate(
      4,
      (index) => AppAnimations.staggerAnimation(_animationController, index, 4),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildDashboardHome(dynamic user) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(user),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQuickStats(),
                const SizedBox(height: AppDimensions.spacingLg),
                _buildRecentEvents(),
                const SizedBox(height: AppDimensions.spacingLg),
                _buildQuickActions(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(dynamic user) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Welcome back,',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                ),
                Text(
                  user.fullName ?? 'User',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {
            // Handle notifications
          },
        ),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            // Handle search
          },
        ),
      ],
    );
  }

  // ADD THE MISSING _buildStatCard METHOD
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingSm),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
            ),
            child: Icon(icon, color: color, size: AppDimensions.iconSm),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Consumer<EventsProvider>(
      builder: (context, eventsProvider, _) {
        final events = eventsProvider.events;
        final now = DateTime.now();
        final upcomingEvents = events.where((event) =>
          event.endDate.isAfter(now)
        ).length;

        // Calculate total attendees by summing the length of attendees list for each event
        final totalAttendees = events.fold<int>(0, (sum, event) => sum + event.attendees.length);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Stats',
              style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Row(
              children: [
                Expanded(
                  child: AnimatedBuilder(
                    animation: _cardAnimations[0],
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _cardAnimations[0].value,
                        child: _buildStatCard(
                          'Total Events',
                          '${events.length}',
                          Icons.event,
                          AppColors.primary,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMd),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _cardAnimations[1],
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _cardAnimations[1].value,
                        child: _buildStatCard(
                          'Total Attendees',
                          totalAttendees.toString(),
                          Icons.people,
                          AppColors.secondary,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Row(
              children: [
                Expanded(
                  child: AnimatedBuilder(
                    animation: _cardAnimations[2],
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _cardAnimations[2].value,
                        child: _buildStatCard(
                          'Upcoming',
                          '$upcomingEvents',
                          Icons.calendar_today,
                          AppColors.success,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMd),
                const Spacer(),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildEventCard({
    required String title,
    required String date,
    required String location,
    required int attendees,
    required int? price,
    required String? imageUrl,
    required bool isUpcoming,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to event details when tapped
          // Navigator.pushNamed(context, '/event-details', arguments: eventId);
        },
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          width: 300,
          margin: const EdgeInsets.all(1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      color: AppColors.primary.withOpacity(0.1),
                      child: imageUrl != null && imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _buildDefaultEventImage(),
                            )
                          : _buildDefaultEventImage(),
                    ),
                  ),
                  if (isUpcoming)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Upcoming',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Event Details
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Title
                    Text(
                      title,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Date and Time
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            date,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Location
                    if (location.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              location,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                    ],

                    // Attendees and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Attendees
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$attendees ${attendees == 1 ? 'attendee' : 'attendees'}' ,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),

                        // Price
                        if (price != null && price > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'KSH ${price.toStringAsFixed(2)}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Free',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
              onPressed: () {
                // Navigate to all events
                _pageController.jumpToPage(1);
              },
              child: Text(
                'View All',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        Consumer<EventsProvider>(
          builder: (context, eventsProvider, _) {
            if (eventsProvider.isLoading && eventsProvider.events.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (eventsProvider.error != null) {
              return Center(
                child: Text(
                  'Error loading events: ${eventsProvider.error}',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                ),
              );
            }

            if (eventsProvider.events.isEmpty) {
              return Center(
                child: Text(
                  'No events found. Create your first event!',
                  style: AppTextStyles.bodyMedium,
                ),
              );
            }

            // Sort events by date (newest first)
            final sortedEvents = List<EventModel>.from(eventsProvider.events)
              ..sort((a, b) => b.startDate.compareTo(a.startDate));

            // Take up to 5 most recent events
            final recentEvents = sortedEvents.take(5).toList();

            return SizedBox(
              height: 320, // Increased height for better card visibility
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recentEvents.length,
                itemBuilder: (context, index) {
                  final event = recentEvents[index];
                  final isUpcoming = event.startDate.isAfter(DateTime.now());
                  final dateFormat = DateFormat('MMM d, y • h:mm a');
                  final dateString = dateFormat.format(event.startDate);

                  // FIXED: Handle the venueName property issue
                  String location = 'Location not specified';
                  if (event.location != null) {
                    // Check if the location has the required properties
                    // If venueName doesn't exist, try alternative properties or use a fallback
                    final loc = event.location!;
                    if (loc.city != null) {
                      // Try to build location string with available properties
                      location = loc.city!;
                      // Add venue name if it exists (you may need to check your EventLocation model)
                      // This assumes you might have a 'name' or 'venue' property instead of 'venueName'
                      // location = '${loc.name ?? 'Venue'}, ${loc.city}';
                    }
                  }

                  return _buildEventCard(
                    title: event.title,
                    date: dateString,
                    location: location,
                    attendees: event.attendees?.length ?? 0,
                    price: event.ticketPrice?.toInt(),
                    imageUrl: event.coverImage,
                    isUpcoming: isUpcoming,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDefaultEventImage() {
    return Container(
      color: AppColors.primary.withOpacity(0.1),
      child: const Center(
        child: Icon(
          Icons.event,
          size: 50,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppDimensions.spacingMd,
          mainAxisSpacing: AppDimensions.spacingMd,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              'Create Event',
              Icons.add_circle_outline,
              AppColors.primary,
              () {
                Navigator.pushNamed(context, '/events/create');
              },
            ),
            _buildActionCard(
              'View Analytics',
              Icons.bar_chart,
              AppColors.secondary,
              () {
                // Handle view analytics
              },
            ),
            _buildActionCard(
              'Manage Attendees',
              Icons.group,
              AppColors.success,
              () {
                // Handle manage attendees
              },
            ),
            _buildActionCard('Settings', Icons.settings, AppColors.error, () {
              // Handle settings
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
              ),
              child: Icon(icon, color: color, size: AppDimensions.iconMd),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsPage() {
    return const EventsListPage();
  }

  Widget _buildSettingsPage(AuthProvider authProvider) {
    return const SettingsPage();
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
          _pageController.jumpToPage(index);
        });
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    );
  }
}
