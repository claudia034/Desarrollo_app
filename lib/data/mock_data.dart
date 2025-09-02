import '../models/product.dart';

const _imgOil = 'https://picsum.photos/seed/bosch-oil/600/400';
const _imgBrake = 'https://picsum.photos/seed/brake/600/400';
const _imgDisc = 'https://picsum.photos/seed/disc/600/400';

final List<Product> popularProducts = [
  Product(
    id: 'p1',
    name: 'Filtro de aceite',
    vehicle: 'Toyota Corolla 2015-2018',
    price: 30.99,
    oldPrice: 37.99,
    rating: 4.9,
    imageUrl: _imgOil,
    vendor: 'Autozone El Salvador',
    deliveryEta: '1 - 2 horas',
    attributes: {
      'Altura': '88.11 mm',
      'Diám. externo': '68.27',
      'Rosca': '3/4-16',
      'Tipo': 'Metálico',
    },
  ),
  Product(
    id: 'p2',
    name: 'Sistema de frenos',
    vehicle: 'Toyota Corolla 2010-2013',
    price: 84.99,
    rating: 4.7,
    imageUrl: _imgBrake,
    vendor: 'Autofix El Salvador',
    deliveryEta: '2 - 3 horas',
    attributes: {
      'Tipo': 'Kit completo',
      'Garantía': '12 meses',
    },
  ),
  Product(
    id: 'p3',
    name: 'Pastillas de freno',
    vehicle: 'Toyota Corolla 2015-2018',
    price: 49.29,
    oldPrice: 57.99,
    rating: 4.6,
    imageUrl: _imgDisc,
    vendor: 'Brake It Salvador',
    deliveryEta: '1 - 2 horas',
    attributes: {
      'Composición': 'Cerámicas',
      'Garantía': '6 meses',
    },
  ),
  Product(
    id: 'p4',
    name: 'Filtro de aire',
    vehicle: 'Honda Civic 2017-2018',
    price: 19.99,
    rating: 4.5,
    imageUrl: 'https://picsum.photos/seed/air/600/400',
    vendor: 'Autopartes ES',
    deliveryEta: '45 minutos',
    attributes: {
      'Tipo': 'Panel',
      'Medida': 'Estándar',
    },
  ),
];

final List<Map<String, String>> carPartsForYou = [
  {'title': 'Toyota Corolla','subtitle': 'Envío gratis del 1 - 2 horas','image': 'https://picsum.photos/seed/corolla/300/200',},
  {'title': 'Honda Civic','subtitle': 'Hasta 20% de descuento en modelos 2017 - 2018','image': 'https://picsum.photos/seed/civic/300/200',},
  {'title': 'Hyundai Elantra','subtitle': 'Ofertas por temporada','image': 'https://picsum.photos/seed/elantra/300/200',},
];
