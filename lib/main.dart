import 'package:flutter/material.dart';
import 'package:qrcodegenerator/qrscreen.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MainApp());
  ResponsiveBuild;
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        theme: ThemeData(fontFamily: 'Axiforma'),
        debugShowCheckedModeBanner: false,
        initialRoute: QRCodeGenerator.routeName,
        routes: {
          QRCodeGenerator.routeName: (context) => const QRCodeGenerator(),
        },
      );
    });
  }
}
