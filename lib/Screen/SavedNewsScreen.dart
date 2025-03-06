import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/news_controller.dart';
import '../model/new_model.dart';
import 'news_detail.dart';

class SavedNewsScreen extends StatelessWidget {
  final NewsController newsController = Get.find<NewsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved News", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Obx(() {
        if (newsController.savedArticles.isEmpty) {
          return const Center(
            child: Text(
              "No saved news",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: newsController.savedArticles.length,
          itemBuilder: (context, index) {
            final NewsModel article = newsController.savedArticles[index];

            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    article.urlToImage ?? '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildNoImageWidget(),
                  ),
                ),
                title: Text(
                  article.title ?? "No Title",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  article.description ?? "No Description",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    newsController.toggleSave(article);
                  },
                ),
                onTap: () {
                  Get.to(() => NewsDetail(newsModel: article));
                },
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildNoImageWidget() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey[300],
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }
}
