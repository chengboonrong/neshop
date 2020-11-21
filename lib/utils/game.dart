import 'package:tuple/tuple.dart';

class Game {
  String gameID;
  String formalName;
  String heroBannerUrl;
  List<String> dominantColors;
  List<String> screenshots;
  String ratingImageURL;
  List<String> descriptors;

  Game(
      {this.gameID,
      this.formalName,
      this.heroBannerUrl,
      this.dominantColors,
      this.screenshots,
      this.ratingImageURL,
      this.descriptors});
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

  GameInfo(
      {this.videoID,
      this.dateRelease,
      this.numberOfPlayer,
      this.genre,
      this.publisher,
      this.gameFileSize,
      this.lang,
      this.spMode,
      this.nso});
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
