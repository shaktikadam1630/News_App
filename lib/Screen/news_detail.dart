import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app1/Screen/SavedNewsScreen.dart';
import 'package:news_app1/controller/news_controller.dart';
import 'package:news_app1/model/new_model.dart';

class NewsDetail extends StatelessWidget {
  final NewsModel newsModel;
  NewsDetail({super.key, required this.newsModel});

  final NewsController newsController = Get.find<NewsController>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text("News Detail", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.white),
            onPressed: () {
              Get.to(() => SavedNewsScreen());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                newsModel.title ?? "No Title Available",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              _buildAuthorRow(),
              const SizedBox(height: 10),
              _buildImage(screenWidth), // No error now
              const SizedBox(height: 15),
              _buildCard("Description", newsModel.description),
              const SizedBox(height: 10),
              _buildCard("Content", newsModel.content),
              const SizedBox(height: 20),
              Center(
                child: Obx(() {
                  bool isSaved = newsController.isNewsSaved(newsModel.title!);
                  return ElevatedButton.icon(
                    onPressed: () {
                      newsController.toggleSave(newsModel);
                    },
                    icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border, color: Colors.white),
                    label: Text(isSaved ? "Remove from Saved" : "Save News"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSaved ? Colors.red : Colors.blue.shade900,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthorRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(Icons.person, color: Colors.grey, size: 18),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            newsModel.author ?? "Unknown Author",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 14, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String title, String? content) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 5),
            Text(content ?? "No $title Available", style: const TextStyle(fontSize: 16, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  // ✅ Move _buildImage inside the class so it can access newsModel
  Widget _buildImage(double width) {
    return GestureDetector(
      onTap: () {
        if (newsModel.urlToImage != null && newsModel.urlToImage!.isNotEmpty) {
          showDialog(
            context: Get.context!,
            builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 3.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(newsModel.urlToImage!),
                ),
              ),
            ),
          );
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          newsModel.urlToImage ?? '',
          height: width * 0.3,
          width: width,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildNoImageWidget(width);
          },
        ),
      ),
    );
  }

  Widget _buildNoImageWidget(double width) {
    return Container(
      height: width * 0.3,
      width: width,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
      ),
    );
  }
}
