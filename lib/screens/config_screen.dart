import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_jwt_client/data/http_helper.dart';

class ServerConfig extends StatefulWidget {
  const ServerConfig({super.key});

  @override
  State<ServerConfig> createState() => _ServerConfigState();
}

class _ServerConfigState extends State<ServerConfig> {
  final GlobalKey<FormState> _serverFormKey = GlobalKey<FormState>();
  final TextEditingController txtServerAddress = TextEditingController();

  Future<bool>? _futureConnection;

  TextInputFormatter ipFormater =
      FilteringTextInputFormatter.allow(RegExp(r'([0-9])|\.|:'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración del Servidor')),
      body:
          (_futureConnection == null) ? showServerForm() : buildFutureBuilder(),
    );
  }

  Form showServerForm() {
    return Form(
      key: _serverFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              textAlign: TextAlign.center,
              autofocus: true,
              autocorrect: false,
              controller: txtServerAddress,
              inputFormatters: [
                ipFormater,
              ],
              decoration: const InputDecoration(
                  icon: Icon(Icons.settings_remote),
                  hintText: '127.0.0.1:8000',
                  labelText: 'Direccion IP y puerto del Servidor'),
              validator: (String? value) {
                if (value == null ||
                    value.isEmpty ||
                    value.length < 8 ||
                    !value.contains(':')) {
                  return 'Por favor ingresa una IP valida';
                }
                return null;
              },
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
                      if (_serverFormKey.currentState!.validate()) {
                        // Process data.
                        setState(() {
                          _futureConnection = connectServer();
                        });
                      }
                    },
                    child: const Text('Conectar'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<bool> buildFutureBuilder() {
    return FutureBuilder<bool>(
      future: _futureConnection,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data ?? false) {
            //Wait flutter finish build...
            WidgetsBinding.instance.addPostFrameCallback((_) {
              //When finish, call actions inside
              Navigator.pushReplacementNamed(context, "/login");
            });
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48.0),
                    child: Icon(
                      //Icons.storage,
                      Icons.mobiledata_off,
                      size: 64.0,
                      color: Colors.redAccent,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 64.0),
                    child: Text("No se pudo conectar con el servidor",
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.5)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                          autofocus: true,
                          onPressed: () =>
                              {Navigator.pushReplacementNamed(context, '/')},
                          child: const Text("Volver")),
                    ),
                  )
                ],
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<bool> connectServer() async {
    List<String> address = txtServerAddress.text.split(':');

    HttpHelper helper = HttpHelper();

    try {
      await helper.tryConnection(address.first, address.last);
      await helper.helper.writeConfig(txtServerAddress.text);

      return true;
    } catch (exception) {
      return false;
    }
  }
}



/*
  @override
  void initState() {
    super.initState();

    txtServerAddress.addListener(() {
      final String text = txtServerAddress.text.toLowerCase();
      txtServerAddress.value = txtServerAddress.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  void dispose() {
    txtServerAddress.dispose();
    super.dispose();
  }
*/