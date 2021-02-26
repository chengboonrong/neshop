// import 'package:country_pickers/country_pickers.dart';
// import 'package:country_pickers/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:currency_pickers/country.dart';
import 'package:currency_pickers/currency_pickers.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getCurrency() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('currency');
}

Future<String> getCountryCode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('country');
}

Future<void> setCurrency(Country c) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('country', c.isoCode);
  prefs.setString('currency', c.currencyCode);
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Settings(),
    );
  }
}

class Settings extends StatefulWidget {
  // final MySettings settings;
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int selectedValue;
  String version = '';
  bool _value = false;
  Country _selectedCountry = CurrencyPickerUtils.getCountryByIsoCode('US');

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      // String appName = packageInfo.appName;
      // String packageName = packageInfo.packageName;
      // String buildNumber = packageInfo.buildNumber;
      setState(() {
        version = packageInfo.version;
        print('Version: $version');
      });
    });

    getCountryCode().then((code) {
      setState(() {
        _selectedCountry = CurrencyPickerUtils.getCountryByIsoCode(code);
      });
    });
  }

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CurrencyPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Text("${country.currencyCode}"),
          SizedBox(width: 8.0),
          Flexible(child: Text(country.name))
        ],
      );

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: CurrencyPickerDialog(
              titlePadding: EdgeInsets.all(8.0),
              searchCursorColor: Colors.pinkAccent,
              searchInputDecoration: InputDecoration(hintText: 'Search...'),
              isSearchable: true,
              title: Text('Select your country'),
              onValuePicked: (Country country) {
                setState(() => _selectedCountry = country);
                setCurrency(country);
                Navigator.pop(context);
              },
              itemBuilder: _buildDialogItem,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings_outlined),
            Text("\tSettings"),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            // Change default currency
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Change Default Currency',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        CurrencyPickerUtils.getDefaultFlagImage(
                            _selectedCountry),
                        SizedBox(width: 8.0),
                        Text("${_selectedCountry.currencyCode}"),
                        IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                            onPressed: () {
                              _openCountryPickerDialog();
                            }),
                      ],
                    )
                  ]),
            ),
            Container(
              height: 2,
              width: MediaQuery.of(context).size.width,
              color: Colors.black12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Dark Mode',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Switch(
                    inactiveThumbColor: Colors.black,
                    inactiveTrackColor: Colors.black38,
                    activeColor: Colors.white,
                    value: _value,
                    onChanged: (bool value) {
                      setState(() {
                        _value = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 2,
              width: MediaQuery.of(context).size.width,
              color: Colors.black12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'version v$version',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            // Container(
            //   height: 2,
            //   width: MediaQuery.of(context).size.width,
            //   color: Colors.black12,
            // ),
          ],
        ),
      ),
    );
  }
}

class MySettings {
  String countryCode;
  String currencyCode;

  MySettings({this.countryCode, this.currencyCode});
}
