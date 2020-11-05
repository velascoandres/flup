import 'package:flup/src/bloc/login_bloc.dart';
import 'package:flup/src/pages/registro_page.dart';
import 'package:flup/src/shared_prefs/preferencias_usuario.dart';
import 'package:flutter/material.dart';

import 'src/bloc/provider.dart';

import 'src/pages/home_page.dart';
import 'src/pages/login_page.dart';
import 'src/pages/producto_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    final loginBloc = new LoginBloc();

    final email = prefs.email;
    final password = prefs.password;

    return FutureBuilder(
      future: loginBloc.loginRefrescarToken(email, password),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return Provider(
            child: MaterialApp(
              title: 'Material App',
              initialRoute: snapshot.data ? 'home' : 'login',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: Colors.deepPurple,
              ),
              routes: {
                'login': (BuildContext context) => LoginPage(),
                'registro': (BuildContext context) => RegistroPage(),
                'home': (BuildContext context) => HomePage(),
                'producto': (BuildContext context) => ProductoPage(),
              },
              home: Scaffold(
                appBar: AppBar(
                  title: Text('Material App Bar'),
                ),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
