import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:neshop/utils/game.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

// Future<void> fetchTest() async {
//   // String uri = 'https://www.nintendo.com/pos-redirect/70010000015880?a=gdp';
//   String uri =
//       'https://graph.nintendo.com/?operationName=GetGameByNsuidForPosRedirect&variables={"nsuid":"70010000022435","locale":"en-US"}&extensions={"persistedQuery":{"version":1,"sha256Hash":"070b5ce2d75804dfde87bbd842aa4549043f0959a047a5e123f2a677e8f9c0b3"}}';
//   var _response = await http.get(uri);
//   var document = json.decode(_response.body);
//   print(document['data']['game']['detail_page']);
// }

Future<double> currencyConvert(fromCurrency, toCurrency) async {
  String uri =
      "https://api.exchangeratesapi.io/latest?base=$fromCurrency&symbols=$toCurrency";

  var response = await http
      .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
  var responseBody = json.decode(response.body);
  // print(responseBody['rates'][toCurrency]);
  if (responseBody['rates'] == null) {
    return -1.0;
  } else {
    return responseBody["rates"][toCurrency];
  }
}

// Future<List<Game>> fetchDealsGameList() async {
//   var _gameList = List<Game>();
//   var count = 30;
//   var offset = 0;

//   var url =
//       'https://ec.nintendo.com/api/US/en/search/sales?count=$count&offset=$offset'; //Discount Game list
//   var response = await http.get(
//     url,
//     headers: {'Content-type': 'application/json; charset=UTF-8'},
//   );
//   // var list = jsonDecode(response.body)['contents'];
//   var list = jsonDecode(utf8.decode(response.bodyBytes))['contents'];

//   list.forEach((game) async {
//     /////////// format game title to url
//     var temp = [];

//     game['formal_name']
//         .toString()
//         .toLowerCase()
//         .replaceAll(new RegExp(r'[^\w\s]+'), ' ')
//         .split(" ")
//         .forEach((element) {
//       if (element != '') temp.add(element.trim());
//     });

//     /////////////////////////////////////////

//     var _formatedName = temp.join("-").replaceAll("--", '-');

//     var ss = List<String>();
//     game['screenshots'].forEach((image) {
//       ss.add(image['images'][0]['url']);
//     });

//     var clrs = List<String>();
//     game['dominant_colors'].forEach((c) {
//       clrs.add(c);
//     });

//     var ratingImageURL = game['rating_info']['rating']['image_url'];
//     // print(ratingImageURL);

//     _gameList.add(
//       Game(
//         gameID: game['id'].toString(),
//         formalName: game['formal_name'],
//         formatedGameName: _formatedName,
//         heroBannerUrl: game['hero_banner_url'],
//         dominantColors: clrs,
//         screenshots: ss,
//       ),
//     );
//   });

//   // print(_gameList.length);
//   print('Deals: Loaded');

//   _gameList.sort((a, b) {
//     return a.formalName
//         .toString()
//         .toLowerCase()
//         .compareTo(b.formalName.toString().toLowerCase());
//   });

//   return _gameList;
// }

Future<List<Game>> fetchGameList(type) async {
  var _gameList = List<Game>();
  var count = 30;
  var offset = 0;

  var url =
      'https://ec.nintendo.com/api/US/en/search/$type?count=$count&offset=$offset'; //Discount Game list
  var response = await http.get(
    url,
    headers: {'Content-type': 'application/json; charset=UTF-8'},
  );
  // var list = jsonDecode(response.body)['contents'];
  var list = jsonDecode(utf8.decode(response.bodyBytes))['contents'];
  // print(list);

  list.forEach((game) async {
    var ss = List<String>();
    game['screenshots'].forEach((image) {
      ss.add(image['images'][0]['url']);
    });

    var clrs = List<String>();
    game['dominant_colors'].forEach((c) {
      clrs.add(c);
    });

    var ratingImageURL = game['rating_info']['rating']['image_url'];
    // print(ratingImageURL);

    var descriptors = List<String>();
    game['rating_info']['content_descriptors'].forEach((d) {
      descriptors.add(d['name']);
    });

    var releaseDate = game['release_date_on_eshop'];

    _gameList.add(
      Game(
        gameID: game['id'].toString(),
        formalName: game['formal_name'],
        // heroBannerUrl: game['hero_banner_url'],
        heroImage: Image.network(
          game['hero_banner_url'],
          fit: BoxFit.fitWidth,
          frameBuilder: (BuildContext context, Widget child, int frame,
                  bool wasSynchronouslyLoaded) =>
              wasSynchronouslyLoaded
                  ? child
                  : AnimatedOpacity(
                      child: child,
                      opacity: frame == null ? 0 : 1,
                      duration: const Duration(seconds: 2),
                      curve: Curves.easeOut,
                    ),
          loadingBuilder: (context, child, progress) => progress == null
              ? child
              : Center(
                  child: LinearProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),
                ),
          errorBuilder:
              (BuildContext context, Object exception, StackTrace stackTrace) =>
                  Text('Failed to load image'),
        ),
        dominantColors: clrs,
        screenshots: ss,
        ratingImageURL: ratingImageURL,
        descriptors: descriptors,
        releaseDate: releaseDate,
      ),
    );
  });

  // print(_gameList.length);
  print('Loaded');

  _gameList.sort((a, b) {
    return a.formalName
        .toString()
        .toLowerCase()
        .compareTo(b.formalName.toString().toLowerCase());
  });

  return _gameList;
}

Future<String> fetchPrice(uid) async {
  var redirectUrL =
      'https://graph.nintendo.com/?operationName=GetGameByNsuidForPosRedirect&variables={"nsuid":"$uid","locale":"en-US"}&extensions={"persistedQuery":{"version":1,"sha256Hash":"070b5ce2d75804dfde87bbd842aa4549043f0959a047a5e123f2a677e8f9c0b3"}}';
  var _response = await http.get(redirectUrL);

  /////// If that is not a game but something like a DLC //////////////////////
  if (json.decode(_response.body)['data']['game'] == null) return null;
  ////////////////////////////////////////////////////////////////////////////

  var gameDetailURL = json.decode(_response.body)['data']['game']['detailPage'];
  var document;
  await http.get(Uri.parse(gameDetailURL)).then((resp) {
    document = parse(resp.body);
  });

  final _price = document
      .getElementsByClassName('price')
      .first
      .children
      .last
      .innerHtml
      .trim();

  return _price;
}

Future<GameInfo> fetchGameInfo(uid) async {
  var _gameInfo = GameInfo();

  var redirectUrL =
      'https://graph.nintendo.com/?operationName=GetGameByNsuidForPosRedirect&variables={"nsuid":"$uid","locale":"en-US"}&extensions={"persistedQuery":{"version":1,"sha256Hash":"070b5ce2d75804dfde87bbd842aa4549043f0959a047a5e123f2a677e8f9c0b3"}}';
  var _response = await http.get(redirectUrL);

  /////// If that is not a game but something like a DLC //////////////////////
  if (json.decode(_response.body)['data']['game'] == null) return null;
  ////////////////////////////////////////////////////////////////////////////

  var gameDetailURL = json.decode(_response.body)['data']['game']['detailPage'];
  var document;
  await http.get(Uri.parse(gameDetailURL)).then((resp) {
    document = parse(resp.body);
  });

  final _price = document
      .getElementsByClassName('price')
      .first
      .children
      .last
      .innerHtml
      .trim();

  final rd = document.getElementsByClassName('release-date').first.text;
  final ply = document.getElementsByClassName('players').first.text;
  final g = document.getElementsByClassName('genre').first.text;
  final fs = document.getElementsByClassName('file-size').first.text;
  final sl = document.getElementsByClassName('supported-languages').first.text;

  final spMode = List<Tuple2>();
  document.getElementsByClassName('playmode').forEach((element) {
    var svgURL =
        'https://www.nintendo.com${element.children.first.children.first.attributes['src']}';
    var text = element.text.trim();
    spMode.add(Tuple2<String, String>(svgURL, text));
  });

  // print(spMode);

  final nso = List<String>();
  document
      .getElementsByClassName('services-supported')
      .first
      .children
      .forEach((element) {
    nso.add(element.text.trim());
  });
  // print(nso);

  var _videoID = document
      ?.getElementsByClassName('carousel')
      ?.first
      ?.children[0]
      ?.children[0]
      ?.attributes['video-id'];

  print('fetching : $_videoID');

  var noP = false;

  ///// Check if Publisher existed.
  try {
    var d = document.getElementsByClassName('publisher').first.text;
    // print(d);
  } catch (e) {
    // print(detailUrl);
    // print(e);

    noP = true;
  }
  /////

  final p = noP ? ' ' : document.getElementsByClassName('publisher').first.text;

  _gameInfo = GameInfo(
    videoID: _videoID,
    dateRelease: rd.split(':')[1].trim() ?? '',
    numberOfPlayer: ply.split(':')[1].trim() ?? '',
    genre: g
            .split(':')[1]
            .trim()
            .split("                        ")
            .join('')
            .split('\n')
            .join('')
            .split('                     ')
            .join(' ') ??
        '',
    publisher: noP ? ' ' : p.split(':')[1].trim() ?? '',
    gameFileSize: fs.split(':')[1].trim() ?? '',
    lang: sl.split(':')[1].trim() ?? '',
    spMode: spMode,
    nso: nso,
    price: _price,
  );

  return _gameInfo;
}

Future<Price> fetchGamePrice(gameID, toCurrency, country) async {
  var priceUrl =
      'https://api.ec.nintendo.com/v1/price?country=$country&ids=$gameID&lang=en';

  // print(priceUrl);

  var _response = await http.get(priceUrl);
  var document = await jsonDecode(utf8.decode(_response.bodyBytes));

  var price = Price();

  var fromCurrency;
  if (document['prices'][0]['sales_status'] == 'onsale') {
    fromCurrency = document['prices'][0]['regular_price']['currency'];
    // print(document);

    var rp, dp, crp, cdp;

    await currencyConvert(fromCurrency, toCurrency).then((rate) {
      rp = document['prices'][0]['regular_price']['amount'];
      if (document['prices'][0]['discount_price'] != null) {
        dp = document['prices'][0]['discount_price']['amount'];
        cdp = (rate *
                double.parse(
                    document['prices'][0]['discount_price']['raw_value']))
            .toStringAsFixed(2);
      } else {
        dp = '0.0';
        cdp = '0.0';
      }

      crp = (rate *
              double.parse(document['prices'][0]['regular_price']['raw_value']))
          .toStringAsFixed(2);

      rate < 0
          ? price = Price(
              regularPrice: '0.0',
              discountPrice: '0.0',
              convRegularPrice: '0.0',
              convDiscountPrice: '0.0')
          : price = Price(
              regularPrice: rp,
              discountPrice: dp,
              convRegularPrice: crp,
              convDiscountPrice: cdp);
    });
  } else if (document['prices'][0]['sales_status'] == 'unreleased') {
    price = Price(
        regularPrice: document['prices'][0]['sales_status'],
        discountPrice: '0.0',
        convRegularPrice: document['prices'][0]['sales_status'],
        convDiscountPrice: '0.0');
  } else {
    price = Price(
        regularPrice: document['prices'][0]['sales_status'],
        discountPrice: '0.0',
        convRegularPrice: document['prices'][0]['sales_status'],
        convDiscountPrice: '0.0');

    // var priceUrl =
    //     'https://api.ec.nintendo.com/v1/price?country=$country&ids=${int.parse(gameID) + 2}&lang=en';

    // print(priceUrl);

    // var _response = await http.get(priceUrl);
    // var document = await jsonDecode(utf8.decode(_response.bodyBytes));

    // print(document);

    // fromCurrency = document['prices'][0]['regular_price']['currency'];

    // await currencyConvert(fromCurrency, toCurrency).then((rate) {
    //   rate < 0
    //       ? price = Price(
    //           regularPrice: '0.0',
    //           discountPrice: '0.0',
    //           convRegularPrice: 0.0,
    //           convDiscountPrice: 0.0)
    //       : price = Price(
    //           regularPrice: document['prices'][0]['regular_price']['amount'],
    //           discountPrice: document['prices'][0]['discount_price'] == null
    //               ? '0.0'
    //               : document['prices'][0]['discount_price']['amount'],
    //           convRegularPrice: rate *
    //               double.parse(
    //                   document['prices'][0]['regular_price']['raw_value']),
    //           convDiscountPrice: document['prices'][0]['discount_price'] == null
    //               ? 0.0
    //               : rate *
    //                   double.parse(
    //                       document['prices'][0]['discount_price']['raw_value']),
    //         );
    // });
  }

  // print(price.discountPrice);

  return price;
}

Future<List<Price>> fetchGameAllPrice(gameID, toCurrency) async {
  var countries = [
    "US",
    "GB",
    "CA",
    "AU",
    "NZ",
    "CZ",
    "DK",
    "FI",
    "GR",
    "HU",
    "NO",
    "PL",
    "ZA",
    "SE"
  ];

  var priceList = List<Price>();

  for (int i = 0; i < countries.length; i++) {
    // print(countries[i]);
    var _gameID = int.parse(gameID);
    countries[i] == 'CA' || countries[i] == 'US' ? _gameID -= 0 : _gameID -= 1;

    await fetchGamePrice(_gameID.toString(), toCurrency, countries[i])
        .then((value) {
      priceList.add(value);
      // print(value);
    });
  }
  return priceList;
}
