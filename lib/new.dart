import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:neshop/detail.dart';
import 'package:neshop/utils/dateFormat.dart';
import 'package:neshop/utils/game.dart';
import 'package:neshop/utils/fetch.dart';

class NewPage extends StatefulWidget {
  final List<double> rates;

  NewPage({this.rates});

  @override
  NewPageState createState() => NewPageState();
}

class NewPageState extends State<NewPage> {
  List<Game> gameList = List<Game>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      isLoading = true;
    });

    fetchGameList('new').then((games) {
      setState(() {
        gameList.addAll(games);
        print(gameList.length);
        isLoading = false;
      });
    });
  }

  _openDetail(
      context, index, id, name, image, colors, screenshots, rImage, descrips) {
    final route = CupertinoPageRoute(
      builder: (context) => DetailPage(
          from: 'new',
          index: index,
          gameID: id,
          formalName: name,
          heroImage: image,
          dominantColors: colors,
          screenShots: screenshots,
          ratingImageURL: rImage,
          descriptors: descrips),
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
                Icon(
                  Icons.new_releases_outlined,
                  color: Colors.black,
                ),
                Text('\tNew'),
              ],
            ),
          ),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
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
                              Hero(
                                tag: 'newgame-$index',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: gameList[index].heroImage,
                                ),
                              ),
                              Text(
                                convertDateFromString(
                                    gameList[index].releaseDate),
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                              Text(gameList[index].formalName.trim(),
                                  overflow: TextOverflow.ellipsis,
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
