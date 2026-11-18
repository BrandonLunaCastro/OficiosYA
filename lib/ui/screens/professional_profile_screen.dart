import 'package:flutter/material.dart';
import 'package:oficios/data/repositories/professional_profile_repository.dart';
import 'package:oficios/data/repositories/provider_contact_repository.dart';
import 'package:oficios/data/repositories/provider_service_repository.dart';
import 'package:oficios/models/professional_profile.dart';
import 'package:oficios/models/provider_contact_info.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/ui/widgets/provider_bottom_nav.dart';

class ProfessionalProfileScreen extends StatefulWidget {
  const ProfessionalProfileScreen({
    super.key,
    required this.profileRepository,
    required this.serviceRepository,
    required this.contactRepository,
  });

  final ProfessionalProfileRepository profileRepository;
  final ProviderServiceRepository serviceRepository;
  final ProviderContactRepository contactRepository;

  static const _primaryColor = Color(0xFF2B66DF);
  static const _backgroundColor = Color(0xFFF4F6FA);

  @override
  State<ProfessionalProfileScreen> createState() =>
      _ProfessionalProfileScreenState();
}

class _ProfessionalProfileScreenState extends State<ProfessionalProfileScreen> {
  late Future<_ProfessionalProfileData> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfileData();
  }

  Future<_ProfessionalProfileData> _loadProfileData() async {
    final profile = await widget.profileRepository.getProfile();
    final services = await widget.serviceRepository.getServices();
    final contactInfo = await widget.contactRepository.getContactInfo();
    return _ProfessionalProfileData(profile, services.length, contactInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfessionalProfileScreen._backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 64,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              child: const Text(
                'Mi perfil',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: FutureBuilder<_ProfessionalProfileData>(
                future: _profileFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('No se pudo cargar tu perfil profesional.'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return _ProfileContent(
                    profile: snapshot.data!.profile,
                    serviceCount: snapshot.data!.serviceCount,
                    contactInfo: snapshot.data!.contactInfo,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ProviderBottomNav(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            _openServices();
          } else if (index == 2) {
            _openContact();
          } else if (index == 3) {
            Navigator.pushNamed(context, AppRoutes.providerReviews);
          }
        },
      ),
    );
  }

  Future<void> _openServices() async {
    await Navigator.pushNamed(context, AppRoutes.providerServices);
    if (!mounted) return;
    setState(() {
      _profileFuture = _loadProfileData();
    });
  }

  Future<void> _openContact() async {
    await Navigator.pushNamed(context, AppRoutes.providerContact);
    if (!mounted) return;
    setState(() {
      _profileFuture = _loadProfileData();
    });
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.profile,
    required this.serviceCount,
    required this.contactInfo,
  });

  final ProfessionalProfile profile;
  final int serviceCount;
  final ProviderContactInfo contactInfo;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProfileCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: ProfessionalProfileScreen._primaryColor,
                  child: Text(
                    profile.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.specialty,
                        style: const TextStyle(
                          color: ProfessionalProfileScreen._primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contactInfo.city,
                        style: TextStyle(
                          color: Colors.blueGrey.shade400,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _ProfileCard(
            child: Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFAA6C1D), size: 16),
                const SizedBox(width: 8),
                Text(
                  profile.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${profile.reviews} opiniones de clientes',
                  style: TextStyle(
                    color: Colors.blueGrey.shade400,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _ProfileCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sobre mí',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  profile.about,
                  style: TextStyle(
                    color: Colors.blueGrey.shade500,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _ProfileCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mis servicios',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Text(
                  '$serviceCount servicios publicados',
                  style: TextStyle(
                    color: Colors.blueGrey.shade400,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ubicación y contacto',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${contactInfo.city} · ${contactInfo.coverageZone}',
                  style: TextStyle(
                    color: Colors.blueGrey.shade400,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 42,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: ProfessionalProfileScreen._primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pushNamed(
                context,
                AppRoutes.editProfileProfessional,
              ),
              child: const Text(
                'Editar perfil profesional',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfessionalProfileData {
  const _ProfessionalProfileData(
    this.profile,
    this.serviceCount,
    this.contactInfo,
  );

  final ProfessionalProfile profile;
  final int serviceCount;
  final ProviderContactInfo contactInfo;
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: child,
    );
  }
}
