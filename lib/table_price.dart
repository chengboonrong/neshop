import 'package:currency_pickers/country.dart';
import 'package:currency_pickers/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neshop/utils/game.dart';

class TablePricePage extends StatefulWidget {
  final String gameID;
  final String gameTitle;
  final Price gamePrice;
  final Country countrySettings;
  final List<Price> prices;

  TablePricePage(
      {@required this.gameID,
      @required this.gameTitle,
      @required this.gamePrice,
      @required this.countrySettings,
      @required this.prices});

  @override
  _TablePricePageState createState() => _TablePricePageState();
}

class _TablePricePageState extends State<TablePricePage> {
  List<Country> countries = [
    CurrencyPickerUtils.getCountryByIsoCode("US"),
    CurrencyPickerUtils.getCountryByIsoCode("GB"),
    CurrencyPickerUtils.getCountryByIsoCode("CA"),
    CurrencyPickerUtils.getCountryByIsoCode("AU"),
    CurrencyPickerUtils.getCountryByIsoCode("NZ"),
    CurrencyPickerUtils.getCountryByIsoCode("CZ"),
    CurrencyPickerUtils.getCountryByIsoCode("DK"),
    CurrencyPickerUtils.getCountryByIsoCode("FI"),
    CurrencyPickerUtils.getCountryByIsoCode("GR"),
    CurrencyPickerUtils.getCountryByIsoCode("HU"),
    CurrencyPickerUtils.getCountryByIsoCode("NO"),
    CurrencyPickerUtils.getCountryByIsoCode("PL"),
    CurrencyPickerUtils.getCountryByIsoCode("ZA"),
    CurrencyPickerUtils.getCountryByIsoCode("SE"),
  ];

  List<Price> allPrices = List<Price>();

  @override
  void initState() {
    super.initState();
    print(widget.prices.length);
  }

  TableRow _tableRow(Country _country, Price _price, Country _countrySettings) {
    return TableRow(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Row(children: [
              Container(
                height: 25,
                width: 40,
                child: CurrencyPickerUtils.getDefaultFlagImage(_country),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '${_country.iso3Code}',
                textScaleFactor: 1.2,
              ),
            ]),
          ),
          Expanded(
            flex: 4,
            child: _price.discountPrice != '0.0'
                ? Column(
                    children: [
                      Text(
                        '${_price.discountPrice}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '${_price.regularPrice}',
                        style: TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${_price.regularPrice}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
          ),
          Expanded(
            flex: 4,
            child: _price.discountPrice != '0.0'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${_countrySettings.currencyCode} ${_price.convDiscountPrice}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '${_countrySettings.currencyCode} ${_price.convRegularPrice}',
                        style: TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  )
                : Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(
                      '${_price.convRegularPrice}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ]),
          ),
        ],
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("Game Title"),
        backgroundColor: Colors.white,
      ),
      body: widget.prices.length == 0
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Container(
                color: Colors.white10,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Table(
                            children: [
                              TableRow(children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Countries",
                                      textScaleFactor: 1.2,
                                    ),
                                    Text('Local Price', textScaleFactor: 1.2),
                                    Text('Your Price', textScaleFactor: 1.2),
                                  ],
                                ),
                              ]),
                              TableRow(children: [
                                SizedBox(
                                  height: 12,
                                ),
                              ]),
                              _tableRow(countries[0], widget.prices[0],
                                  widget.countrySettings),
                              TableRow(children: [
                                SizedBox(
                                  height: 12,
                                ),
                              ]),
                              _tableRow(countries[1], widget.prices[1],
                                  widget.countrySettings),
                              TableRow(children: [
                                SizedBox(
                                  height: 12,
                                ),
                              ]),
                              _tableRow(countries[2], widget.prices[2],
                                  widget.countrySettings),
                              TableRow(children: [
                                SizedBox(
                                  height: 12,
                                ),
                              ]),
                              _tableRow(countries[3], widget.prices[3],
                                  widget.countrySettings),
                              TableRow(children: [
                                SizedBox(
                                  height: 12,
                                ),
                              ]),
                              _tableRow(countries[4], widget.prices[4],
                                  widget.countrySettings),
                              TableRow(children: [
                                SizedBox(
                                  height: 12,
                                ),
                              ]),
                              _tableRow(countries[5], widget.prices[5],
                                  widget.countrySettings),
                              TableRow(children: [
                                SizedBox(
                                  height: 12,
                                ),
                              ]),
                              _tableRow(countries[6], widget.prices[6],
                                  widget.countrySettings),
                              TableRow(children: [
                                SizedBox(
                                  height: 12,
                                ),
                              ]),
                              _tableRow(countries[7], widget.prices[7],
                                  widget.countrySettings),
                              TableRow(children: [
                                SizedBox(
                                  height: 12,
                                ),
                              ]),
                              _tableRow(countries[8], widget.prices[8],
                                  widget.countrySettings),
                              TableRow(children: [
                                SizedBox(
                                  height: 12,
                                ),
                              ]),
                              _tableRow(countries[9], widget.prices[9],
                                  widget.countrySettings),
                              TableRow(children: [
                                SizedBox(
                                  height: 12,
                                ),
                              ]),
                              _tableRow(countries[10], widget.prices[10],
                                  widget.countrySettings),
                              TableRow(children: [
                                SizedBox(
                                  height: 12,
                                ),
                              ]),
                              _tableRow(countries[11], widget.prices[11],
                                  widget.countrySettings),
                              TableRow(children: [
                                SizedBox(
                                  height: 12,
                                ),
                              ]),
                              _tableRow(countries[12], widget.prices[12],
                                  widget.countrySettings),
                              TableRow(children: [
                                SizedBox(
                                  height: 12,
                                ),
                              ]),
                              _tableRow(countries[13], widget.prices[13],
                                  widget.countrySettings),
                              TableRow(children: [
                                SizedBox(
                                  height: 28,
                                ),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
