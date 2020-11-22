import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:neshop/detail.dart';
import 'package:neshop/provider/newProvider.dart';
import 'package:neshop/utils/dateFormat.dart';
import 'package:neshop/utils/game.dart';
import 'package:neshop/utils/fetch.dart';
import 'package:provider/provider.dart';

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
      Provider.of<NewGameListProvider>(context, listen: false)
          .addNewGames(games);

      setState(() {
        gameList.addAll(games);
        // print(gameList.length);
      });
    }).whenComplete(() {
      setState(() {
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
    List<Game> newGameList =
        Provider.of<NewGameListProvider>(context, listen: false).getNewGameList;
    print('From provider: ${newGameList.length}');

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
                                    tag: 'newgame-$index',
                                    child: newGameList[index].heroImage,
                                  ),
                                ),
                              ),
                              Text(
                                convertDateFromString(
                                    newGameList[index].releaseDate),
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                              Text(newGameList[index].formalName.trim(),
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
