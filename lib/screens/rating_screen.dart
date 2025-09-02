import 'package:flutter/material.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int stars = 5;
  final chips = ['Entrega rápida','Conductor amable','Paquete seguro','A tiempo','Incorrecto','Falta producto'];
  final Set<String> selected = {'Entrega rápida','Conductor amable'};
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Calificar entrega')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: const [
            CircleAvatar(radius: 24, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12')),
            SizedBox(width: 12),
            Expanded(child: Text('Entregado por Carlos M.\nHoy, 3:15 PM')),
          ]),
          const SizedBox(height: 16),
          Text('¿Cómo fue tu experiencia de entrega?', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) {
            final filled = i < stars;
            return IconButton(icon: Icon(filled ? Icons.star : Icons.star_border, size: 32, color: Colors.amber), onPressed: () => setState(() => stars = i+1));
          })),
          const SizedBox(height: 12),
          Text('¿Qué te gustó o no te gustó?', style: tt.titleSmall),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: chips.map((c) {
            final isSel = selected.contains(c);
            return ChoiceChip(label: Text(c), selected: isSel, onSelected: (_) => setState(() { isSel ? selected.remove(c) : selected.add(c); }));
          }).toList()),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(hintText: 'Escribe tu comentario...', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          SizedBox(height: 48, child: FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Enviar reseña'))),
        ],
      ),
    );
  }
}
