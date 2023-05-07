import 'package:shared_preferences/shared_preferences.dart';
import 'sessions.dart';
import 'dart:convert';

class SPHelper {
  static late SharedPreferences prefs;

  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future writeSession(Session session) async {
    prefs.setString(session.id.toString(), json.encode(session.toJson()));
  }

  List<Session> getSessions() {
    List<Session> sessions = [];

    Set<String> keys = prefs.getKeys();

    for (var key in keys) {
      if (key != 'config') {
        Session session =
            Session.fromJson(json.decode(prefs.getString(key) ?? ''));

        sessions.add(session);
      }
    }

    return sessions;
  }

  Future setCounter() async {
    int counter = prefs.getInt('counter') ?? 0;
    counter++;

    await prefs.setInt('counter', counter);
  }

  int getCounter() {
    return prefs.getInt('counter') ?? 0;
  }

  Future deleteSession(int id) async {
    prefs.remove(id.toString());
  }

  // Server config
  Future writeConfig(String serverAddress) async {
    await prefs.setString('config', serverAddress);
  }

  String getConfig() {
    return prefs.getString('config') ?? '';
  }

  Future deleteConfig() async {
    prefs.remove('config');
  }
}
