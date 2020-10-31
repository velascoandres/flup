import 'package:flup/src/library/principal_provider.dart';
import 'package:flup/src/models/producto_model.dart';

class ProductosProvider extends PrincipalProvider<ProductoModel> {
  final String url = 'https://flup-test.firebaseio.com';
  final String segmento = 'productos.json';
}
