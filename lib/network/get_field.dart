import 'package:snowscoop/models/ski-field.dart';

import 'package:http/http.dart' as http; // Contains a client for making API calls
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/sheets/v4.dart' as sheets;

class SheetsConnection {

  auth.AuthClient client;
  sheets.SheetsApi api; 

  // constructor
  // SheetsConnection(this.client, this.api);
  SheetsConnection();

  
  static const _SHEET_KEY = '18kc6EsRQuMGBw2JtIoTzeVNTTd0w2xAmWQ3cfHifmrI';

  Future connect() async {
    
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

    const _SCOPES = const [sheets.SheetsApi.SpreadsheetsScope];

    print('Attempting Google OAuth Connection...');
    try{
      await auth
        .obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(_key),
            _SCOPES,
            http.Client())
        .then((auth.AccessCredentials cred) {
          print('Connection Accepted');

          client = auth.authenticatedClient(http.Client(), cred);
          api = new sheets.SheetsApi(client);
          return;
        });
    } on Exception catch(e) {
      print(e.toString());
      print('Connection Refused');
      return;
    }
  }



  /// retreives all weather values and updates the model passed by reference
  Future<Field> getFieldWeather(Field field) async {
    List<String> ranges = [
      '${field.title}!B1:V1',
      '${field.title}!B2:V2',
      '${field.title}!B3:V3',
      '${field.title}!B4:V4',
      '${field.title}!B5:V5'
    ];

    print('Retreiving values');
    await api.spreadsheets.values
      .batchGet(_SHEET_KEY, ranges: ranges)
      .then((sheets.BatchGetValuesResponse r) {

        
        field.rain = _cleanValues(r.valueRanges[0]);
        field.snow = _cleanValues(r.valueRanges[1]);
        field.max =_cleanValues(r.valueRanges[2]);
        field.min =_cleanValues(r.valueRanges[3]);
        field.chill =_cleanValues(r.valueRanges[4]);

        print('Batched GET request completed');
      });

    return field;
  }

  /// Takes the response object and transforms to List<int>
  List<dynamic> _cleanValues(dynamic res) {
    List<dynamic> list = res.values[0]
      .toList()
      .map((val) => int.parse(val))
      .toList();

    return list;
  }

  void closeConnection(){
    print('Closing Connection');
    client.close();
  }

}