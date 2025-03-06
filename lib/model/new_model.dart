class CategoryModel {
  String? categoryName;

  CategoryModel({this.categoryName});

  
  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryName: json['categoryName'],
    );
  }
}

class NewsModel {
  String? title;
  String? description;
  String? urlToImage;
  String? author;
  String? content;

  NewsModel({
    this.title,
    this.description,
    this.urlToImage,
    this.author,
    this.content,
  });


  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'author': author,
      'content': content,
    };
  }

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'],
      description: json['description'],
      urlToImage: json['urlToImage'],
      author: json['author'],
      content: json['content'],
    );
  }
}
