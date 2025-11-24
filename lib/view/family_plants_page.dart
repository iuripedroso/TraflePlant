import 'package:flutter/material.dart';
import 'package:apkinvertexto/service/trefle_service.dart';
import 'package:apkinvertexto/view/plant_details_page.dart';

class FamilyPlantsPage extends StatefulWidget {
  final String familyName;

  const FamilyPlantsPage({super.key, required this.familyName});

  @override
  State<FamilyPlantsPage> createState() => _FamilyPlantsPageState();
}

class _FamilyPlantsPageState extends State<FamilyPlantsPage> {
  final _apiService = TrefleService();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  List<dynamic> _allPlants = [];
  bool _canLoadMore = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPlants();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_canLoadMore && !_isLoading) {
        _loadPlants();
      }
    }
  }

  Future<void> _loadPlants() async {
    if (!_canLoadMore || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final data = await _apiService.fetchPlantsByFamily(
        widget.familyName,
        page: _currentPage,
      );

      final List<dynamic> newPlants = data['data'] ?? [];
      final dynamic links = data['links'] ?? {};

      setState(() {
        _allPlants.addAll(newPlants);
        _canLoadMore = links['next'] != null;
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar mais plantas: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D0D0D), Color(0xFF1A1A1A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.eco,
                  color: Colors.greenAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Plantas: ${widget.familyName}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Color.fromARGB(174, 105, 240, 175),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: _allPlants.isEmpty && _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            )
          : _allPlants.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhuma planta encontrada nesta família.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: _allPlants.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _allPlants.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.greenAccent,
                          ),
                        ),
                      );
                    }

                    final plant = _allPlants[index] as Map<String, dynamic>;
                    final commonName = plant['common_name'] ?? 'Sem Nome Comum';
                    final scientificName = plant['scientific_name'] ??
                        'Nome Científico Desconhecido';

                    return Card(
                      color: Colors.grey.shade900,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      child: ListTile(
                        leading: plant['image_url'] != null
                            ? Image.network(
                                plant['image_url'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.grass,
                                        color: Colors.greenAccent, size: 30),
                              )
                            : const Icon(Icons.grass,
                                color: Colors.greenAccent, size: 30),
                        title: Text(
                          commonName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Científico: $scientificName',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlantDetailsPage(
                                plantId: plant['id'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}