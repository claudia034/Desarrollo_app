import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/common_widgets.dart'; // usa appImage(...) de tu helper
import '../models/cart.dart';
import '../services/auth_service.dart';

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
          ],
        ),
      ),
    );
  }
}

// ===== Carrusel de Anuncios =====
class AdvertisementCarousel extends StatefulWidget {
  const AdvertisementCarousel({super.key});

  @override
  State<AdvertisementCarousel> createState() => _AdvertisementCarouselState();
}

class _AdvertisementCarouselState extends State<AdvertisementCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  // Datos de anuncios publicitarios
  final List<Map<String, dynamic>> _advertisements = [
    {
      'title': '50% OFF en Frenos',
      'subtitle': 'Promoción válida hasta fin de mes',
      'color': const Color(0xFF1565C0),
      'icon': Icons.car_repair,
      'onTap': () => print('Clicked: Brake Special'),
    },
    {
      'title': 'Cambio de Aceite Gratis',
      'subtitle': 'Con cualquier servicio mayor a \$100',
      'color': const Color(0xFF2E7D32),
      'icon': Icons.oil_barrel,
      'onTap': () => print('Clicked: Oil Change'),
    },
    {
      'title': 'Llantas Premium',
      'subtitle': '3x2 en todas las marcas',
      'color': const Color(0xFFD84315),
      'icon': Icons.tire_repair,
      'onTap': () => print('Clicked: Tire Sale'),
    },
    {
      'title': 'Seguro Vehicular',
      'subtitle': 'Cotiza y ahorra hasta 30%',
      'color': const Color(0xFF7B1FA2),
      'icon': Icons.security,
      'onTap': () => print('Clicked: Insurance'),
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < _advertisements.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: _advertisements.length,
        itemBuilder: (context, index) {
          final ad = _advertisements[index];
          return GestureDetector(
            onTap: ad['onTap'],
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    ad['color'].withOpacity(0.8),
                    ad['color'],
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Patrón de fondo
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _PatternPainter(color: Colors.white.withOpacity(0.1)),
                    ),
                  ),
                  // Contenido del anuncio
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                ad['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                ad['subtitle'],
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Ver más',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Icon(
                                ad['icon'],
                                size: 40,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Indicador de posición
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        _advertisements.length,
                        (dotIndex) => Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: dotIndex == _currentPage
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Painter para el patrón de fondo
class _PatternPainter extends CustomPainter {
  final Color color;
  
  _PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Dibujar líneas diagonales
    for (double i = -size.height; i < size.width + size.height; i += 20) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ===== Header Reutilizable =====
class AppSliverHeader extends StatelessWidget {
  final Widget searchWidget;
  final bool showBackButton;
  
  const AppSliverHeader({
    super.key,
    required this.searchWidget,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final user = authService.currentUser;
        final displayAddress = user?.address ?? 'Calle chiltiupán';
        
        return SliverAppBar(
          pinned: true,
          expandedHeight: 280,
          backgroundColor: cs.primary,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: showBackButton,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                displayAddress,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              if (user != null)
                Text(
                  user.status.label,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
            ],
          ),
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
                // Gradiente rojo
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        cs.primary,
                        cs.primary.withOpacity(0.85),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // Carrusel de anuncios publicitarios
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: const AdvertisementCarousel(),
                  ),
                ),
                // Curva blanca inferior
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
                // Widget de búsqueda
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 24,
                  child: searchWidget,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
