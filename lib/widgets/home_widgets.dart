import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart'; // usa appImage(...) de tu helper

class SearchBarPill extends StatefulWidget {
  final VoidCallback onSubmit;
  final TextEditingController? controller;
  const SearchBarPill({super.key, required this.onSubmit, this.controller});

  @override
  State<SearchBarPill> createState() => _SearchBarPillState();
}

class _SearchBarPillState extends State<SearchBarPill> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Usar el controller externo si se proporciona, sino crear uno interno
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    // Solo dispose del controller si es interno (no fue pasado desde afuera)
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleSubmit() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      // Si hay un controller externo, delegar la navegación al parent
      if (widget.controller != null) {
        widget.onSubmit();
      } else {
        // Si es controller interno, navegar directamente
        Navigator.pushNamed(
          context,
          '/search',
          arguments: query,
        );
      }
    } else {
      widget.onSubmit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Buscar partes, talleres y productos',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (_) => _handleSubmit(),
              textInputAction: TextInputAction.search,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            onPressed: _handleSubmit,
            splashRadius: 18,
          ),
        ],
      ),
    );
  }
}

class EditableSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final ValueChanged<String>? onChanged;

  const EditableSearchBar({
    super.key,
    required this.controller,
    required this.onSubmit,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: (_) => onSubmit(),
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Buscar partes, talleres y productos',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
                isCollapsed: true,
              ),
            ),
          ),
          IconButton(
            splashRadius: 18,
            icon: controller.text.isEmpty
                ? const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey)
                : const Icon(Icons.close, size: 18, color: Colors.grey),
            onPressed: () {
              if (controller.text.isEmpty) {
                onSubmit();
              } else {
                controller.clear();
                onChanged?.call('');
              }
            },
          ),
        ],
      ),
    );
  }
}

class FilterChipPill extends StatelessWidget {
  final String label;
  const FilterChipPill(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const SectionHeader(this.title, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onTap,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.arrow_right_alt, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

class CarPromoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  const CarPromoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),

          // Subtítulo
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, height: 1.2),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Imagen (ocupa el resto)
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: appImage(
                image,
                fit: BoxFit.fitHeight,
                width: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PopularProductCard extends StatelessWidget {
  final Widget image;
  final String title;
  final String subtitle;
  final String price;
  final String? oldPrice;
  final String? badge;
  final VoidCallback? onTap;

  const PopularProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
    this.oldPrice,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 80,
                height: 80,
                child: FittedBox(fit: BoxFit.contain, child: image),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (badge != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  if (badge != null) const SizedBox(height: 8),
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(price, style: TextStyle(color: cs.primary, fontWeight: FontWeight.w900)),
                      if (oldPrice != null) ...[
                        const SizedBox(width: 10),
                        Text(
                          oldPrice!,
                          style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
