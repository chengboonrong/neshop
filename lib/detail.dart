import 'package:currency_pickers/country.dart';
import 'package:currency_pickers/currency_pickers.dart';
import 'package:flutter/material.dart';
import 'package:neshop/table_price.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:neshop/utils/fetch.dart';
import 'package:neshop/utils/game.dart';
import 'package:neshop/settings.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';
// import 'package:video_player/video_player.dart';

class DetailPage extends StatefulWidget {
  final String from;
  final int index;
  final String gameID;
  final String formalName;

  // final String heroBannerUrl;
  final Image heroImage;
  final List<String> dominantColors;
  final List<String> screenShots;
  final String ratingImageURL;
  final List<String> descriptors;

  DetailPage({
    Key key,
    @required this.from,
    @required this.gameID,
    @required this.index,
    @required this.formalName,
    // @required this.heroBannerUrl,
    @required this.heroImage,
    @required this.dominantColors,
    @required this.screenShots,
    @required this.ratingImageURL,
    @required this.descriptors,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  GameInfo gameInfo = GameInfo();
  Price gamePrice = Price();
  bool isLoading = false;
  String _defaultCurrency = '';
  String countryCode = '';
  Country country = CurrencyPickerUtils.getCountryByIsoCode('US');

  // VideoPlayerController _controller;
  // Future<void> _initializeVideoPlayerFuture;

  List<Price> priceByCountries = List<Price>();

  @override
  void initState() {
    /////////////// For Video Playback ///////////////////////////////////////////////////////
    // _controller = VideoPlayerController.network(
    //   'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    // );

    // _initializeVideoPlayerFuture = _controller.initialize().then((_) {
    //   setState(() {});
    // });
    ////////////////////////////////////////////////////////////////////////////////////////

    super.initState();

    if (mounted)
      setState(() {
        isLoading = true;
      });

    getCurrency().then((c) {
      if (mounted)
        setState(() {
          c == null ? _defaultCurrency = 'USD' : _defaultCurrency = c;
        });

      fetchGameAllPrice(widget.gameID, c).then((value) {
        if (mounted)
          setState(() {
            priceByCountries.addAll(value);

            if (mounted) isLoading = false;
          });
      });
    });

    getCountryCode().then((value) {
      if (mounted)
        setState(() {
          countryCode = value;
        });
      country = CurrencyPickerUtils.getCountryByIsoCode(countryCode);
    });

    fetchGameInfo(widget.gameID).then((value) {
      if (mounted)
        setState(() {
          gameInfo = value;
        });
    });

    // print(gameInfo.videoID);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> defaultColors = ["110d0d", "fefefd"];
    // print(gameFileSize);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 3.3,
                    color: Colors.white,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 3.8,
                    color: Color(int.parse(
                        '0xff${widget.dominantColors.isNotEmpty ? widget.dominantColors[0] : defaultColors[0]}')),
                  ),
                  Card(
                    elevation: 16,
                    color: Colors.transparent,
                    child: Container(
                      child: Hero(
                        tag: '${widget.from}game-${widget.index}',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: widget.heroImage,
                                // Image.network(
                                //   widget.heroBannerUrl,
                                //   width:
                                //       MediaQuery.of(context).size.width / 1.1,
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 40),
                        width: 60,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white70,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 40),
                        width: 8,
                        height: 50,
                        color: Color(int.parse(
                            '0xff${widget.dominantColors.isNotEmpty ? widget.dominantColors[1] : defaultColors[1]}')),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 40, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              tooltip: 'Back',
                              color: Colors.black,
                              icon: Icon(Icons.arrow_back_ios_outlined),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white70,
                                    ),
                                    child: IconButton(
                                      tooltip: 'Video MP4',
                                      color: Colors.black,
                                      icon: Icon(Icons.play_circle_fill),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VideoPlayback()),
                                        );
                                      },
                                    ),
                                  ),
                                  (!isLoading)
                                      ? Container(
                                          width: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white70,
                                          ),
                                          child: IconButton(
                                            tooltip: 'More details',
                                            color: Colors.black,
                                            icon:
                                                Icon(Icons.more_vert_outlined),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TablePricePage(
                                                          gameID: widget.gameID,
                                                          gameTitle:
                                                              widget.formalName,
                                                          gamePrice: gamePrice,
                                                          countrySettings:
                                                              country,
                                                          prices:
                                                              priceByCountries,
                                                        )),
                                              );
                                            },
                                          ),
                                        )
                                      : Container(),
                                ]),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),

              // Container(
              //   child: Center(
              //     child: (_controller?.value?.initialized ?? false)
              //         ? AspectRatio(
              //             aspectRatio: _controller?.value?.aspectRatio,
              //             child: VideoPlayer(_controller),
              //           )
              //         : Container(),
              //   ),
              // ),

              // game name
              Container(
                padding: const EdgeInsets.only(
                  bottom: 20,
                ),
                color: Color(int.parse('0xff${defaultColors[1]}')),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              height: 4,
                              color: Color(0xffFF512C),
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 9,
                          child: Container(
                            width: 280,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              widget.formalName, // Game Name
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),

                        // game price
                        Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                // Flag('MY',
                                //     height: 10, width: 20, fit: BoxFit.fill),
                                // Text('MYR')
                                Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  child:
                                      CurrencyPickerUtils.getDefaultFlagImage(
                                          country),
                                ),

                                Text(_defaultCurrency),
                              ],
                            )),
                        (!isLoading)
                            ? Expanded(
                                flex: 1,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  child: Text.rich(
                                    TextSpan(
                                      text: priceByCountries[0]
                                                  ?.convDiscountPrice !=
                                              '0.0'
                                          ? priceByCountries[0]
                                              ?.convDiscountPrice
                                          : priceByCountries[0]
                                              ?.convRegularPrice,
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: priceByCountries[0]
                                                        .convDiscountPrice ==
                                                    '0.0'
                                                ? ''
                                                : '\n${priceByCountries[0]?.convRegularPrice}',
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.black54,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 20)),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                flex: 1,
                                child:
                                    SpinKitThreeBounce(color: Colors.redAccent),
                              ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "Available Now",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Screenshots
              Container(
                height: MediaQuery.of(context).size.height / 2,
                color: Color(int.parse(
                    '0xff${widget.dominantColors.isNotEmpty ? widget.dominantColors[2] : defaultColors[0]}')),
                child: ImagesScrollView(screenShots: widget.screenShots),
              ),

              // Game info
              gameInfo != null
                  ? (gameInfo?.publisher?.isNotEmpty ?? false)
                      ? gameInfoWidget(context, gameInfo, widget.ratingImageURL,
                          widget.descriptors)
                      : Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: CircularProgressIndicator(),
                        )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget gameInfoWidget(context, gameInfo, riURL, descrips) {
  var padding = 24;
  return Container(
    // padding: const EdgeInsets.only(top: 16),
    padding: const EdgeInsets.all(12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - padding,
              color: Colors.black12,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.today_outlined,
                    size: 30,
                  ),
                  Text.rich(
                    TextSpan(
                      text: '\tRelease date:\t\t\t\t\t\t',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      children: [
                        TextSpan(
                            text: gameInfo.dateRelease,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300))
                      ],
                    ),
                  ),
                ],
              ),
            ), // Release Date
            Container(
              width: MediaQuery.of(context).size.width - padding,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.group_outlined,
                    size: 30,
                  ),
                  Text.rich(
                    TextSpan(
                      text: '\tPlayers:\t\t\t\t\t\t',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      children: [
                        TextSpan(
                            text: gameInfo.numberOfPlayer,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300))
                      ],
                    ),
                  ),
                ],
              ),
            ), // Num of Player
            Container(
              width: MediaQuery.of(context).size.width - padding,
              color: Colors.black12,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.gamepad_outlined,
                    size: 30,
                  ),
                  Text.rich(
                    TextSpan(
                      text: '\tGenre:\t\t\t\t\t\t',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text(
                      gameInfo.genre,
                      overflow: TextOverflow.fade,
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ), // Genre
            Container(
              width: MediaQuery.of(context).size.width - padding,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 30,
                  ),
                  Text.rich(
                    TextSpan(
                      text: '\tPublisher:\t\t\t\t\t\t',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      children: [
                        TextSpan(
                            text: gameInfo.publisher,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300))
                      ],
                    ),
                  ),
                ],
              ),
            ), // Publisher

            Container(
              width: MediaQuery.of(context).size.width - padding,
              color: Colors.black12,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.table_rows_outlined,
                    size: 30,
                  ),
                  Text.rich(
                    TextSpan(
                      text: '\tGame File Size:\t\t\t\t\t\t',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      children: [
                        TextSpan(
                            text: gameInfo.gameFileSize,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300))
                      ],
                    ),
                  ),
                ],
              ),
            ), // Game File Size
            Container(
              width: MediaQuery.of(context).size.width - padding,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.language_outlined,
                        size: 30,
                      ),
                      Text(
                        '\tSupported Languages:\t\t\t\t\t\t',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 26,
                        ),
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: Text(
                          gameInfo.lang,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ), // Supported Language
            Container(
              width: MediaQuery.of(context).size.width - padding,
              color: Colors.black12,
              padding: const EdgeInsets.only(bottom: 16, top: 16, left: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          text: '\tSupported Play Modes:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3.5,
                          child: Column(
                            children: [
                              SvgPicture.network(
                                gameInfo?.spMode[0]?.item1,
                                fit: BoxFit.contain,
                              ),
                              Text(gameInfo?.spMode[0]?.item2),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3.5,
                          child: Column(
                            children: [
                              SvgPicture.network(
                                gameInfo?.spMode[1]?.item1,
                                fit: BoxFit.contain,
                              ),
                              Text(gameInfo?.spMode[1]?.item2),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3.5,
                          child: Column(
                            children: [
                              SvgPicture.network(
                                gameInfo?.spMode[2]?.item1,
                                fit: BoxFit.contain,
                              ),
                              Text(gameInfo?.spMode[2]?.item2),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ), // Supported Play Modes
            SizedBox(
              height: 18,
            ),
            Container(
                // height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width - padding,
                color: Colors.black12,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text.rich(
                          TextSpan(
                            text: '\tESRB Rating: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Image.network(
                              riURL ?? '',
                              width: 50,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            child: Text(
                              descrips.isEmpty
                                  ? ''
                                  : descrips.toString().substring(
                                      1, descrips.toString().length - 1),
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )), // ESRB Rating
            SizedBox(
              height: 18,
            ),

            gameInfo.nso.length == 0
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width - padding,
                    color: Colors.black12,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: '\tThis game supports: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            SvgPicture.asset(
                              'lib/assets/images/logo-nso.svg',
                              width: 100,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.red,
                              ),
                              child: Text.rich(
                                TextSpan(
                                  text: '\t${gameInfo.nso[0]}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      // backgroundColor: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            gameInfo.nso.length <= 1
                                ? Container()
                                : Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.red,
                                    ),
                                    child: Text.rich(
                                      TextSpan(
                                        text: '\t${gameInfo.nso[1]}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            // backgroundColor: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                      ],
                    )), // Nintendo Switch Online Services
          ],
        ),
      ],
    ),
  );
}

class ImagesScrollView extends StatefulWidget {
  final List<String> screenShots;

  ImagesScrollView({Key key, @required this.screenShots}) : super(key: key);

  @override
  _ImagesScrollViewState createState() => _ImagesScrollViewState();
}

class _ImagesScrollViewState extends State<ImagesScrollView> {
  final _controller = PageController(viewportFraction: 0.8);
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Row(
          children: <Widget>[
            Flexible(
              flex: 8,
              child: Container(
                height: MediaQuery.of(context).size.height / 2.5,
                child: new PageView.builder(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.screenShots.length,
                  onPageChanged: (index) {
                    setState(() {
                      _index = index;
                    });
                  },
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Hero(
                        tag: 'image-$index',
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImageView(
                                      index: index,
                                      imageUrl: widget.screenShots[index])),
                            );
                          },
                          child: Image.network(
                            widget.screenShots[index],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        Flexible(
          flex: 3,
          child: SmoothPageIndicator(
            controller: _controller,
            count: widget.screenShots.length,
            effect: ScrollingDotsEffect(
                spacing: 10,
                radius: 8.0,
                dotWidth: 50.0,
                activeDotScale: .5,
                activeDotColor: Colors.white),
          ),
        ),
      ]),
    );
  }
}

class ImageView extends StatelessWidget {
  final String imageUrl;
  final int index;
  const ImageView({Key key, @required this.index, this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            color: Colors.black87,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: InteractiveViewer(
                child: Image.network(imageUrl),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VideoPlayback extends StatefulWidget {
  VideoPlayback({Key key}) : super(key: key);

  @override
  _VideoPlaybackState createState() => _VideoPlaybackState();
}

class _VideoPlaybackState extends State<VideoPlayback> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Butterfly Video'),
        ),
        // Use a FutureBuilder to display a loading spinner while waiting for the
        // VideoPlayerController to finish initializing.
        body: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the VideoPlayerController has finished initialization, use
              // the data it provides to limit the aspect ratio of the video.
              return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                // Use the VideoPlayer widget to display the video.
                child: VideoPlayer(_controller),
              );
            } else {
              // If the VideoPlayerController is still initializing, show a
              // loading spinner.
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Wrap the play or pause in a call to `setState`. This ensures the
            // correct icon is shown.
            setState(() {
              // If the video is playing, pause it.
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                // If the video is paused, play it.
                _controller.play();
              }
            });
          },
          // Display the correct icon depending on the state of the player.
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
