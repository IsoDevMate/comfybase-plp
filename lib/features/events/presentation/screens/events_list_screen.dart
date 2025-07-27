// // features/events/presentation/pages/events_list_page.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/events_provider.dart';
// import '../widgets/event_card.dart';
// // import '../widgets/events_filter.dart';
// // import '../widgets/payment_modal.dart';
// // import '../../domain/entities/event.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/theme/app_text_styles.dart';
// import 'package:go_router/go_router.dart';

// class EventsListPage extends StatefulWidget {
//   const EventsListPage({super.key});

//   @override
//   State<EventsListPage> createState() => _EventsListPageState();
// }

// class _EventsListPageState extends State<EventsListPage> {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<EventsProvider>().fetchEvents();
//     });

//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         context.read<EventsProvider>().loadMoreEvents();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Events'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.event_available),
//             tooltip: 'My Registered Events',
//             onPressed: () {
//               context.go('/events/my');
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () {
//               Navigator.pushNamed(context, '/events/create');
//             },
//           ),
//         ],
//       ),
//       body: Consumer<EventsProvider>(
//         builder: (context, eventsProvider, child) {
//           return Column(
//             children: [
//               // Filters Section
//               // TODO: Implement EventsFilter widget
//               // const EventsFilter(),

//               // Events List
//               Expanded(child: _buildEventsList(eventsProvider)),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           context.go('/events/create');
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   Widget _buildEventsList(EventsProvider eventsProvider) {
//     if (eventsProvider.isLoading && eventsProvider.events.isEmpty) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (eventsProvider.error != null && eventsProvider.events.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline, size: 64, color: AppColors.error),
//             const SizedBox(height: 16),
//             Text(
//               'Error: ${eventsProvider.error}',
//               style: AppTextStyles.bodyLarge,
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 eventsProvider.fetchEvents();
//               },
//               child: const Text('Try Again'),
//             ),
//           ],
//         ),
//       );
//     }

//     if (eventsProvider.events.isEmpty) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.event_note, size: 64, color: AppColors.textSecondary),
//             SizedBox(height: 16),
//             Text('No events found', style: AppTextStyles.titleMedium),
//             SizedBox(height: 8),
//             Text(
//               'Try adjusting your filters or create a new event',
//               style: AppTextStyles.bodyMedium,
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: () async {
//         await eventsProvider.fetchEvents();
//       },
//       child: ListView.builder(
//         controller: _scrollController,
//         padding: const EdgeInsets.all(16),
//         itemCount:
//             eventsProvider.events.length +
//             (eventsProvider.isLoadingMore ? 1 : 0),
//         itemBuilder: (context, index) {
//           if (index == eventsProvider.events.length) {
//             return const Center(
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: CircularProgressIndicator(),
//               ),
//             );
//           }

//           final event = eventsProvider.events[index];
//           return EventCard(
//             event: event,
//             onTap: () {
//               Navigator.pushNamed(
//                 context,
//                 '/events/details',
//                 arguments: event.id,
//               );
//             },
//             // TODO: Implement onRegister and onDelete handlers
//             // onRegister: () {
//             //   _handleEventRegistration(event, eventsProvider);
//             // },
//             onEdit: () {
//               Navigator.pushNamed(context, '/events/edit', arguments: event.id);
//             },
//             // onDelete: () {
//             //   _showDeleteConfirmation(event, eventsProvider);
//             // },
//           );
//         },
//       ),
//     );
//   }

//   // TODO: Use correct EventModel type instead of Event, and implement payment modal if needed
//   void _handleEventRegistration(
//     /* Event event, */ EventsProvider eventsProvider,
//   ) {
//     // TODO: Implement event registration logic, including PaymentModal for paid events
//     // if (event.ticketPrice > 0) {
//     //   // Show payment modal for paid events
//     //   showDialog(
//     //     context: context,
//     //     builder: (context) => PaymentModal(
//     //       event: event,
//     //       onPaymentSubmit: (phoneNumber) {
//     //         eventsProvider.registerForPaidEvent(event.id, phoneNumber);
//     //         Navigator.pop(context);
//     //       },
//     //     ),
//     //   );
//     // } else {
//     //   // Direct registration for free events
//     //   eventsProvider.registerForFreeEvent(event.id);
//     // }
//   }

//   // TODO: Use correct EventModel type instead of Event
//   void _showDeleteConfirmation(
//     /* Event event, */ EventsProvider eventsProvider,
//   ) {
//     // TODO: Implement delete confirmation dialog
//     // showDialog(
//     //   context: context,
//     //   builder: (context) => AlertDialog(
//     //     title: const Text('Delete Event'),
//     //     content: Text('Are you sure you want to delete " event.title"?'),
//     //     actions: [
//     //       TextButton(
//     //         onPressed: () => Navigator.pop(context),
//     //         child: const Text('Cancel'),
//     //       ),
//     //       TextButton(
//     //         onPressed: () {
//     //           eventsProvider.deleteEvent(event.id);
//     //           Navigator.pop(context);
//     //         },
//     //         style: TextButton.styleFrom(foregroundColor: AppColors.error),
//     //         child: const Text('Delete'),
//     //       ),
//     //     ],
//     //   ),
//     // );
//   }
// }


// features/events/presentation/pages/events_list_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events_provider.dart';
import '../widgets/event_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/app_dimensions.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/rendering.dart'; // For ScrollDirection
import '../../../../core/theme/app_dimensions.dart';
import '../../data/models/event_model.dart';

class EventsListPage extends StatefulWidget {
  const EventsListPage({super.key});

  @override
  State<EventsListPage> createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fabAnimationController;
  late AnimationController _headerAnimationController;
  late Animation<double> _fabScaleAnimation;
  late Animation<Offset> _headerSlideAnimation;

  bool _isSearchActive = false;
  bool _showFab = true;
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filterOptions = [
    'All',
    'Today',
    'This Week',
    'Free',
    'Paid',
    'Virtual',
    'In-Person'
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fabAnimationController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );
    _headerAnimationController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );

    // Setup animations
    _fabScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: AppAnimations.easeInOut,
    ));

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: AppAnimations.fluidCurve,
    ));

    // Start header animation
    _headerAnimationController.forward();

    // Setup scroll listener
    _scrollController.addListener(_handleScroll);

    // Load events
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventsProvider>().fetchEvents();
    });
  }

  void _handleScroll() {
    // Handle pagination
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<EventsProvider>().loadMoreEvents();
    }

    // Handle FAB visibility
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_showFab) {
        setState(() => _showFab = false);
        _fabAnimationController.forward();
      }
    } else if (_scrollController.position.userScrollDirection ==
               ScrollDirection.forward) {
      if (!_showFab) {
        setState(() => _showFab = true);
        _fabAnimationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _fabAnimationController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildModernAppBar(),
      body: Consumer<EventsProvider>(
        builder: (context, eventsProvider, child) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Header with search and filters
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _headerSlideAnimation,
                  child: _buildHeaderSection(),
                ),
              ),

              // Quick stats
              SliverToBoxAdapter(
                child: _buildQuickStats(eventsProvider),
              ),

              // Events list
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
                sliver: _buildEventsSliverList(eventsProvider),
              ),

              // Loading indicator for pagination
              if (eventsProvider.isLoadingMore)
                const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.paddingLg),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      // Removed duplicate FAB since we have a plus button in the app bar
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
            ],
          ),
        ),
      ),
      title: AnimatedSwitcher(
        duration: AppAnimations.medium,
        child: _isSearchActive
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search events...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: AppTextStyles.titleMedium,
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                  // TODO: Implement search debouncing
                },
              )
            : const Text('Discover Events'),
      ),
      actions: [
        AnimatedRotation(
          turns: _isSearchActive ? 0.125 : 0,
          duration: AppAnimations.medium,
          child: IconButton(
            icon: Icon(_isSearchActive ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearchActive = !_isSearchActive;
                if (!_isSearchActive) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.person_outline),
          tooltip: 'My Events',
          onPressed: () => context.go('/events/my'),
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      margin: const EdgeInsets.only(top: kToolbarHeight + 20),
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome message with time-based greeting
          _buildWelcomeMessage(),

          const SizedBox(height: AppDimensions.spacingLg),

          // Filter chips
          _buildFilterChips(),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    final hour = DateTime.now().hour;
    String greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
            ? 'Good Afternoon'
            : 'Good Evening';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'What would you like to explore today?',
          style: AppTextStyles.displaySmall,
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.spacingSm),
        itemBuilder: (context, index) {
          final filter = _filterOptions[index];
          final isSelected = _selectedFilter == filter;

          return AnimatedContainer(
            duration: AppAnimations.fast,
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedFilter = filter);
                // TODO: Implement filter logic
              },
              backgroundColor: isSelected
                  ? AppColors.primary
                  : AppColors.surfaceLight,
              selectedColor: AppColors.primary,
              labelStyle: AppTextStyles.labelMedium.copyWith(
                color: isSelected
                    ? AppColors.surface
                    : AppColors.textPrimary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.outline,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickStats(EventsProvider eventsProvider) {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.marginMd),
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.outline.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          _buildStatItem(
            icon: Icons.event,
            label: 'Total Events',
            value: '${eventsProvider.events.length}',
          ),
          const Spacer(),
          _buildStatItem(
            icon: Icons.location_on,
            label: 'Near You',
            value: '12', // TODO: Calculate nearby events
          ),
          const Spacer(),
          _buildStatItem(
            icon: Icons.schedule,
            label: 'This Week',
            value: '8', // TODO: Calculate this week's events
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingSm),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: AppDimensions.iconMd,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXs),
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }

  // Filter events based on search query
  List<EventModel> _filterEvents(List<EventModel> events, String query) {
    if (query.isEmpty) return events;
    
    final queryLower = query.toLowerCase();
    return events.where((event) {
      return event.title.toLowerCase().contains(queryLower) ||
             event.description.toLowerCase().contains(queryLower) ||
             (event.location?.name?.toLowerCase().contains(queryLower) ?? false) ||
             (event.location?.city?.toLowerCase().contains(queryLower) ?? false);
    }).toList();
  }

  Widget _buildEventsSliverList(EventsProvider eventsProvider) {
    final filteredEvents = _filterEvents(eventsProvider.events, _searchQuery);
    
    if (eventsProvider.isLoading && eventsProvider.events.isEmpty) {
      return SliverFillRemaining(
        child: _buildLoadingState(),
      );
    }

    if (eventsProvider.error != null && eventsProvider.events.isEmpty) {
      return SliverFillRemaining(
        child: _buildErrorState(eventsProvider),
      );
    }

    if (filteredEvents.isEmpty) {
      return SliverFillRemaining(
        child: _searchQuery.isNotEmpty ? _buildNoSearchResults() : _buildEmptyState(),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final event = filteredEvents[index];

          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (index * 100)),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, animation, child) {
              return Transform.translate(
                offset: Offset(0, 50 * (1 - animation)),
                child: Opacity(
                  opacity: animation,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppDimensions.marginMd),
                    child: EventCard(
                      event: event,
                      onTap: () {
                        context.go('/events/details/${event.id}');
                      },
                      onEdit: () {
                        context.go('/events/edit/${event.id}');
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
        childCount: filteredEvents.length,
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TweenAnimationBuilder<double>(
          duration: const Duration(seconds: 2),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, animation, child) {
            return Transform.scale(
              scale: 0.5 + (animation * 0.5),
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primary.withOpacity(animation),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppDimensions.spacingLg),
        Text(
          'Loading amazing events...',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(EventsProvider eventsProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingLg),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: AppDimensions.iconXl,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Text(
              'Oops! Something went wrong',
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              'We couldn\'t load the events. Please check your connection and try again.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            ElevatedButton.icon(
              onPressed: () => eventsProvider.fetchEvents(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLg,
                  vertical: AppDimensions.paddingMd,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Text(
              'No events found',
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              'Try different search terms or check back later for new events',
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingLg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.secondary.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
              ),
              child: Icon(
                Icons.celebration_outlined,
                size: AppDimensions.iconXl,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Text(
              'No events yet',
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              'Be the first to create an amazing event in your community!',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            ElevatedButton.icon(
              onPressed: () => context.go('/events/create'),
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Create Event'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLg,
                  vertical: AppDimensions.paddingMd,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedFAB() {
    return ScaleTransition(
      scale: _fabScaleAnimation,
      child: FloatingActionButton.extended(
        onPressed: () => context.go('/events/create'),
        icon: const Icon(Icons.add),
        label: const Text('Create Event'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        elevation: 8,
        heroTag: 'create_event_fab',
      ),
    );
  }
}
