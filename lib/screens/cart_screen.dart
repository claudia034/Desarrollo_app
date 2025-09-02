import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../widgets/common_widgets.dart';

/// Pantalla de carrito conectada a Provider.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  double get deliveryFee => 3.00;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Tu carrito'), centerTitle: false),
      body: Consumer<CartModel>(builder: (context, cart, _) {
        if (cart.items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('Tu carrito está vacío'),
                  const SizedBox(height: 8),
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Explorar productos')),
                ],
              ),
            ),
          );
        }

        final subtotal = cart.subtotal;
        final total = subtotal + deliveryFee;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Card(
              child: Column(
                children: cart.items.values.map((it) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(it.p.imageUrl, width: 56, height: 56, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(it.p.name, style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text(it.p.vehicle, style: tt.bodySmall?.copyWith(color: Colors.grey[600])),
                              const SizedBox(height: 8),
                              Text(formatCurrency(it.p.price), style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        _QtyStepper(
                          qty: it.qty,
                          onChanged: (q) => cart.setQty(it.p, q),
                          onRemove: () => cart.setQty(it.p, 0),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Row(children: [const Icon(Icons.access_time, size: 18), const SizedBox(width: 8), Text('Entrega estimada en 1–2 horas', style: tt.bodyMedium)]),
            const SizedBox(height: 12),
            _Card(
              child: Column(
                children: [
                  _line('Tarifa de envío', formatCurrency(deliveryFee), context),
                  _line('Subtotal', formatCurrency(subtotal), context),
                  _line('Envío', formatCurrency(deliveryFee), context),
                  const Divider(height: 16),
                  _line('Total', formatCurrency(total), context, isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text('Los impuestos se calcularán al finalizar la compra.', style: tt.bodySmall?.copyWith(color: Colors.grey[700])),
            const SizedBox(height: 16),
          ],
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/tracking'),
              icon: const Icon(Icons.lock_outline),
              label: const Text('Continuar con la compra'),
              style: FilledButton.styleFrom(shape: const StadiumBorder(), textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _line(String label, String value, BuildContext context, {bool isBold = false}) {
    final style = isBold ? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800) : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: style), Text(value, style: style)]),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({required this.qty, required this.onChanged, required this.onRemove});

  final int qty;
  final ValueChanged<int> onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor), borderRadius: BorderRadius.circular(12)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(visualDensity: VisualDensity.compact, icon: const Icon(Icons.remove), onPressed: qty > 1 ? () => onChanged(qty - 1) : onRemove),
        Text('$qty', style: Theme.of(context).textTheme.titleMedium),
        IconButton(visualDensity: VisualDensity.compact, icon: const Icon(Icons.add), onPressed: () => onChanged(qty + 1)),
      ]),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).dividerColor), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0,2))]),
      child: child,
    );
  }
}
