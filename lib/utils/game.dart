import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class Game {
  String gameID;
  String formalName;
  // String heroBannerUrl;
  Image heroImage;
  List<String> dominantColors;
  List<String> screenshots;
  String ratingImageURL;
  List<String> descriptors;
  String releaseDate;

  Game(
      {this.gameID,
      this.formalName,
      // this.heroBannerUrl,
      this.heroImage,
      this.dominantColors,
      this.screenshots,
      this.ratingImageURL,
      this.descriptors,
      this.releaseDate});
}

class GameInfo {
  String videoID;
  String dateRelease;
  String numberOfPlayer;
  String genre;
  // String developer;
  String publisher;
  String gameFileSize;
  String lang;
  List<Tuple2> spMode;
  List<String> nso;
  String price;

  GameInfo(
      {this.videoID,
      this.dateRelease,
      this.numberOfPlayer,
      this.genre,
      this.publisher,
      this.gameFileSize,
      this.lang,
      this.spMode,
      this.nso,
      this.price});
}

class Price {
  String regularPrice;
  String discountPrice;
  String convRegularPrice;
  String convDiscountPrice;

  Price(
      {this.regularPrice,
      this.discountPrice,
      this.convRegularPrice,
      this.convDiscountPrice});
}
