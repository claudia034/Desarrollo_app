import '../models/product.dart';

const _imgOil = 'assets/images/oil.png';
const _imgBrake = 'assets/images/brakedisc.png';
const _imgDisc = 'assets/images/pads.png';
const _imgAir = 'assets/images/airfilter.png';

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
    imageUrl: _imgAir,
    vendor: 'Autopartes ES',
    deliveryEta: '45 minutos',
    attributes: {
      'Tipo': 'Panel',
      'Medida': 'Estándar',
    },
  ),
];

final List<Map<String, String>> carPartsForYou = [
  {'title': 'Toyota Corolla','subtitle': 'Envío gratis del 1 - 2 horas','image': 'assets/images/corolla.png'},
  {'title': 'Honda Civic','subtitle': 'Hasta 20% de descuento en modelos 2017 - 2018','image': 'assets/images/civic.png'},
  {'title': 'Hyundai Elantra','subtitle': 'Ofertas por temporada','image': 'assets/images/hyundai.png'},
];
