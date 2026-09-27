import 'package:flutter/material.dart';
import 'package:oficios/data/mock_provider.dart';
import 'package:oficios/models/provider.dart';
import 'package:oficios/screens/provider_profile_screen.dart';
import 'package:oficios/widgets/filter_chip_button.dart';
import 'package:oficios/widgets/provider_card.dart';

class SearchResultsScreen extends StatefulWidget {
  final String initialQuery;

  const SearchResultsScreen({super.key, this.initialQuery = ''});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late final TextEditingController _searchController;

  bool _filterDestacados = true;
  bool _filterRating45 = false;
  bool _filterMenos5km = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Provider> get _filteredProviders {
    final query = _searchController.text.trim().toLowerCase();

    return mockProviders.where((provider) {
      final matchesQuery = query.isEmpty ||
          provider.name.toLowerCase().contains(query) ||
          provider.specialty.toLowerCase().contains(query);

      final matchesRating = !_filterRating45 || provider.rating >= 4.5;
      final matchesDistance = !_filterMenos5km || provider.distanceKm < 5;

      return matchesQuery && matchesRating && matchesDistance;
    }).toList()
      ..sort((a, b) {
        if (_filterDestacados) return b.rating.compareTo(a.rating);
        return 0;
      });
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredProviders;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Buscar oficio o prestador',
                          icon: Icon(Icons.search, color: Colors.grey.shade600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  FilterChipButton(
                    label: 'Destacados',
                    selected: _filterDestacados,
                    onTap: () => setState(() => _filterDestacados = !_filterDestacados),
                  ),
                  const SizedBox(width: 8),
                  FilterChipButton(
                    label: 'Rating 4.5+',
                    selected: _filterRating45,
                    onTap: () => setState(() => _filterRating45 = !_filterRating45),
                  ),
                  const SizedBox(width: 8),
                  FilterChipButton(
                    label: 'Menos de 5 km',
                    selected: _filterMenos5km,
                    onTap: () => setState(() => _filterMenos5km = !_filterMenos5km),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  results.isEmpty
                      ? 'No se encontraron prestadores'
                      : 'Se encontraron ${results.length} prestadores cerca',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Text('Probá con otra búsqueda', style: TextStyle(color: Colors.grey.shade500)),
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: results
                          .map(
                            (provider) => ProviderCard(
                              provider: provider,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProviderProfileScreen(provider: provider),
                                  ),
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}