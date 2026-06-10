import 'package:flutter_dotenv/flutter_dotenv.dart';

String getText(String key) {
  final appName = dotenv.env[key] ?? 'unknow';
  return appName;
}
