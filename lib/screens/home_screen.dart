import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/cart.dart';
import '../models/product.dart';
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
    final cs = Theme.of(context).colorScheme;

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
          SliverAppBar(
            pinned: true,
            expandedHeight: 230,
            backgroundColor: cs.primary,
            foregroundColor: Colors.white,
            title: const Text('Calle chiltiupan'),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {},
              ),
              Consumer<CartModel>(
                builder: (_, cart, __) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                        onPressed: () => Navigator.pushNamed(context, '/cart'),
                      ),
                      if (cart.totalCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${cart.totalCount}',
                              style: TextStyle(
                                color: cs.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Gradiente rojo (usa el primary del tema: #C8012C)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primary.withOpacity(0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // 2) Curva blanca inferior (se dibuja ANTES que la búsqueda)
                    Positioned(
                      bottom: -30,
                      left: -40,
                      right: -40,
                      child: Container(
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.elliptical(300, 60),
                          ),
                        ),
                      ),
                    ),
                  // Buscador tipo píldora
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: SearchBarPill(
                        controller: _searchController,
                        onSubmit: _navigateToSearch,
                      ),
                    ),
                  ),
                ],
              ),
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
