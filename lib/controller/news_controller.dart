import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../Services/services.dart';
import '../model/new_model.dart';
import '../model/category_data.dart';

class NewsController extends GetxController {
  var articles = <NewsModel>[].obs;
  var allArticles = <NewsModel>[];
  var categories = <CategoryModel>[].obs;
  var isLoading = true.obs;
  var savedArticles = <NewsModel>[].obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    categories.value = getCategories();
    fetchNews();
    loadSavedArticles();
  }

  Future<void> fetchNews() async {
    try {
      isLoading.value = true;
      NewsApi newsApi = NewsApi();
      await newsApi.getNews();
      allArticles = newsApi.dataStore;
      articles.assignAll(allArticles);
    } catch (e) {
      print("Error fetching news: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void searchNews(String query) {
    if (query.isEmpty) {
      articles.assignAll(allArticles);
    } else {
      articles.assignAll(
        allArticles.where((article) =>
            article.title != null &&
            article.title!.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }

  void loadSavedArticles() {
    List<dynamic> savedData = box.read<List>('saved') ?? [];
    savedArticles.assignAll(savedData.map((json) => NewsModel.fromJson(json)).toList());
  }

  bool isNewsSaved(String title) {
    return savedArticles.any((saved) => saved.title == title);
  }

  void toggleSave(NewsModel article) {
    if (isNewsSaved(article.title!)) {
      savedArticles.removeWhere((saved) => saved.title == article.title);
      Get.snackbar("Removed", "News removed from saved list", snackPosition: SnackPosition.BOTTOM);
    } else {
      savedArticles.add(article);
      Get.snackbar("Saved", "News saved successfully", snackPosition: SnackPosition.BOTTOM);
    }
    box.write('saved', savedArticles.map((e) => e.toJson()).toList());
    update();
  }
}
