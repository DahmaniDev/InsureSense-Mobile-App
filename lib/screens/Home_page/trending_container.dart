import 'package:flutter/material.dart';
import 'package:insuresense/model/news.dart';
import 'package:insuresense/screens/Home_page/news_detail_page.dart';

class TrendingContainer extends StatefulWidget {
  final News? article;
  const TrendingContainer({Key? key, @required this.article}) : super(key: key);
  @override
  _TrendingContainerState createState() => _TrendingContainerState();
}

class _TrendingContainerState extends State<TrendingContainer> {
  String url =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCoflC6Cj2wpbcKy9X-TnxXk9KTP2sCHzdfA&usqp=CAU';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.only(right: 15),
          child: Stack(
            children: [
              Container(
                height: 250,
                width: 180,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: Image.network(widget.article!.imgUrl!).image,
                    )),
              ),
              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: Container(
                  height: 85,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                    color: Colors.black54,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${widget.article!.title!.substring(0, 22)}...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: const Text(
                          'Read more ...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NewsDetailPage(article: widget.article)));
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
