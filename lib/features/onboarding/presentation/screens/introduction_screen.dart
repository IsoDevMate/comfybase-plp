import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:kenyanvalley/core/constants/app_colors.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageDecoration = PageDecoration(
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
      bodyTextStyle: GoogleFonts.poppins(
        fontSize: 16.0,
        color: Colors.grey[700],
      ),
      descriptionPadding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: const EdgeInsets.only(top: 40.0),
    );

    List<PageViewModel> getPages() {
      return [
        PageViewModel(
          title: "Welcome to Kenyan Valley",
          body:
              "Discover amazing features and services tailored just for you. Let's get started!",
          image: Center(
            child: Image.asset(
              'assets/images/onboarding1.png', // Replace with your image
              height: 250,
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Stay Connected",
          body:
              "Never miss an update. Connect with your community and stay informed about events and announcements.",
          image: Center(
            child: Image.asset(
              'assets/images/onboarding2.png', // Replace with your image
              height: 250,
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Get Started",
          body:
              "You're all set! Start exploring Kenyan Valley and make the most of your experience.",
          image: Center(
            child: Image.asset(
              'assets/images/onboarding3.png', // Replace with your image
              height: 250,
            ),
          ),
          decoration: pageDecoration,
        ),
      ];
    }

    final introKey = GlobalKey<IntroductionScreenState>();

    void _onIntroEnd(context) {
      // Navigate to the main app or login screen
      // You might want to set a shared preference here to not show intro again
      context.go('/login'); // Adjust the route as per your app's routing
    }

    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          key: introKey,
          pages: getPages(),
          onDone: () => _onIntroEnd(context),
          showSkipButton: true,
          skip: Text(
            'Skip',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          next: const Icon(Icons.arrow_forward, color: AppColors.primaryColor),
          done: Text(
            'Done',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: AppColors.primaryColor,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          controlsPadding: const EdgeInsets.all(16.0),
        ),
      ),
    );
  }
}

// Helper extension for navigation
extension GoRouterExtension on BuildContext {
  void go(String location) => GoRouter.of(this).go(location);
}
