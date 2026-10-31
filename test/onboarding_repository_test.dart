import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/repositories/mock_onboarding_repository.dart';

void main() {
  test('MockOnboardingRepository loads pages asynchronously', () async {
    const repository = MockOnboardingRepository();

    final pages = await repository.getPages();

    expect(pages, isNotEmpty);
    expect(pages.first.title, 'Encontrá prestadores cerca tuyo');
  });
}
