import 'package:flup/src/models/producto_model.dart';
import 'package:flutter/material.dart';
import 'package:flup/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {
  ProductoPage({Key key}) : super(key: key);

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  ProductoModel productoModel = new ProductoModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: productoModel.titulo,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textCapitalization: TextCapitalization.sentences,
      onSaved: (value) => productoModel.titulo = value,
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      validator: (value) {
        return value.length < 3 ? 'Ingrese el nombre del producto' : null;
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
        initialValue: productoModel.valor.toString(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        onSaved: (value) => productoModel.valor = double.parse(value),
        decoration: InputDecoration(
          labelText: 'Precio',
        ),
        validator: (value) {
          return utils.isNumeric(value) ? null : 'Ingrese un número';
        });
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.deepPurple,
      label: Text(
        'Guardar',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      icon: Icon(Icons.save),
      onPressed: _submit,
    );
  }

  void _submit() {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: productoModel.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(
        () => productoModel.disponible = value,
      ),
    );
  }
}
