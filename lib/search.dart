import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Post {
  final String title;
  final String body;

  Post(this.title, this.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SearchBarController<Post> _searchBarController = SearchBarController();
  bool isReplay = false;

  List<Post> _posts = [
    Post("Dan", "some details"),
    Post("Hello", "some details"),
    Post("Hello Worlds", "some details"),
    Post("Minecraft", "some details")
  ];

  Future<List<Post>> _getALlPosts(String text) async {
    // await Future.delayed(Duration(seconds: text.length == 4 ? 10 : 1));
    // if (isReplay) return [Post("Replaying !", "Replaying body")];
    // if (text.length == 5) throw Error();
    // if (text.length == 6) return [];
    // List<Post> posts = [];

    // var random = new Random();
    // for (int i = 0; i < 10; i++) {
    //   posts
    //       .add(Post("$text $i", "body random number : ${random.nextInt(100)}"));
    // }
    return _posts.where((element) => element.title.contains(text)).toList();
    // return _posts;
    // return _posts.where((element) => {(element.title == text)}).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SearchBar<Post>(
          hintText: "Search games",
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          onSearch: _getALlPosts,
          searchBarController: _searchBarController,
          placeHolder: ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (BuildContext context, index) {
                return Container(
                  color: Colors.lightBlue,
                  child: ListTile(
                    title: Text(_posts[index].title),
                    isThreeLine: true,
                    subtitle: Text(_posts[index].body),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Detail()));
                    },
                  ),
                );
              }),
          cancellationWidget: Text("Cancel"),
          emptyWidget: Center(
            child: Text("Nothing found"),
          ),
          indexedScaledTileBuilder: (int index) =>
              ScaledTile.count(1, index.isEven ? 2 : 1),
          header: Row(
            children: <Widget>[
              RaisedButton(
                child: Text("sort"),
                onPressed: () {
                  _searchBarController.sortList((Post a, Post b) {
                    return a.body.compareTo(b.body);
                  });
                },
              ),
              RaisedButton(
                child: Text("Desort"),
                onPressed: () {
                  _searchBarController.removeSort();
                },
              ),
              RaisedButton(
                child: Text("Replay"),
                onPressed: () {
                  isReplay = !isReplay;
                  _searchBarController.replayLastSearch();
                },
              ),
            ],
          ),
          onCancelled: () {
            print("Cancelled triggered");
          },
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 2,
          onItemFound: (Post post, int index) {
            return Container(
              color: Colors.lightBlue,
              child: ListTile(
                title: Text(post.title),
                isThreeLine: true,
                subtitle: Text(post.body),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Detail()));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Text("Detail"),
          ],
        ),
      ),
    );
  }
}
