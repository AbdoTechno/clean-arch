import 'package:clean_arch/app.dart';
import 'package:clean_arch/core/databases/cache/cache_helper.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper().init();
  runApp(const MyApp());
}
