import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../widgets/common_widgets.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (i) => setState(() => _navIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.handyman_outlined), selectedIcon: Icon(Icons.handyman), label: 'Talleres'),
          NavigationDestination(icon: Icon(Icons.local_offer_outlined), selectedIcon: Icon(Icons.local_offer), label: 'Ofertas'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Compras'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            backgroundColor: color.primary,
            leading: IconButton(icon: const Icon(Icons.location_on_outlined), onPressed: () {}, tooltip: 'Ubicación'),
            title: const Text('Calle chiltiupan'),
            actions: [
              IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
              Consumer<CartModel>(builder: (_, cart, __) {
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () => Navigator.pushNamed(context, '/cart')),
                    if (cart.totalCount > 0)
                      Positioned(
                        right: 8, top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                          child: Text('${cart.totalCount}', style: TextStyle(color: color.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                );
              }),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [color.primary, color.primary.withOpacity(0.75)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: _SearchPill(onTap: () => Navigator.pushNamed(context, '/search')),
                    ),
                  ),
                  Positioned(bottom: -30, left: -40, right: -40, child: Container(height: 80, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.elliptical(300, 60))),)),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                scrollDirection: Axis.horizontal,
                children: ['Marca','Año','Modelo','Parte'].map((t) => _chip(t)).toList(),
              ),
            ),
          ),
          _sectionHeader('Partes para tu carro'),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 160,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: carPartsForYou.length,
                itemBuilder: (_, i) {
                  final item = carPartsForYou[i];
                  return _carCard(item['title']!, item['subtitle']!, item['image']!);
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
              ),
            ),
          ),
          _sectionHeader('Los más populares'),
          SliverList.builder(
            itemCount: popularProducts.length,
            itemBuilder: (context, idx) {
              final p = popularProducts[idx];
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: ProductListTile(
                  product: p,
                  badgeText: p.oldPrice != null ? '15% descuento' : null,
                  onTap: () => Navigator.pushNamed(context, ProductDetailScreen.routeName, arguments: p),
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _chip(String label) => Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: FilterChip(label: Text(label), selected: false, onSelected: (_) {}),
  );

  SliverToBoxAdapter _sectionHeader(String title) => SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)), TextButton(onPressed: (){}, child: const Text('→'))]),
    ),
  );

  Widget _carCard(String title, String subtitle, String image) {
    return Container(
      width: 220,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).dividerColor)),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(image, width: 72, height: 72, fit: BoxFit.cover)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 6), Text(subtitle, style: const TextStyle(color: Colors.grey)),],)),
        ],
      ),
    );
  }
}

class _SearchPill extends StatelessWidget {
  final VoidCallback onTap;
  const _SearchPill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 48,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: const Row(children: [Icon(Icons.search, color: Colors.grey), SizedBox(width: 8), Text('Buscar partes, talleres y productos', style: TextStyle(color: Colors.grey)),]),
      ),
    );
  }
}
