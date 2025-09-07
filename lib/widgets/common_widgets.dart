import 'package:flutter/material.dart';
import '../models/product.dart';

Widget appImage(
  String path, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  BorderRadius? radius,
}) {
  final isNetwork = path.startsWith('http');
  final img = isNetwork
      ? Image.network(path, width: width, height: height, fit: fit)
      : Image.asset(path, width: width, height: height, fit: fit);
  if (radius != null) return ClipRRect(borderRadius: radius, child: img);
  return img;
}

Widget ratingStars(double rating) {
  final full = rating.floor();
  final half = (rating - full) >= 0.5;
  final color = Colors.amber;
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(5, (i) {
      if (i < full) return Icon(Icons.star, size: 16, color: color);
      if (i == full && half) return Icon(Icons.star_half, size: 16, color: color);
      return Icon(Icons.star_border, size: 16, color: color);
    }),
  );
}

String formatCurrency(num n) => '\$${n.toStringAsFixed(2)}';

class DiscountBadge extends StatelessWidget {
  final String text;
  const DiscountBadge(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(color: color.primary, fontWeight: FontWeight.w700)),
    );
  }
}

class ProductListTile extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final String? badgeText; // e.g., "-15%" o "Envío gratis"

  const ProductListTile({super.key, required this.product, this.onTap, this.badgeText});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appImage(
              product.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              radius: BorderRadius.circular(12),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (badgeText != null) ...[
                    DiscountBadge(badgeText!),
                    const SizedBox(height: 8),
                  ],
                  Text(product.name, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(product.vehicle, style: text.bodySmall?.copyWith(color: Colors.grey[600])),
                  const SizedBox(height: 6),
                  Row(children: [ratingStars(product.rating), const SizedBox(width: 6), Text(product.rating.toStringAsFixed(1), style: text.bodySmall)]),
                  const SizedBox(height: 6),
                  Row(children: [
                    Text(formatCurrency(product.price), style: text.titleMedium?.copyWith(color: color.primary, fontWeight: FontWeight.bold)),
                    if (product.oldPrice != null) ...[
                      const SizedBox(width: 8),
                      Text(formatCurrency(product.oldPrice!), style: text.bodySmall?.copyWith(color: Colors.grey, decoration: TextDecoration.lineThrough)),
                    ],
                  ]),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
