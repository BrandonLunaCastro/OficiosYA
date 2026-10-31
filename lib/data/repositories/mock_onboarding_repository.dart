import 'package:oficios/data/mocks/onboarding_pages.dart';
import 'package:oficios/data/repositories/onboarding_repository.dart';
import 'package:oficios/models/onboarding_page_data.dart';

class MockOnboardingRepository implements OnboardingRepository {
  const MockOnboardingRepository();

  @override
  Future<List<OnboardingPageData>> getPages() async =>
      List.unmodifiable(onboardingPages);
}
