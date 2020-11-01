import 'dart:async';
import 'dart:io';
import 'package:flup/src/constants/images_paths.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flup/src/models/producto_model.dart';
import 'package:flup/src/providers/productos_provider.dart';
import 'package:flutter/material.dart';
import 'package:flup/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {
  ProductoPage({Key key}) : super(key: key);

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductoModel productoModel = new ProductoModel();
  bool _guardando = false;

  final productoProvider = new ProductosProvider();

  final picker = ImagePicker();
  File _image;

  @override
  Widget build(BuildContext context) {
    final ProductoModel productoArg = ModalRoute.of(context).settings.arguments;
    if (productoArg != null) productoModel = productoArg;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
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
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _guardarBoton(),
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

  Widget _guardarBoton() {
    final bool debeEditar = productoModel.id != null;
    final String mensaje = debeEditar ? 'Editar' : 'Guardar';
    final Color color = debeEditar ? Colors.blueAccent : Colors.green;
    final IconData icono = debeEditar ? Icons.update : Icons.save;

    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: color,
      label: Text(
        mensaje,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      icon: Icon(icono),
      onPressed: _guardando ? null : () => _submit(context),
    );
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

  void _submit(BuildContext context) async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    final bool debeEditar = productoModel.id != null;
    setState(() => _guardando = true);
    if (debeEditar) {
      final bool edito =
          await productoProvider.update(productoModel.id, productoModel);
      if (edito) {
        mostrarSnackbar('Producto editado!!');
      } else {
        mostrarSnackbar('Error al editar!!');
      }
    } else {
      final bool creo = await productoProvider.create(productoModel);
      if (creo) {
        mostrarSnackbar('Producto creado!!');
        Navigator.pop(context);
      } else {
        mostrarSnackbar('Error al crear!!');
      }
    }
    Timer(Duration(seconds: 1), () => Navigator.pop(context));
  }

  void mostrarSnackbar(String mensaje) {
    final snackBar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _seleccionarFoto() async {
    try {
      final picketFile = await picker.getImage(source: ImageSource.gallery);
      if (picketFile != null) {
        _image = File(picketFile.path);
      } else {
        print('Imagen no seleccionada');
      }
    } catch (error) {
      print(error);
    }
    setState(() {});
  }

  void _tomarFoto() {}

  _mostrarFoto() {
    if (productoModel.fotoUrl != null) {
      // TODO arreglar esto
      return Container();
    }
    if (_image != null) {
      return Image.file(
        _image,
        height: 300,
        fit: BoxFit.cover,
      );
    } else {
      return Image(
        image: AssetImage(
          NO_IMAGE,
        ),
        height: 300,
        fit: BoxFit.cover,
      );
    }
  }
}
