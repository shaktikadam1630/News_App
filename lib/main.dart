import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:news_app1/Screen/home_screen.dart';
import 'package:news_app1/controller/category_news_controller.dart';


Future<void> main() async {
   await GetStorage.init();
   Get.put(CategoryNewsController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: NewsHomeScreen(),
    );
  }
}
