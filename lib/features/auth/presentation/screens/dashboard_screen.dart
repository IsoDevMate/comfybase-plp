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
      final eventsProvider = Provider.of<EventsProvider>(
        context,
        listen: false,
      );
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
              colors: [AppColors.primary, AppColors.primaryLight],
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
        final upcomingEvents = events
            .where((event) => event.endDate.isAfter(now))
            .length;
        final totalAttendees = events.fold<int>(
          0,
          (sum, event) => sum + event.attendees.length,
        );

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
                      Container(width: 1, height: 60, color: AppColors.outline),
                      Expanded(
                        child: _buildStatItem(
                          '$totalAttendees',
                          'Attendees',
                          Icons.people,
                          AppColors.secondary,
                          1,
                        ),
                      ),
                      Container(width: 1, height: 60, color: AppColors.outline),
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

  Widget _buildStatItem(
    String value,
    String label,
    IconData icon,
    Color color,
    int index,
  ) {
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
          style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
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
              () => Navigator.pushNamed(context, '/events/reports'),
              3,
            ),
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
    int index,
  ) {
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

            return ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 280,
              ), // Fixed height constraint
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Event image
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
                    child:
                        event.coverImage != null && event.coverImage!.isNotEmpty
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

                  // Event details with flexible container
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(AppDimensions.paddingMd),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Upcoming badge
                          if (isUpcoming)
                            Container(
                              margin: const EdgeInsets.only(bottom: 8.0),
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
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                          // Event title
                          Text(
                            event.title,
                            style: AppTextStyles.titleSmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),

                          // Date and location in a more flexible layout
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
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
                                    Flexible(
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
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Bottom row with attendees and price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Attendees count
                              Flexible(
                                child: Container(
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
                              ),

                              const SizedBox(width: 8),

                              // Price
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        event.ticketPrice != null &&
                                            event.ticketPrice! > 0
                                        ? AppColors.primary.withOpacity(0.1)
                                        : AppColors.success.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    event.ticketPrice != null &&
                                            event.ticketPrice! > 0
                                        ? 'KSH ${event.ticketPrice!.toInt()}'
                                        : 'Free',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color:
                                          event.ticketPrice != null &&
                                              event.ticketPrice! > 0
                                          ? AppColors.primary
                                          : AppColors.success,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
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
        child: Icon(Icons.event, size: 40, color: AppColors.primary),
      ),
    );
  }

  Widget _buildAdditionalActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'More Actions',
          style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
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
            child: const Icon(Icons.add, color: Colors.white, size: 28),
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
        color: isSelected
            ? AppColors.primary.withOpacity(0.1)
            : Colors.transparent,
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
