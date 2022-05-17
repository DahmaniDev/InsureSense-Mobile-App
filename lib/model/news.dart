class News {
  final Map<String, dynamic>? source;
  final String? author;
  final String? title;
  final String? imgUrl;
  final String? description;
  final String? publishedAt;
  final String? fullArticleUrl;

  const News(
      {this.source,
      this.author,
      this.title,
      this.imgUrl,
      this.description,
      this.publishedAt,
      this.fullArticleUrl});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
        source: json['source'],
        author: json['author'],
        title: json['title'],
        description: json['description'],
        imgUrl: json['urlToImage'],
        publishedAt: json['publishedAt'],
        fullArticleUrl: json['url']);
  }
}
