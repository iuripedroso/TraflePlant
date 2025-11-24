import 'package:flutter/material.dart';
import 'package:apkinvertexto/service/trefle_service.dart';
import 'package:apkinvertexto/view/family_plants_page.dart';

class BrowseFamiliesPage extends StatefulWidget {
  const BrowseFamiliesPage({super.key});

  @override
  State<BrowseFamiliesPage> createState() => _BrowseFamiliesPageState();
}

class _BrowseFamiliesPageState extends State<BrowseFamiliesPage> {
  final _apiService = TrefleService();
  Future<Map<String, dynamic>>? _familiesFuture;
  int _currentPage = 1;
  bool _canLoadMore = true;
  List<dynamic> _allFamilies = [];

  @override
  void initState() {
    super.initState();
    _loadFamilies();
  }

  void _loadFamilies() {
    if (!_canLoadMore) return;

    setState(() {
      _familiesFuture = _apiService.fetchFamilies(page: _currentPage);
    });

    _familiesFuture!
        .then((data) {
          final List<dynamic> newFamilies = data['data'] ?? [];
          final dynamic links = data['links'] ?? {};

          setState(() {
            _allFamilies.addAll(newFamilies);
            _canLoadMore = links['next'] != null;
            _currentPage++;
          });
        })
        .catchError((e) {
          if (_currentPage > 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Erro ao carregar mais famílias: ${e.toString()}',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
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
                  Icons.forest,
                  color: Colors.greenAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Famílias de Plantas',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Color.fromARGB(134, 105, 240, 175),
            ),
          ),
        ),
      ),

      backgroundColor: Colors.black,

      body: FutureBuilder<Map<String, dynamic>>(
        future: _familiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              _allFamilies.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            );
          } else if (snapshot.hasError && _allFamilies.isEmpty) {
            return Center(
              child: Text(
                'Erro: ${snapshot.error.toString()}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 12),
              itemCount: _allFamilies.length + (_canLoadMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _allFamilies.length) {
                  if (_canLoadMore) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _loadFamilies();
                    });

                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.greenAccent,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox(height: 40);
                  }
                }

                final family = _allFamilies[index] as Map<String, dynamic>;
                final familyName = family['name'] ?? 'Nome Desconhecido';
                final commonName = family['common_name'] ?? 'Sem Nome Comum';

                return Card(
                  color: Colors.grey.shade900,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: ListTile(
                    title: Text(
                      familyName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      commonName,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.greenAccent,
                      size: 16,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FamilyPlantsPage(familyName: familyName),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
