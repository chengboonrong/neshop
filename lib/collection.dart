import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.favorite_border_outlined,
              color: Colors.black,
            ),
            Text('\tCollection'),
          ],
        ),
        leading: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder:
                        null)); // Go to Login/Register Page     // Profile page
          },
          child: Row(
            children: [
              Icon(
                Icons.person_rounded,
                color: Colors.black87,
                size: 18,
              ),
              Text(
                'Log In/Sign Up',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: Collection(),
      ),
    );
  }
}

class Collection extends StatefulWidget {
  Collection({Key key}) : super(key: key);

  @override
  _CollectionState createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  final List<FavGame> favGames = [
    FavGame(
        gameTitle: 'Hello',
        imageURL: 'lib/assets/images/ns-logo.png',
        favorite: true),
    FavGame(
        gameTitle: 'Hello',
        imageURL: 'lib/assets/images/ns-logo.png',
        favorite: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        itemCount: favGames.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return GameCard(
            fg: favGames[index],
            index: index,
          );
        },
      ),
    );
  }
}

class FavGame {
  String imageURL;
  String gameTitle;
  bool favorite;

  FavGame({this.imageURL, this.gameTitle, this.favorite});
}

class GameCard extends StatefulWidget {
  final FavGame fg;
  final int index;
  GameCard({Key key, @required this.fg, @required this.index})
      : super(key: key);

  @override
  _GameCardState createState() => _GameCardState();
}

class _GameCardState extends State<GameCard>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: Image.asset(
                      // 'lib/assets/images/ns-logo.png',
                      widget.fg.imageURL,
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                  ),
                  Text(
                    // 'Game Title',
                    widget.fg.gameTitle,
                    overflow: TextOverflow.fade,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          widget.fg.favorite
                              ? setState(() {
                                  widget.fg.favorite = false;
                                })
                              : setState(() {
                                  widget.fg.favorite = true;
                                });
                          print('${widget.index}: ${widget.fg.favorite}');
                        },
                        icon: Icon(widget.fg.favorite
                            ? Icons.favorite
                            : Icons.favorite_border),
                      )
                    ],
                  )
                ],
              )
            ],
          )
        ],
      ),
    ));
  }
}
