import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../services/services.dart';
import '../model/new_model.dart';

class CategoryNewsController extends GetxController {
  var articles = <NewsModel>[].obs;
  var savedArticles = <NewsModel>[].obs;
  var isLoading = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadSavedArticles(); // Load saved articles on startup
  }

  /// Fetch news based on category
  void getNews(String category) async {
    try {
      isLoading(true);
      CategoryNews news = CategoryNews();
      await news.getNews(category);
      articles.assignAll(news.dataStore);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch news: $e", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  /// Save or remove an article
  void toggleSaveArticle(NewsModel article) {
    if (isArticleSaved(article.title!)) {
      removeArticle(article.title!);
    } else {
      saveArticle(article);
    }
  }

  /// Save an article
  void saveArticle(NewsModel article) {
    List<dynamic> savedList = box.read<List>('savedArticles') ?? [];

    savedList.add({
      'title': article.title,
      'description': article.description,
      'urlToImage': article.urlToImage,
      'author': article.author,
    });

    box.write('savedArticles', savedList);
    loadSavedArticles();
    Get.snackbar("Saved", "Article saved successfully", snackPosition: SnackPosition.BOTTOM);
  }

  /// Remove an article
  void removeArticle(String title) {
    List<dynamic> savedList = box.read<List>('savedArticles') ?? [];
    savedList.removeWhere((element) => element['title'] == title);

    box.write('savedArticles', savedList);
    loadSavedArticles();
    Get.snackbar("Removed", "Article removed from saved", snackPosition: SnackPosition.BOTTOM);
  }

  /// Load saved articles
  void loadSavedArticles() {
    List<dynamic> savedList = box.read<List>('savedArticles') ?? [];
    savedArticles.assignAll(
      savedList.map((e) => NewsModel(
            title: e['title'],
            description: e['description'],
            urlToImage: e['urlToImage'],
            author: e['author'],
          )),
    );
  }

  /// Check if an article is saved
  bool isArticleSaved(String title) {
    return savedArticles.any((element) => element.title == title);
  }
}
