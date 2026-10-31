import 'package:flutter/material.dart';
import 'package:oficios/data/repositories/provider_repository.dart';
import 'package:oficios/models/provider.dart';
import 'package:oficios/ui/screens/provider_profile_screen.dart';
import 'package:oficios/ui/widgets/filter_chip_button.dart';
import 'package:oficios/ui/widgets/provider_card.dart';

class SearchResultsScreen extends StatefulWidget {
  final String initialQuery;
  final ProviderRepository providerRepository;

  const SearchResultsScreen({
    super.key,
    this.initialQuery = '',
    required this.providerRepository,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late final TextEditingController _searchController;

  bool _filterDestacados = true;
  bool _filterRating45 = false;
  bool _filterMenos5km = false;
  late Future<List<Provider>> _resultsFuture;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _resultsFuture = _loadProviders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Provider>> _loadProviders() {
    return widget.providerRepository.searchProviders(
      query: _searchController.text.trim(),
      ratingMin: _filterRating45 ? 4.5 : null,
      maxDistanceKm: _filterMenos5km ? 5 : null,
    );
  }

  void _refreshResults() {
    setState(() {
      _resultsFuture = _loadProviders();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        onChanged: (_) => _refreshResults(),
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
                    onTap: () => setState(() {
                      _filterDestacados = !_filterDestacados;
                      _resultsFuture = _loadProviders();
                    }),
                  ),
                  const SizedBox(width: 8),
                  FilterChipButton(
                    label: 'Rating 4.5+',
                    selected: _filterRating45,
                    onTap: () => setState(() {
                      _filterRating45 = !_filterRating45;
                      _resultsFuture = _loadProviders();
                    }),
                  ),
                  const SizedBox(width: 8),
                  FilterChipButton(
                    label: 'Menos de 5 km',
                    selected: _filterMenos5km,
                    onTap: () => setState(() {
                      _filterMenos5km = !_filterMenos5km;
                      _resultsFuture = _loadProviders();
                    }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Provider>>(
                future: _resultsFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('No se pudieron cargar los prestadores.'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final results = List<Provider>.of(snapshot.data!);
                  if (_filterDestacados) {
                    results.sort((a, b) => b.rating.compareTo(a.rating));
                  }
                  return Column(
                    children: [
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            results.isEmpty
                                ? 'No se encontraron prestadores'
                                : 'Se encontraron ${results.length} prestadores cerca',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: results.isEmpty
                            ? Center(
                                child: Text(
                                  'Probá con otra búsqueda',
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                              )
                            : ListView(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                children: results
                                    .map(
                                      (provider) => ProviderCard(
                                        provider: provider,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProviderProfileScreen(
                                                    provider: provider,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
