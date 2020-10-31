
import 'package:flup/src/bloc/login_bloc.dart';
import 'package:flup/src/bloc/provider.dart';
import 'package:flutter/material.dart';

class Posicion {
  double rigth;
  double left;
  double top;
  double bottom;

  Posicion({this.rigth, this.left, this.top, this.bottom});
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _crearFondo(context),
          _loginForm(context),
        ],
      ),
    );
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: size.height * 0.4,
      width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0),
          ],
        ),
      ),
    );
    List<Posicion> posiciones = [
      Posicion(rigth: 30, top: 120),
      Posicion(rigth: -30, top: 20),
      Posicion(left: -30, top: 120),
      Posicion(left: 60, top: -12),
    ];

    return Stack(
      children: [
        fondoMorado,
        ..._circulos(posiciones),
        Center(
          child: Container(
            padding: EdgeInsets.only(
              top: 80.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_pin_circle,
                  color: Colors.white,
                  size: 100.0,
                ),
                Text(
                  'Andrés Velasco',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _circulos(List<Posicion> posiciones) {
    final circulo = Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.07),
      ),
    );
    return posiciones.map(
      (Posicion posicion) {
        return Positioned(
          top: posicion.top,
          right: posicion.rigth,
          left: posicion.left,
          bottom: posicion.bottom,
          child: circulo,
        );
      },
    ).toList();
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 180,
            ),
          ),
          Container(
            width: size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 50),
            margin: EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromRGBO(63, 63, 156, 1.0),
                    Colors.red,
                  ],
                ),
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 3.0,
                  ),
                ]),
            child: Column(
              children: <Widget>[
                Text(
                  'Ingreso',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                SizedBox(
                  height: 60.0,
                ),
                _crearEmail(bloc),
                SizedBox(
                  height: 30.0,
                ),
                _crearPassword(bloc),
                SizedBox(
                  height: 30.0,
                ),
                _crearBoton(bloc),
              ],
            ),
          ),
          Text('¿Olvido la contraseña?'),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            onChanged: bloc.changeEmail,
            decoration: InputDecoration(
              icon: Icon(
                Icons.alternate_email,
                color: Colors.deepPurple,
              ),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo eléctronico',
              errorText: snapshot.error,
              labelStyle: TextStyle(color: Colors.white),
              errorStyle: TextStyle(color: Colors.yellow),
            ),
          ),
        );
      },
    );
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            onChanged: bloc.changePassword,
            style: TextStyle(color: Colors.white),
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(
                Icons.security,
                color: Colors.deepPurple,
              ),
              errorStyle: TextStyle(color: Colors.yellow),
              labelText: 'Contraseña',
              labelStyle: TextStyle(color: Colors.white),
              errorText: snapshot.error,
            ),
          ),
        );
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        final estaValido = snapshot.hasData;
        return RaisedButton(
          onPressed: estaValido ? () => _login(bloc, context) : null,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15.0),
            child: Text('Ingresar'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          elevation: 0.0,
          color: Colors.deepPurple,
          textColor: Colors.white,
        );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) {
    print('Email: ${bloc.email}');
    print('Pass: ${bloc.password}');
    Navigator.pushReplacementNamed(context, 'home');
  }
}
