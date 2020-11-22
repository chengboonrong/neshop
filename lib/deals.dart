import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:neshop/detail.dart';
import 'package:neshop/utils/game.dart';
import 'package:neshop/utils/fetch.dart';
import 'package:neshop/utils/dateFormat.dart';

class DealsPage extends StatefulWidget {
  final List<double> rates;

  DealsPage({this.rates});

  @override
  DealsPageState createState() => DealsPageState();
}

class DealsPageState extends State<DealsPage> {
  List<Game> gameList = List<Game>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      isLoading = true;
    });

    fetchGameList('sales').then((games) {
      setState(() {
        gameList.addAll(games);
        isLoading = false;
      });
    });
  }

  void _openDetail(
      context, index, id, name, image, colors, screenshots, rImage, descrips) {
    final route = CupertinoPageRoute(
      builder: (context) => DetailPage(
        from: 'deals',
        index: index,
        gameID: id,
        formalName: name,
        // heroBannerUrl: imageURL,
        heroImage: image,
        dominantColors: colors,
        screenShots: screenshots,
        ratingImageURL: rImage,
        descriptors: descrips,
      ),
    );
    Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            transitionBetweenRoutes: false,
            middle: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_offer_outlined, color: Colors.black),
                Text('\tDeals'),
              ],
            ),
          ),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: gameList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(4),
                      child: InkWell(
                        onTap: () => _openDetail(
                            context,
                            index,
                            gameList[index].gameID,
                            gameList[index].formalName,
                            gameList[index].heroImage,
                            gameList[index].dominantColors,
                            gameList[index].screenshots,
                            gameList[index].ratingImageURL,
                            gameList[index].descriptors),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Hero(
                                    tag: 'dealsgame-$index',
                                    child: gameList[index].heroImage,
                                  ),
                                ),
                              ),
                              Text(
                                convertDateFromString(
                                    gameList[index].releaseDate),
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                              Text(gameList[index].formalName.trim(),
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
