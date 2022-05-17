import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:insuresense/model/news.dart';
import 'package:insuresense/screens/Home_page/trending_container.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<bool> fetched;
  Map<String, dynamic> api = new Map<String, dynamic>();
  List<News> articles = [];

  Future<bool> fetchNews() async {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };
    final test = await http
        .get(
            Uri.parse(
                'https://newsapi.org/v2/everything?q=insurance&apiKey=e10fe8204b5245b0af0bb1688e729ded'),
            headers: headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        api = jsonDecode(response.body);
        for (var i = 0; i < 4; i++) {
          articles.add(News.fromJson(api['articles'][i]));
        }
      }
    });
    return true;
  }

  @override
  void initState() {
    fetched = fetchNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 25),
        Container(
          height: 250,
          padding: const EdgeInsets.only(left: 10),
          child: FutureBuilder(
              future: fetched,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return news(articles);
                } else {
                  return Center(
                    child: const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator()),
                  );
                }
              }),
        ),
        const SizedBox(height: 25),
        Center(
            child: Text(
          'Our Top Rated Policies',
          style: TextStyle(
              fontSize: 19,
              color: Colors.blueGrey[700],
              fontWeight: FontWeight.bold),
        )),
        const SizedBox(height: 25),
        ListTile(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.lightGreen.shade200, width: 1),
              borderRadius: BorderRadius.circular(15)),
          title: Text("Travel Insurance"),
          trailing: Image.asset('assets/gold.png'),
        ),
        const SizedBox(height: 15),
        ListTile(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.lightGreen.shade200, width: 1),
              borderRadius: BorderRadius.circular(15)),
          title: Text("Health Insurance"),
          trailing: Image.asset('assets/silver.png'),
        ),
        const SizedBox(height: 15),
        ListTile(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.lightGreen.shade200, width: 1),
              borderRadius: BorderRadius.circular(15)),
          title: Text("Motor Insurance"),
          trailing: Image.asset('assets/bronze.png'),
        ),
        const SizedBox(height: 25),
        Image.asset('assets/logo.png', height: 80),
      ],
    );
  }

  Widget news(List<News>? api) => Container(
      height: 250,
      padding: const EdgeInsets.only(left: 10),
      child: ListView(scrollDirection: Axis.horizontal, children: [
        TrendingContainer(article: api![0]),
        TrendingContainer(article: api[1]),
        TrendingContainer(article: api[2]),
        TrendingContainer(article: api[3]),
      ]));
}
