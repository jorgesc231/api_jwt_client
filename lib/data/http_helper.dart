import 'package:user_jwt_client/data/sessions.dart';
import 'package:user_jwt_client/data/sp_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpHelper {
  final SPHelper helper = SPHelper();

  final String apiPrefix = 'api/';
  final String pingPath = 'ping';
  final String registerPath = 'register';
  final String loginPath = 'login';
  final String userPath = 'user';
  final String logoutPath = 'logout';

  String ip = '';
  String port = '';

  late Future<dynamic> spHelper;

  HttpHelper() {
    spHelper = helper.init().then((value) {
      String config = helper.getConfig();
      List<String> address = config.split(':');
      ip = address.first;
      port = address.last;
    });
  }

  Future tryConnection(String ip, String port) async {
    Uri uri = Uri.http('$ip:$port', apiPrefix + pingPath);

    http.Response result = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (result.statusCode == 200) {
      return;
    } else {
      throw Exception(result.reasonPhrase);
    }
  }

  Future<Session> postLogIn(String email, String password) async {
    Map<String, String> jsonBody = {'email': email, 'password': password};

    //Future.wait({spHelper});
    await spHelper;

    Uri uri = Uri.http('$ip:$port', apiPrefix + loginPath);

    http.Response result = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(jsonBody),
    );

    String rawCookies = result.headers['set-cookie'] ?? '';

    if (result.statusCode == 200 && rawCookies.isNotEmpty) {
      Session session = Session.fromJson(jsonDecode(result.body));

      List<String> cookies = rawCookies.split(';');

      bool isJWT(String cookie) => cookie.split('=')[0] == 'jwt';

      session.jwtToken =
          cookies.firstWhere(isJWT, orElse: () => '').split('=')[1];

      session.email = email;
      saveSession(session);

      return session;
    } else {
      throw Exception(result.reasonPhrase);
    }
  }

  Future<Session> postSignIn(
      String userName, String email, String password) async {
    Map<String, String> jsonBody = {
      'name': userName,
      'email': email,
      'password': password
    };

    //Future.wait({spHelper});
    await spHelper;

    Uri uri = Uri.http('$ip:$port', apiPrefix + registerPath);

    http.Response result = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(jsonBody),
    );

    if (result.statusCode == 200) {
      Session session = Session.fromJson(jsonDecode(result.body));

      saveSession(session);

      return session;
    } else if (result.statusCode == 400) {
      Session session = Session(-1, "", "", "", "", "");

      return session;
    } else {
      throw Exception(result.reasonPhrase);
    }
  }

  Future<Session> getUser() async {
    Session storedSession = getSession();

    await spHelper;

    Uri uri = Uri.http('$ip:$port', apiPrefix + userPath);

    http.Response result = await http.get(
      uri,
      headers: <String, String>{
        'Cookie': 'jwt=${storedSession.jwtToken};',
      },
    );

    if (result.statusCode == 200) {
      Session newSession = Session.fromJson(jsonDecode(result.body));
      newSession.jwtToken = storedSession.jwtToken;

      // prueba
      saveSession(newSession);

      return newSession;
    } else {
      throw Exception('Failed to get user.');
    }
  }

  Future<bool> postLogout() async {
    Session storedSession = getSession();

    await spHelper;

    Uri uri = Uri.http('$ip:$port', apiPrefix + logoutPath);

    http.Response result = await http.post(
      uri,
      headers: <String, String>{
        'Cookie': 'jwt=${storedSession.jwtToken};',
      },
    );

    if (result.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future saveSession(Session session) async {
    DateTime now = DateTime.now();

    // String interpolation
    String today = '${now.year}-${now.month}-${now.day}';

    Session newSession = Session(
      session.id,
      today,
      session.name,
      session.email,
      '',
      session.jwtToken,
    );

    helper.writeSession(newSession).then((_) {});
  }

  Session getSession() {
    List<Session> sessions = helper.getSessions();

    return sessions[0];
  }
}
