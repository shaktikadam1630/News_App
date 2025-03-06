import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app1/Screen/SavedNewsScreen.dart';
import 'package:news_app1/Screen/category_news.dart';
import 'package:news_app1/Screen/news_detail.dart';
import 'package:news_app1/controller/news_controller.dart';
import '../model/new_model.dart';

class NewsHomeScreen extends StatefulWidget {
  @override
  _NewsHomeScreenState createState() => _NewsHomeScreenState();
}

class _NewsHomeScreenState extends State<NewsHomeScreen> {
  final NewsController newsController = Get.put(NewsController());
  final TextEditingController searchController = TextEditingController();
  String selectedCategory = "All News";

  @override
  void initState() {
    super.initState();
    newsController.fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text("News Aggregator App", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.white),
            onPressed: () => Get.to(() => SavedNewsScreen()),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryList(),
          Expanded(child: _buildNewsList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Search news by title...",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          prefixIcon: const Icon(Icons.search, color: Colors.blue),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear, color: Colors.red),
            onPressed: () {
              searchController.clear();
              newsController.fetchNews();
            },
          ),
        ),
        onChanged: (query) {
          if (query.isEmpty) {
            newsController.fetchNews();
          } else {
            newsController.searchNews(query);
          }
        },
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 50,
      child: Obx(() => ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: newsController.categories.length + 1,
            itemBuilder: (context, index) {
              final category = index == 0 ? "All News" : newsController.categories[index - 1].categoryName!;
              return GestureDetector(
                onTap: () {
                  setState(() => selectedCategory = category);
                  if (category == "All News") {
                    newsController.fetchNews();
                  } else {
                    Get.to(() => SelectedCategoryNews(category: category));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Chip(
                    backgroundColor: selectedCategory == category ? Colors.blue.shade900 : Colors.blue,
                    label: Text(category, style: const TextStyle(color: Colors.white)),
                  ),
                ),
              );
            },
          )),
    );
  }

  Widget _buildNewsList() {
    return Obx(() {
      if (newsController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (newsController.articles.isEmpty) {
        return const Center(child: Text("No news found"));
      }
      return ListView.builder(
        itemCount: newsController.articles.length,
        itemBuilder: (context, index) {
          final article = newsController.articles[index];
          return _buildNewsCard(article);
        },
      );
    });
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