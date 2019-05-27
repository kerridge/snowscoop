import 'package:flutter/material.dart';

import 'package:snowscoop/views/home.dart';
import 'package:snowscoop/util/scrape-field.dart' as scraper;
// enum for current button
import 'package:snowscoop/models/enums/current-weather.dart';
import 'package:snowscoop/models/ski-field.dart';

import 'package:http/http.dart' as http; // Contains a client for making API calls
import 'package:googleapis/storage/v1.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/sheets/v4.dart';


class Home extends StatefulWidget {
  @override
  HomeView createState() => new HomeView();
}

abstract class HomeState extends State<Home> {
  // TEMP VAL
  @protected
  List<int> weather = new List(20);
  bool scraping = true;

  var selected = SelectedButton.SNOW;

  // array of ski fields
  Map<String, dynamic> fieldsByRegion = new Map();

  @override
  void initState() {
    super.initState();

    // // initialize data arrays
    // for (int i = 0; i < 20; i++) {
    //   weather[i] = 0;
    // }

    // // init fields
    // _initFields();

    // // _scrapeField("SNOW");
    // _scrapeRegion("SNOW", 'Otago');


    final _key = {
      "type": "service_account",
      "project_id": "snowscoop",
      "private_key_id": "1dd6e41ba2a93b78d2f14a67fb1b838124a063b8",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCgvl4B1UDj77sD\nYgNztM9W9B4sIxO0h1cS5uRpJQ34HR3/tek75MJzcyUFj9uOM0Q0rfESzwx/Xdd8\nscH2gKoTmwVxOnQcuSVzajopIAZL6CRj8YHlKrR27gPNxjmPeroRUvs+4c930514\nadoftMISywB7zV4jZvIOFwUu7BBgofUZy5+DQk83Jmdzks4XCTwuPS3G5PckLQ/I\nr+PNeki6ZdN+G/TuaTUo/5OvgzyVICHWyZ1HLZMG8+UBIav4Ui5/nzBZla9xPkMv\nDwdcO1X+VDWopgtqc416u1O1QlgTPScXC2luqznsOwm9AywDY5rhtDvh7EvdywSF\nag3R0WwBAgMBAAECggEABW/Vl35HtENMMgXDVCCOJW9wWHx/PXXubgc9O96IUGy7\nslshc73TDeXxH0pfBLpF2PpL0x+0WS0quAmoeSv06guDmEbVMpDYlsTFtCpkdst3\n9PbFi/jGeIH9wvICHxDpm427oxmEKOtmwhyNHNFtAbG4Ec0/x+Ftgn3TgQ4e/QWv\nnh5bfW61g21EtF8YaeLB7NdLtrIzNTB+4mM/N3b/LNzSpy/aqN6tFQHGFaAmBTNZ\nAoy6XmOLC6vGvQASZFJRDJJiYp+4AvDgriZkGs8iFixH5VpSLJwoVVu4BnArPMFi\n546qq600jngeK+4NyvFT+HxXyTu5UZ+L0unFS3aRoQKBgQDPToTi6xACbxmxoKnh\n1WOpxGxqi19F/8DEbI0N1y2iGkTM3QSSFXWq6etOMLOP/Sug4+XwPI2VnssIV/62\nZ8T3je/8uaB+CoGW+APQBWISGOGdWC9lidPtmftLcpJ296mBvDozyb0Lgwg6twMT\nprQOfRi5W5AH+twzIve8CrtKTQKBgQDGf/sFdCQZ36xM7Lm2ereIc2AitEGkRy5O\nkY2/Pn5kHsgnz9gds5wVBgGDY8KMo87Uf1qZqhYpYiLi4mcDiCeUipRzpKRudQgr\nSbTNGuHwXNIOxWPW5CB6XIxJm+YemE89JuWWE4GEmmVRmOBAl00zVY7GU8GGBXrG\n8AFsqNgahQKBgQC2uBpgd5cwzgPzkAysRI0HgV2duyJKbFXXy2W4IUTTcBvcBaKV\nr9x6vJrt2/conpjpwnVU/co9aizCOe0DkQsGt1AjjOlsro3yJsAVheke0ldpe+Sq\ntoTZE7NumJmHylrZQrJ6GwJJN0D1n4FSvMhPTOuR1KZqoi2b1OJOF5dksQKBgA3v\nhDcAzVwHqPgJkowuF158Ax7MmuMmoCih7Vqkz4jF5HVvERQcvPN45XhM86aeBXJD\nsp+hIkcrfZmCHYtQ7r5t8DgiMe0TSEyJsyjHH1+ZlKG21+iJQYJ1pt+wEzrIpJ99\ncJbVrb0afcx5uBywwpm9AvYHgUmgbtsylFcFj45lAoGBALWnTrrmzHcZcmg8MsQH\nL/CbZs+6af+6qxnQ7xmG54sSh0qqZHtINh835vnwIw+a7cJ15kjTaTdk+lp1oKHH\nzINuy2bJbNY5usxG8kLvTEnneOstn+JCwkCDglaBdudlgQa/YJr57LpxCXz0f4qR\n+6qOYXZFMIXGdu6Cr37kG1pV\n-----END PRIVATE KEY-----\n",
      "client_email": "cli-admin@snowscoop.iam.gserviceaccount.com",
      "client_id": "105036322933539885349",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/cli-admin%40snowscoop.iam.gserviceaccount.com"
    };

    const _SCOPES = const [
      // SpreadsheetsResourceApi,
      SheetsApi.SpreadsheetsScope
    ];
    
    const spreadsheet_key = '18kc6EsRQuMGBw2JtIoTzeVNTTd0w2xAmWQ3cfHifmrI';

    // auth.clientViaServiceAccount(_key, _SCOPES).then((client) {

    print('getting oauth');
    auth
      .obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(_key),
          _SCOPES,
          http.Client())
      .then((auth.AccessCredentials cred) {
        print('got oauth');

        auth.AuthClient client = auth.authenticatedClient(http.Client(), cred);
        SheetsApi api = new SheetsApi(client);
        ValueRange vr = new ValueRange.fromJson({
          "values": [
            [ // fields A - J
              "15/02/2019", "via API 3", "5", "3", "3", "3", "3", "3", "3", "3"
            ]
          ]
      });

    print('about to append');
    api.spreadsheets.values
        .append(vr, spreadsheet_key, 'A:J',
            valueInputOption: 'USER_ENTERED')
        .then((AppendValuesResponse r) {
      print('append completed.');
      client.close();
    });
      print('called append()');
    });
    print('ended?');

  }

//   // Key for service account copied from downloaded file for demo purposes ;-)
// final _key = {
//   "type": "service_account",
//   "project_id": //etc
//   // ...
//   // ...
// };

// print('getting oauth');
// auth
//     .obtainAccessCredentialsViaServiceAccount(
//         auth.ServiceAccountCredentials.fromJson(_key),
//         scopes,
//         http.Client())
//     .then((auth.AccessCredentials cred) {
//   print('got oauth');

//   auth.AuthClient client = auth.authenticatedClient(http.Client(), cred);
//   SheetsApi api = new SheetsApi(client);
//   ValueRange vr = new ValueRange.fromJson({
//     "values": [
//       [ // fields A - J
//         "15/02/2019", "via API 3", "5", "3", "3", "3", "3", "3", "3", "3"
//       ]
//     ]
//   });
//   print('about to append');
//   api.spreadsheets.values
//       .append(vr, '1cl...spreadsheet_key...W5E', 'A:J',
//           valueInputOption: 'USER_ENTERED')
//       .then((AppendValuesResponse r) {
//     print('append completed.');
//     client.close();
//   });
//   print('called append()');
// });
// print('ended?');
// }






  void _scrapeField(String scrapeQuery) async {
    setState (() => scraping = true);

    weather = await scraper.initiate(scrapeQuery, fieldsByRegion['Otago'][0]);

    setState (() => scraping = false);
  }

  void _scrapeRegion(String weatherType, String region) async {
    for (var i = 0; i < fieldsByRegion[region].length; i++) {

      fieldsByRegion[region][i].weather[weatherType] = 
      await scraper.initiate(
        weatherType,
        fieldsByRegion[region][i]
      );

    }
  }

  /// initializing
  void _initFields() {
    List<Field> otago = [
      new Field('Cardrona', 'https://www.snow-forecast.com/resorts/Cardrona/6day/mid'),
      new Field('Coronet Peak', 'https://www.snow-forecast.com/resorts/Coronet-Peak/6day/mid'),
    ];

    fieldsByRegion.putIfAbsent('Otago', () => otago);
      
  }

  /// switches the selected button and displays new data
  @protected
  void switchButton(String title) {
    switch (title) {
      case "SNOW":
        _scrapeField(title);
        setState(() => selected =SelectedButton.SNOW);
        break;
      case "RAIN":
        _scrapeField(title);
        setState(() => selected =SelectedButton.RAIN);
        break;
      case "WIND":
        setState(() => selected =SelectedButton.WIND);
        break;
      case "MIN":
        setState(() => selected =SelectedButton.MIN);
        break;
      case "MAX":
        setState(() => selected =SelectedButton.MAX);
        break;
      default:
        break;
    }
  }
}