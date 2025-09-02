import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Estado del pedido')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 220,
              color: Colors.grey[200],
              child: CustomPaint(
                painter: _RoutePainter(cs.primary),
                child: Stack(
                  children: const [
                    Positioned(left: 20, top: 20, child: _MapBadge(text: '16 min')),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).dividerColor)),
            child: Row(
              children: [
                const CircleAvatar(radius: 24, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12')),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Carlos M.', style: TextStyle(fontWeight: FontWeight.w700)),
                  Text('Toyota Hilux — Gris', style: tt.bodySmall?.copyWith(color: Colors.grey[700])),
                  const SizedBox(height: 2),
                  Text('Llegando en 15–20 min', style: tt.bodySmall),
                ])),
                OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline), label: const Text('Chatear')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ExpansionTile(title: const Text('Detalles del pedido'), childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12), children: const [
            _Line(label: 'No. Pedido', value: '#KG-102938'),
            _Line(label: 'Método de pago', value: 'Tarjeta terminada 4242'),
            _Line(label: 'Dirección', value: 'Av. Principal #123, San Salvador'),
            _Line(label: 'Total', value: '\$122.00'),
          ]),
          const SizedBox(height: 8),
          ExpansionTile(title: const Text('¿Necesitas ayuda?'), childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12), children: [
            ListTile(leading: const Icon(Icons.support_agent_outlined), title: const Text('Contactar soporte'), onTap: () {}),
            ListTile(leading: const Icon(Icons.report_gmailerrorred_outlined), title: const Text('Reportar un problema'), onTap: () {}),
          ]),
          const SizedBox(height: 16),
          SizedBox(height: 48, child: FilledButton(onPressed: () => Navigator.pushNamed(context, '/rate'), child: const Text('Pedido recibido, calificar'))),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final String label; final String value;
  const _Line({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label), Text(value)]),
    );
  }
}

class _MapBadge extends StatelessWidget {
  final String text; const _MapBadge({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)]),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

class _RoutePainter extends CustomPainter {
  final Color routeColor;
  _RoutePainter(this.routeColor);

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    final road = Paint()..color = Colors.grey.shade300..strokeWidth = 6..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(20, 30), Offset(size.width - 20, 30), road);
    canvas.drawLine(Offset(size.width/2, 30), Offset(size.width/2, size.height - 40), road);
    canvas.drawLine(Offset(30, size.height/2), Offset(size.width - 30, size.height/2), road);

    final path = Path()..moveTo(40, size.height - 40);
    path.cubicTo(size.width*0.25, size.height*0.75, size.width*0.60, size.height*0.65, size.width - 60, 60);
    final route = Paint()..color = routeColor..strokeWidth = 4..style = PaintingStyle.stroke;
    canvas.drawPath(path, route);

    final start = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(40, size.height - 40), 5, start);
    final end = Paint()..color = Colors.redAccent;
    canvas.drawCircle(Offset(size.width - 60, 60), 7, end);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
