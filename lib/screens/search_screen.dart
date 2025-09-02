import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../widgets/common_widgets.dart';
import 'product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final queryCtrl = TextEditingController(text: 'Pastillas de freno');
  final List<String> filters = ['Toyota', '2015', 'Corolla', 'Distribuidor'];

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final List<Product> results = popularProducts;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            backgroundColor: color.primary,
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
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [color.primary, color.primary.withOpacity(0.75)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                          child: Row(children: [
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 6),
                            Expanded(child: TextField(controller: queryCtrl, decoration: const InputDecoration(hintText: 'Pastillas de freno', border: InputBorder.none))),
                            IconButton(onPressed: () => setState(() {}), icon: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey)),
                          ]),
                        ),
                      ),
                    ),
                  ),
                  Positioned(bottom: -30, left: -40, right: -40, child: Container(height: 80, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.elliptical(300, 60))),)),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                scrollDirection: Axis.horizontal,
                children: [
                  ...filters.map((f) => Padding(padding: const EdgeInsets.only(right: 8.0), child: FilterChip(label: Text(f), selected: true, onSelected: (_){}) )),
                  TextButton(onPressed: (){}, child: const Text('Limpiar filtros')),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(children: [Text('Repuestos disponibles', style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold)), const Spacer(), TextButton.icon(onPressed: (){}, icon: const Icon(Icons.sort), label: const Text('Precio más bajo'))]),
            ),
          ),
          SliverList.builder(
            itemCount: results.length,
            itemBuilder: (_, i) {
              final p = results[i];
              final badge = i == 0 ? '-15%' : (i == 1 ? 'Envío gratis' : null);
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: ProductListTile(product: p, badgeText: badge, onTap: () => Navigator.pushNamed(context, ProductDetailScreen.routeName, arguments: p)),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
