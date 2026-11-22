import 'package:oficios/models/professional_profile.dart';
import 'package:oficios/data/mocks/mock_provider_reviews.dart';

final mockProfessionalProfile = ProfessionalProfile(
  id: 'prestador-plomeria-01',
  initials: 'CR',
  name: 'Carlos Rodriguez',
  specialty: 'Plomería y Gasista',
  location: 'Mendoza Capital',
  rating: 4.8,
  reviews: 45,
  about: 'Más de 10 años de experiencia en plomería y gas. Soluciones para filtraciones, instalaciones y urgencias del hogar.',
  publishedServices: 3,
  initialReviewSummary: mockProviderReviewSummary,
);
