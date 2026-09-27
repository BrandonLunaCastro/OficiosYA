import 'package:flutter/material.dart';
import 'package:oficios/models/onboarding_page_data.dart';

const List<OnboardingPageData> onboardingPages = [
  OnboardingPageData(
    icon: Icons.search,
    title: 'Encontrá prestadores cerca tuyo',
    description:
        'Plomeros, electricistas, pintores y más, verificados y con opiniones reales de otros usuarios.',
  ),
  OnboardingPageData(
    icon: Icons.description_outlined,
    title: 'Pedí presupuestos en segundos',
    description: 'Escogé tu prestador y recibí el presupuesto, sin vueltas ni llamados.',
  ),
  OnboardingPageData(
    icon: Icons.star_outline,
    title: 'Contratá con confianza',
    description:
        'Calificá cada trabajo y ayudá a otros usuarios a elegir bien la próxima vez.',
  ),
];