import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app1/Screen/news_detail.dart';
import 'package:news_app1/controller/category_news_controller.dart';

import '../model/new_model.dart';

class SelectedCategoryNews extends StatefulWidget {
  final String category;

  const SelectedCategoryNews({super.key, required this.category});

  @override
  _SelectedCategoryNewsState createState() => _SelectedCategoryNewsState();
}

class _SelectedCategoryNewsState extends State<SelectedCategoryNews> {
  final CategoryNewsController newsController = Get.find();

  @override
  void initState() {
    super.initState();
    newsController.getNews(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text(widget.category, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Obx(() {
        if (newsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (newsController.articles.isEmpty) {
          return const Center(child: Text("No news available for this category"));
        }
        return ListView.builder(
          itemCount: newsController.articles.length,
          itemBuilder: (context, index) {
            final article = newsController.articles[index];
            return _buildNewsCard(article);
          },
        );
      }),
    );
  }

  Widget _buildNewsCard(NewsModel article) {
    return GestureDetector(
      onTap: () => Get.to(() => NewsDetail(newsModel: article)),
      child: Card(
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            _buildNewsImage(article),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(article.title!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                  const SizedBox(height: 5),
                  Text(article.description ?? "No description available", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(height: 10),
                  Text("By: ${article.author ?? 'Unknown'}", style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsImage(NewsModel article) {
    return article.urlToImage != null && article.urlToImage!.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              article.urlToImage!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildImagePlaceholder();
              },
            ),
          )
        : _buildImagePlaceholder();
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[300],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
          SizedBox(height: 10),
          Text("No Image Available", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
