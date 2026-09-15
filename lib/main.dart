import 'package:docdoc/core/di/dependency_injection.dart';
import 'package:docdoc/core/routing/app_router.dart';
import 'package:docdoc/doc_app.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await getItSetup();
  runApp(DocApp(appRouter: AppRouter()));
}
