import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:neshop/detail.dart';
import 'package:neshop/utils/game.dart';
import 'package:neshop/utils/fetch.dart';

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

  _openDetail(context, index, id, name, imageURL, colors, screenshots, rImage,
      descrips) {
    final route = CupertinoPageRoute(
      builder: (context) => DetailPage(
        index: index,
        gameID: id,
        formalName: name,
        heroBannerUrl: imageURL,
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
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          middle: Text('Deals'),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: gameList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    onTap: () => _openDetail(
                        context,
                        index,
                        gameList[index].gameID,
                        gameList[index].formalName,
                        gameList[index].heroBannerUrl,
                        gameList[index].dominantColors,
                        gameList[index].screenshots,
                        gameList[index].ratingImageURL,
                        gameList[index].descriptors),
                    isThreeLine: true,
                    subtitle: Text(''),
                    leading: Hero(
                      tag: 'dealsgame-$index',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: gameList[index].heroBannerUrl,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    title: Text('${gameList[index].formalName}'),
                  );
                },
              ),
      ),
    );
  }
}
