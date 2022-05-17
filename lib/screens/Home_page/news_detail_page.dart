import 'package:flutter/material.dart';
import 'package:insuresense/model/news.dart';
import 'package:insuresense/screens/Customer/profile_image.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends StatefulWidget {
  final News? article;
  const NewsDetailPage({Key? key, @required this.article}) : super(key: key);

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article!.title!),
        backgroundColor: Colors.black45,
        elevation: 8.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              child: Icon(Icons.public),
              onTap: () => launch(widget.article!.fullArticleUrl!),
            ),
          )
        ],
      ),
      body: Center(
        child: ListView(
          physics: BouncingScrollPhysics(),
          //shrinkWrap: true,
          children: [
            Material(
              elevation: 11.0,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 250,
                width: 180,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: Image.network(widget.article!.imgUrl!).image,
                    )),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  widget.article!.title!,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      fontFamily: 'Newsreader'),
                ),
              ),
            ),
            widget.article!.author == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 20),
                    child: Text(
                      'Author : ${widget.article!.author!}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey.shade300,
                          fontSize: 18),
                    ),
                  ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Published at : ${widget.article!.publishedAt!.substring(0, 10)}',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.article!.description!,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "For full article click on the ",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.public),
                  SizedBox(width: 5),
                  Text(
                    " above",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
