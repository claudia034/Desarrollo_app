import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/common_widgets.dart'; // appImage + formatCurrency
import 'product_detail_screen.dart';
import '../widgets/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Manejar navegación a search screen y limpiar al regresar
  void _navigateToSearch() async {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      await Navigator.pushNamed(
        context,
        '/search',
        arguments: query,
      );
    } else {
      await Navigator.pushNamed(context, '/search');
    }
    // Limpiar el texto cuando regrese de search screen
    setState(() {
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (i) => setState(() => _navIndex = i),
        indicatorColor: Colors.transparent,
        backgroundColor: Colors.white,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.handyman_outlined),
            selectedIcon: Icon(Icons.handyman),
            label: 'Talleres',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_offer_outlined),
            selectedIcon: Icon(Icons.local_offer),
            label: 'Ofertas',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Compras',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          AppSliverHeader(
            searchWidget: SearchBarPill(
              controller: _searchController,
              onSubmit: _navigateToSearch,
            ),
          ),

          // Chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: const [
                  FilterChipPill('Marca'),
                  FilterChipPill('Año'),
                  FilterChipPill('Modelo'),
                  FilterChipPill('Parte'),
                ],
              ),
            ),
          ),

          // "Partes para tu carro"
          const SliverToBoxAdapter(
            child: SectionHeader('Partes para tu carro'),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 160,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: carPartsForYou.length,
                itemBuilder: (_, i) {
                  final item = carPartsForYou[i];
                  return CarPromoCard(
                    title: item['title']!,
                    subtitle: item['subtitle']!,
                    image: item['image']!,
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
              ),
            ),
          ),

          // "Los más populares"
          const SliverToBoxAdapter(child: SectionHeader('Los más populares')),
          SliverList.builder(
            itemCount: popularProducts.length,
            itemBuilder: (context, idx) {
              final p = popularProducts[idx];
              
              // Calcular porcentaje de descuento dinámicamente
              String? calculateDiscountBadge() {
                if (p.oldPrice == null || p.oldPrice! <= p.price) return null;
                final discountPercentage = ((p.oldPrice! - p.price) / p.oldPrice! * 100).round();
                return '$discountPercentage% descuento';
              }
              
              return PopularProductCard(
                image: appImage(
                  p.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
                title: p.name,
                subtitle: p.vehicle,
                price: formatCurrency(p.price),
                oldPrice: p.oldPrice != null
                    ? formatCurrency(p.oldPrice!)
                    : null,
                badge: calculateDiscountBadge(),
                onTap: () => Navigator.pushNamed(
                  context,
                  ProductDetailScreen.routeName,
                  arguments: p,
                ),
              );
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
