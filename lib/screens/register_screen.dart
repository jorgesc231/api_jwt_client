//import 'dart:math';

import 'package:flutter/material.dart';
import 'package:user_jwt_client/data/http_helper.dart';
import 'package:user_jwt_client/data/sessions.dart';
//import 'package:user_jwt_client/screens/welcome_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  final GlobalKey<FormState> _logInFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();

  Session result = Session(0, '', '', '', '', '');

  final double fontSize = 18;

  bool isLogin = true;
  bool isSignin = false;
  bool loggedIn = false;

  Future<Session>? _futureSession;

  late List<bool> isSelected;

  final String nameMessage = 'Nombre de Usuario';
  final String emailMessage = 'Correo Electronico';
  final String passwordMessage = 'Contraseña';

  @override
  void initState() {
    isSelected = [isLogin, isSignin];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        leading: BackButton(
          onPressed: () => Navigator.pushReplacementNamed(context, "/"),
        ),
      ),
      body: Center(
          child: (_futureSession == null) ? showForm() : buildFutureBuilder()),
    );
  }

  void toggleMeasure(value) {
    if (value == 0) {
      isLogin = true;
      isSignin = false;
    } else {
      isLogin = false;
      isSignin = true;
    }

    setState(() {
      isSelected = [isLogin, isSignin];
    });
  }

  Widget showForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SingleChildScrollView(
        child: Column(children: [
          ToggleButtons(
            isSelected: isSelected,
            onPressed: toggleMeasure,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Iniciar Sesion',
                      style: TextStyle(fontSize: fontSize))),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Registrarse',
                    style: TextStyle(fontSize: fontSize),
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: (isLogin) ? showLogInForm() : showSignInForm(),
          ),
        ]),
      ),
    );
  }

  Form showLogInForm() {
    return Form(
      key: _logInFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: TextFormField(
              controller: txtEmail,
              decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'ejemplo@mail.com',
                  labelText: 'Correo electronico'),
              validator: (String? value) {
                if (value == null ||
                    value.isEmpty ||
                    value.length < 8 ||
                    !value.contains('@')) {
                  return 'Por favor ingresa un correo electronico valido';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: TextFormField(
              controller: txtPassword,
              decoration: const InputDecoration(
                  icon: Icon(Icons.password), labelText: 'Contraseña'),
              obscureText: true,
              validator: (String? value) {
                if (value == null || value.isEmpty || value.length < 8) {
                  return 'Por favor ingresa una contraseña con mas de 8 caracteres';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(48.0),
            child: Center(
              child: SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_logInFormKey.currentState!.validate()) {
                      // Process data.
                      setState(() {
                        _futureSession = postLoginData();
                      });
                    }
                  },
                  child: const Text('Iniciar Sesión'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Form showSignInForm() {
    return Form(
      key: _signInFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: TextFormField(
              controller: txtName,
              decoration: const InputDecoration(
                  icon: Icon(Icons.person), labelText: 'Nombre de usuario'),
              validator: (String? value) {
                if (value == null || value.isEmpty || value.length < 5) {
                  return 'Por favor ingresa un nombre de mas de 5 caracteres';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: TextFormField(
              controller: txtEmail,
              decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'ejemplo@mail.com',
                  labelText: 'Correo electronico'),
              validator: (String? value) {
                if (value == null ||
                    value.isEmpty ||
                    value.length < 8 ||
                    !value.contains('@')) {
                  return 'Por favor ingresa un correo electronico valido';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: TextFormField(
              controller: txtPassword,
              decoration: const InputDecoration(
                  icon: Icon(Icons.password), labelText: 'Contraseña'),
              obscureText: true,
              validator: (String? value) {
                if (value == null || value.isEmpty || value.length < 8) {
                  return 'Por favor ingresa una contraseña con mas de 8 caracteres';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(48.0),
            child: Center(
              child: SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_signInFormKey.currentState!.validate()) {
                      // Process data.
                      setState(() {
                        _futureSession = postSignInData();
                      });
                    }
                  },
                  child: const Text('Registrarse'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder<Session> buildFutureBuilder() {
    return FutureBuilder<Session>(
      future: _futureSession,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.jwtToken.isNotEmpty) {
            loggedIn = true;
            //Wait flutter finish build...
            WidgetsBinding.instance.addPostFrameCallback((_) {
              //When finish, call actions inside
              Navigator.pushReplacementNamed(context, "/welcome");
            });
          } else if (snapshot.data!.id > 0 && snapshot.data!.email.isNotEmpty) {
            return showMsgWidget(
                context,
                Icons.check_circle_outline_rounded,
                Colors.greenAccent,
                'Registro Completado, ahora puedes iniciar sesion',
                "/login");
          } else if (snapshot.data!.id < 0) {
            return showMsgWidget(context, Icons.cancel, Colors.redAccent,
                'El correo ya esta en uso', "/login");
          } else {
            return showMsgWidget(context, Icons.cancel, Colors.redAccent,
                'Correo o Contraseña incorrectas', "/login");
          }
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }

  Future<Session> postLoginData() async {
    HttpHelper helper = HttpHelper();

    try {
      result = await helper.postLogIn(txtEmail.text, txtPassword.text);
    } catch (exception) {
      assert(true);
    }

    return result;
  }

  Future<Session> postSignInData() async {
    HttpHelper helper = HttpHelper();

    try {
      result = await helper.postSignIn(
          txtName.text, txtEmail.text, txtPassword.text);
    } catch (exception) {
      assert(true);
    }

    return result;
  }
}

Column showMsgWidget(BuildContext context, IconData myIcon, Color iconColor,
    String errorText, String path) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsets.all(48.0),
        child: Icon(
          myIcon,
          size: 64.0,
          color: iconColor,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(64.0),
        child: Text(errorText,
            style:
                DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5)),
      ),
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
              autofocus: true,
              onPressed: () => {Navigator.pushReplacementNamed(context, path)},
              child: const Text("Volver")),
        ),
      )
    ],
  );
}
