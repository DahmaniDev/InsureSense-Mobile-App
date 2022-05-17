import 'package:insuresense/model/news.dart';

class NewsApi {
  final String? status;
  final int? totalResults;
  final List<News>? articles;

  const NewsApi({this.status, this.totalResults, this.articles});

  factory NewsApi.fromJson(Map<String, dynamic> json) {
    return NewsApi(
        status: json['status'],
        totalResults: json['totalResults'],
        articles: json['articles']);
  }
}
