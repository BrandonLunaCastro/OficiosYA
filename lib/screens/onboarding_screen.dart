import 'package:flutter/material.dart';
import 'package:oficios/data/onboarding_pages.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/widgets/onboarding_page_content.dart';
import 'package:oficios/widgets/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2B66DF);
    final isLastPage = _currentPage == onboardingPages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: isLastPage
                    ? const SizedBox(height: 40) // mantiene el espacio, sin botón "Omitir"
                    : TextButton(
                        onPressed: _goToLogin,
                        child: const Text('Omitir', style: TextStyle(color: Colors.grey)),
                      ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingPages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => OnboardingPageContent(data: onboardingPages[index]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingPages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? primaryColor : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: isLastPage
                  ? PrimaryButton(text: 'Continuar', onPressed: _goToLogin)
                  : Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: const CircleBorder(),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}