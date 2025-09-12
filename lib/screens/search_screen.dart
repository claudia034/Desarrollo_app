import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/product.dart';
import '../widgets/common_widgets.dart';   // appImage, formatCurrency
import '../widgets/home_widgets.dart';     // EditableSearchBar, AppSliverHeader
import 'product_detail_screen.dart';

enum SortOption {
  priceAsc('Precio más bajo'),
  priceDesc('Precio más alto'),
  discount('Mayor descuento'),
  delivery('Entrega más rápida');

  const SortOption(this.label);
  final String label;
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final queryCtrl = TextEditingController(text: '');

  // ===== Estado de filtros dinámicos =====
  String? brand;      // ej. "Toyota"
  int? year;          // ej. 2015
  String? model;      // ej. "Corolla"
  bool distributorOnly = false;

  // ===== Estado de ordenamiento =====
  SortOption sortBy = SortOption.priceAsc;

  // ===== Control de carga inicial =====
  bool _hasLoadedInitialQuery = false;

  // --- util: parsear vehicle "Toyota Corolla 2015-2018"
  String _brandOf(Product p) => p.vehicle.split(' ').first;
  String _modelOf(Product p) => p.vehicle.split(' ').length >= 2 ? p.vehicle.split(' ')[1] : '';
  bool _matchYear(Product p, int y) {
    final parts = p.vehicle.split(' ');
    if (parts.isEmpty) return false;
    final token = parts.last;               // "2015-2018" o "2016"
    final dash = token.indexOf('-');
    if (dash != -1) {
      final a = int.tryParse(token.substring(0, dash));
      final b = int.tryParse(token.substring(dash + 1));
      if (a == null || b == null) return false;
      return y >= a && y <= b;
    } else {
      final v = int.tryParse(token);
      return v != null && v == y;
    }
  }

  // conjuntos dinámicos (en base a resultados actuales por query)
  Set<String> get _allBrands {
    final q = queryCtrl.text.toLowerCase().trim();
    return popularProducts.where((p) {
      if (q.isEmpty) return true;
      return p.name.toLowerCase().contains(q) ||
          p.vehicle.toLowerCase().contains(q) ||
          p.vendor.toLowerCase().contains(q);
    }).map(_brandOf).toSet();
  }

  Set<int> get _allYears {
    final years = <int>{};
    for (final p in popularProducts) {
      final token = p.vehicle.split(' ').last;
      if (token.contains('-')) {
        final a = int.tryParse(token.split('-')[0]);
        final b = int.tryParse(token.split('-')[1]);
        if (a != null && b != null) {
          for (var y = a; y <= b; y++) years.add(y);
        }
      } else {
        final y = int.tryParse(token);
        if (y != null) years.add(y);
      }
    }
    return years;
  }

  Set<String> get _allModels {
    return popularProducts.map(_modelOf).where((s) => s.isNotEmpty).toSet();
  }

    // ===== Filtrado real (query + filtros) =====
  List<Product> _filtered() {
    final q = queryCtrl.text.toLowerCase().trim();

    bool vendorIsDistributor(String v) {
      // heurística simple para "distribuidor" en nuestros mocks
      const hints = ['autozone', 'autofix', 'repuestos', 'brake'];
      final low = v.toLowerCase();
      return hints.any((h) => low.contains(h));
    }

    // Calcular días de entrega para ordenamiento
    int deliveryDays(String eta) {
      if (eta.contains('1-2')) return 1;
      if (eta.contains('2-3')) return 2;
      if (eta.contains('3-5')) return 3;
      if (eta.contains('5-7')) return 5;
      return 7; // default
    }

    // Calcular porcentaje de descuento
    double discountPercentage(Product p) {
      if (p.oldPrice == null || p.oldPrice! <= p.price) return 0.0;
      return ((p.oldPrice! - p.price) / p.oldPrice!) * 100;
    }

    var filtered = popularProducts.where((p) {
      // query
      final okQuery = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.vehicle.toLowerCase().contains(q) ||
          p.vendor.toLowerCase().contains(q);

      // filtros dinámicos
      final okBrand = brand == null || _brandOf(p) == brand;
      final okModel = model == null || _modelOf(p) == model;
      final okYear = year == null || _matchYear(p, year!);
      final okDistrib = !distributorOnly || vendorIsDistributor(p.vendor);

      return okQuery && okBrand && okModel && okYear && okDistrib;
    }).toList();

    // Aplicar ordenamiento
    switch (sortBy) {
      case SortOption.priceAsc:
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceDesc:
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.discount:
        filtered.sort((a, b) => discountPercentage(b).compareTo(discountPercentage(a)));
        break;
      case SortOption.delivery:
        filtered.sort((a, b) => deliveryDays(a.deliveryEta).compareTo(deliveryDays(b.deliveryEta)));
        break;
    }

    return filtered;
  }

  // ===== UI =====
  @override
  void initState() {
    super.initState();
    // Recibir el query desde los argumentos de navegación se maneja en didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Solo cargar el query inicial una vez
    if (!_hasLoadedInitialQuery) {
      final String? searchQuery = ModalRoute.of(context)?.settings.arguments as String?;
      if (searchQuery != null && searchQuery.isNotEmpty) {
        setState(() {
          queryCtrl.text = searchQuery;
          _hasLoadedInitialQuery = true;
        });
      } else {
        _hasLoadedInitialQuery = true;
      }
    }
  }

  void _showSortModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ordenar por',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...SortOption.values.map((option) {
                final isSelected = sortBy == option;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    option.label,
                    style: TextStyle(
                      color: isSelected ? Theme.of(context).colorScheme.primary : null,
                      fontWeight: isSelected ? FontWeight.w600 : null,
                    ),
                  ),
                  trailing: isSelected 
                    ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                    : null,
                  onTap: () {
                    setState(() {
                      sortBy = option;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    queryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final results = _filtered();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          AppSliverHeader(
            showBackButton: true,
            searchWidget: StatefulBuilder(
              builder: (context, setSB) {
                return EditableSearchBar(
                  controller: queryCtrl,
                  onSubmit: () => setState(() {}),
                  onChanged: (_) {
                    setState(() {}); // Actualizar resultados en tiempo real
                    setSB(() {}); // refresca icono clear/arrow
                  },
                );
              },
            ),
          ),

          // ===== FILTROS DINÁMICOS (igual look del mock) =====
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: [
                  _ChoicePill(
                    label: brand ?? 'Marca',
                    selected: brand != null,
                    onTap: () => _pickFromSheet<String>(
                      title: 'Marca',
                      values: _allBrands.toList()..sort(),
                      current: brand,
                      itemLabel: (s) => s,
                      onSelected: (s) => setState(() => brand = s),
                      onClear: () => setState(() => brand = null),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _ChoicePill(
                    label: year?.toString() ?? 'Año',
                    selected: year != null,
                    onTap: () => _pickFromSheet<int>(
                      title: 'Año',
                      values: _allYears.toList()..sort(),
                      current: year,
                      itemLabel: (y) => y.toString(),
                      onSelected: (y) => setState(() => year = y),
                      onClear: () => setState(() => year = null),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _ChoicePill(
                    label: model ?? 'Modelo',
                    selected: model != null,
                    onTap: () => _pickFromSheet<String>(
                      title: 'Modelo',
                      values: _allModels.toList()..sort(),
                      current: model,
                      itemLabel: (s) => s,
                      onSelected: (s) => setState(() => model = s),
                      onClear: () => setState(() => model = null),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _TogglePill(
                    label: 'Distribuidor',
                    selected: distributorOnly,
                    onTap: () => setState(() => distributorOnly = !distributorOnly),
                  ),
                ],
              ),
            ),
          ),

          // ===== TÍTULO + ORDEN =====
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Repuestos disponibles',
                        style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                  ),
                  Flexible(
                    child: TextButton(
                      onPressed: () => _showSortModal(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(sortBy.label,
                                style: TextStyle(color: cs.primary, fontWeight: FontWeight.w700),
                                overflow: TextOverflow.ellipsis),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down, size: 18, color: cs.primary),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ===== LIMPIAR =====
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => setState(() {
                    brand = null;
                    year = null;
                    model = null;
                    distributorOnly = false;
                    queryCtrl.clear();
                  }),
                  child: const Text('Limpiar filtros'),
                ),
              ),
            ),
          ),

          // ===== RESULTADOS =====
          SliverList.builder(
            itemCount: results.length,
            itemBuilder: (_, i) {
              final p = results[i];
              
              // Calcular badge dinámicamente
              String? calculateBadge() {
                // Primero verificar si hay descuento
                if (p.oldPrice != null && p.oldPrice! > p.price) {
                  final discountPercentage = ((p.oldPrice! - p.price) / p.oldPrice! * 100).round();
                  return '-$discountPercentage%';
                }
                // Si no hay descuento, mostrar envío gratis ocasionalmente (puedes ajustar esta lógica)
                if (i == 2) return 'Envío gratis';
                return null;
              }
              
              return _SearchResultCard(
                product: p,
                badge: calculateBadge(),
                deliveryText: p.deliveryEta,
                vendor: p.vendor,
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

  // ====== Helper: bottom-sheet de opciones =======
  Future<void> _pickFromSheet<T>({
    required String title,
    required List<T> values,
    required T? current,
    required String Function(T) itemLabel,
    required ValueChanged<T> onSelected,
    required VoidCallback onClear,
  }) async {
    final cs = Theme.of(context).colorScheme;
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Row(
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        onClear();
                        Navigator.pop(ctx);
                      },
                      child: const Text('Quitar'),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: values.length,
                  itemBuilder: (_, i) {
                    final v = values[i];
                    final sel = current != null && v == current;
                    return ListTile(
                      title: Text(itemLabel(v), style: TextStyle(fontWeight: sel ? FontWeight.w700 : FontWeight.w400)),
                      trailing: sel ? Icon(Icons.check, color: cs.primary) : null,
                      onTap: () {
                        onSelected(v);
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Chips estilo pill ────────────────────────────────────────────────

class _ChoicePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ChoicePill({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? cs.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: cs.primary, width: 1.5),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(color: selected ? Colors.white : cs.primary, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 4),
            Icon(selected ? Icons.close : Icons.keyboard_arrow_down,
                size: 16, color: selected ? Colors.white : cs.primary),
          ],
        ),
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TogglePill({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? cs.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: cs.primary, width: 1.5),
        ),
        child: Text(label, style: TextStyle(color: selected ? Colors.white : cs.primary, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

// ─── Card de resultado (igual al mock 2) ─────────────────────────────

class _SearchResultCard extends StatelessWidget {
  final Product product;
  final String? badge;
  final String deliveryText;
  final String vendor;
  final VoidCallback? onTap;

  const _SearchResultCard({
    required this.product,
    required this.badge,
    required this.deliveryText,
    required this.vendor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 6, 16, 12),
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
            // Imagen
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 84,
                height: 84,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: appImage(product.imageUrl, width: 84, height: 84),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: cs.primary),
                      ),
                      child: Text(badge!, style: TextStyle(color: cs.primary, fontWeight: FontWeight.w800)),
                    ),
                  if (badge != null) const SizedBox(height: 8),
                  Text(product.name, style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(product.vehicle, style: tt.bodySmall?.copyWith(color: Colors.grey[700])),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(deliveryText, style: tt.bodySmall?.copyWith(color: Colors.black87)),
                  ]),
                  const SizedBox(height: 2),
                  Text(vendor, style: tt.bodySmall?.copyWith(color: Colors.black54)),
                ],
              ),
            ),

            // Precio + flecha
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (product.oldPrice != null)
                  Text(formatCurrency(product.oldPrice!), style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough)),
                Text(formatCurrency(product.price), style: TextStyle(color: cs.primary, fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                const Icon(Icons.chevron_right, color: Colors.black54),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
