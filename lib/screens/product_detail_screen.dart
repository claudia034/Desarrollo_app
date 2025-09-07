import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../widgets/common_widgets.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product';
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int qty = 1;
  static const String _imgBrake = 'assets/images/pads.png'; // Update with your actual asset path

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back, color: color.primary), onPressed: () => Navigator.pop(context)),
        title: const Text('Info de Producto'),
        backgroundColor: color.surface,
        actions: [
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
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(child: appImage(product.imageUrl, height: 180, fit: BoxFit.cover, radius: BorderRadius.circular(12))),
          const SizedBox(height: 16),
          Text(product.name, style: text.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: product.attributes.entries.map((e) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, border: Border.all(color: Theme.of(context).dividerColor), borderRadius: BorderRadius.circular(12)),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(e.key, style: text.labelSmall?.copyWith(color: Colors.grey[700])),
                const SizedBox(height: 2),
                Text(e.value, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              ]),
            );
          }).toList()),
          const SizedBox(height: 12),
          Row(children: [
            Text(formatCurrency(product.price), style: text.headlineSmall?.copyWith(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            const Icon(Icons.local_shipping, size: 18),
            const SizedBox(width: 4),
            Text('Entrega de ${product.deliveryEta}', style: text.bodyMedium),
          ]),
          const SizedBox(height: 24),
          Text('Productos que podrían interesarte', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Column(children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: appImage(product.imageUrl, width: 48, height: 48, fit: BoxFit.cover, radius: BorderRadius.circular(8)),
              title: Text(product.name),
              subtitle: const Text('Toyota Corolla 2015-2018'),
              trailing: Text(formatCurrency(product.price), style: TextStyle(color: color.primary, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: appImage(_imgBrake, width: 48, height: 48, fit: BoxFit.cover, radius: BorderRadius.circular(8)),
              title: const Text('Sistema de frenos'),
              subtitle: const Text('Toyota Corolla 2010-2013'),
              trailing: Text('\$84.99', style: TextStyle(color: color.primary, fontWeight: FontWeight.bold)),
            ),
          ]),
          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, border: Border(top: BorderSide(color: Theme.of(context).dividerColor))),
          child: Row(children: [
            _QtyPicker(qty: qty, onChanged: (q) => setState(() => qty = q)),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () {
                  context.read<CartModel>().add(product, qty: qty);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Añadido al carrito')),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Agregar al carrito'),
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _QtyPicker extends StatelessWidget {
  final int qty;
  final ValueChanged<int> onChanged;
  const _QtyPicker({required this.qty, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor), borderRadius: BorderRadius.circular(16)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(onPressed: () => onChanged(qty > 1 ? qty - 1 : 1), icon: const Icon(Icons.remove)),
        Text('$qty', style: Theme.of(context).textTheme.titleMedium),
        IconButton(onPressed: () => onChanged(qty + 1), icon: const Icon(Icons.add)),
      ]),
    );
  }
}
