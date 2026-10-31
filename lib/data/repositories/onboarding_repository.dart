import 'package:oficios/models/onboarding_page_data.dart';

abstract interface class OnboardingRepository {
  Future<List<OnboardingPageData>> getPages();
}
