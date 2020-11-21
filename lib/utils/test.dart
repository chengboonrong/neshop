// CountryListPick(
//                 appBar: AppBar(
//                   elevation: 0,
//                   backgroundColor: Colors.white,
//                   toolbarHeight: 0,
//                   toolbarOpacity: 0,
//                   leadingWidth: 0,
//                 ),
//                 // if you need custome picker use this
//                 pickerBuilder: (context, CountryCode countryCode) {
//                   return Container(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 20, horizontal: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Currency'),
//                         Container(
//                           // margin: const EdgeInsets.only(right: 10),
//                           child: Row(children: [
//                             Image.asset(
//                               countryCode.flagUri,
//                               width: 20,
//                               package: 'country_list_pick',
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text(countryCode.code),
//                             // Text(countryCode.dialCode),
//                           ]),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//                 theme: CountryTheme(
//                   isShowFlag: true,
//                   isShowTitle: true,
//                   isShowCode: true,
//                   isDownIcon: true,
//                   showEnglishName: true,
//                 ),
//                 initialSelection: '+60',
//                 onChanged: (CountryCode code) {
//                   // print(code.name);
//                   // print(code.code);
//                   // print(code.dialCode);
//                   // print(code.flagUri);
//                 },
//               ),
