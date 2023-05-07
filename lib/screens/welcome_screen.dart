import 'package:flutter/material.dart';
import 'package:user_jwt_client/data/http_helper.dart';
import 'package:user_jwt_client/data/sessions.dart';
import '../data/sp_helper.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Future<Session>? _futureSession;
  int? userid = 0;
  final SPHelper sphelper = SPHelper();

  @override
  void initState() {
    sphelper.init().then((value) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Sesión')),
        body: Center(
            child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white70),
          child: userText(),
        )));
  }

  Widget userText() {
    _futureSession ??= getUser();

    return buildFutureBuilder();
  }

  FutureBuilder<Session> buildFutureBuilder() {
    return FutureBuilder<Session>(
      future: _futureSession,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          userid = snapshot.data?.id;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                dataRow('ID: ', '${snapshot.data?.id}'),
                //dataRow('Fecha: ', '${snapshot.data?.date}'),
                dataRow('Nombre: ', '${snapshot.data?.name}'),
                dataRow('Email: ', '${snapshot.data?.email}'),
                dataRow('Token JWT: ', '${snapshot.data?.jwtToken}'),
                Padding(
                  padding: const EdgeInsets.only(top: 48.0),
                  child: Center(
                    child: SizedBox(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                          onPressed: onPressedCloseSession,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('Cerrar Sesión'),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.logout,
                                size: 24,
                              )
                            ],
                          )),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }

  Future<Session> getUser() async {
    HttpHelper helper = HttpHelper();

    return await helper.getUser();
  }

  void onPressedCloseSession() {
    // Llamar a api/logout
    HttpHelper helper = HttpHelper();

    helper.postLogout().then((result) => {
          if (result && userid != null)
            {
              sphelper.deleteSession(userid ?? 0),
              Navigator.pushReplacementNamed(context, "/login"),
            }
        });
  }

  Widget dataRow(String label, String value) {
    Widget row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).hintColor,
                ),
              )),
          Expanded(
              flex: 4,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                ),
              )),
        ],
      ),
    );

    return row;
  }
}



/*
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ID:'),
                Text('${snapshot.data?.id}'),
                Text('Fecha: ${snapshot.data?.date}'),
                Text('Nombre: ${snapshot.data?.name}'),
                Text('Email: ${snapshot.data?.email}'),
                Text('Token JWT: ${snapshot.data?.jwt_token}'),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 48.0),
                    child: Center(
                      child: SizedBox(
                        height: 50,
                        width: 200,
                        child: ElevatedButton(
                            onPressed: OnPressedCloseSession,
                            child: Text('Cerrar Sesión')),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
 */