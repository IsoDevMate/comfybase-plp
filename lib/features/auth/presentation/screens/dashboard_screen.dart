import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_demsions.dart';
import '../providers/auth_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_animations.dart';
import 'package:kenyanvalley/features/events/presentation/screens/events_list_screen.dart';
import 'package:kenyanvalley/features/auth/presentation/screens/profile_screen.dart';

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

  Widget _buildQuickStats() {
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
                      '24',
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
                      'Attendees',
                      '1,234',
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
                      'This Month',
                      '8',
                      Icons.calendar_today,
                      AppColors.success,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: AppDimensions.spacingMd),
            Expanded(
              child: AnimatedBuilder(
                animation: _cardAnimations[3],
                builder: (context, child) {
                  return Transform.scale(
                    scale: _cardAnimations[3].value,
                    child: _buildStatCard(
                      'Revenue',
                      '\$12.5K',
                      Icons.attach_money,
                      AppColors.error,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

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
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Icon(icon, color: color, size: AppDimensions.iconMd),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
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
              onPressed: () {},
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
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: AppDimensions.marginMd),
                child: _buildEventCard(
                  'Tech Conference 2025',
                  'March 15, 2025',
                  '500 attendees',
                  'assets/images/event_placeholder.jpg',
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(
    String title,
    String date,
    String attendees,
    String image,
  ) {
    return Container(
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
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusLg),
                topRight: Radius.circular(AppDimensions.radiusLg),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.event,
                size: AppDimensions.iconLg,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.spacingSm),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: AppDimensions.iconSm,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppDimensions.spacingXs),
                    Text(
                      date,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingXs),
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: AppDimensions.iconSm,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppDimensions.spacingXs),
                    Text(
                      attendees,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
                // Handle create event
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
    return Center(
      child: Text('Settings Page', style: AppTextStyles.headlineMedium),
    );
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
