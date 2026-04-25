import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

final String host = 'openplatform.sandbox.test-stable.shopee.sg';

Future<void> authPartner() async {
  final
  partner = '1201347',
  path = '/api/v2/shop/auth_partner',
  time = '${DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond}',
  
  hmac = Hmac(
    sha256,
    base64Decode('c2hwazU2NjI0NzQ5NzM3OTZmNTc3NDU0NDU1MTc4NmE2YTZkNDg2ODc0NTI1MzYyNzc2ZDY2NjI2MjQyNjc3NA=='),
  ),

  sign = hmac.convert(
    utf8.encode(partner + path + time),
  );

  print(
    'linknya: ${
      Uri.https(
        host,
        path,
        {
          'partner_id': partner,
          'redirect': 'https://open.shopee.com',
          'timestamp': time,
          'sign': sign.toString(),
        },
      ).toString()
    }',
  );
  
  //FIXME jika di tab auth ada bar putih di atas, ubah titleBarHeight ke 0 di webview.dart;
  // cari di direct dependencies flutter_web_auth_2
  FlutterWebAuth2.authenticate(
    url: Uri.https(
      host,
      path,
      {
        'partner_id': partner,
        'redirect': 'https://open.shopee.com',
        'timestamp': time,
        'sign': sign.toString(),
      },
    ).toString(),
    callbackUrlScheme: 'https',
    options: const FlutterWebAuth2Options(
      httpsHost: 'open.shopee.com',
    ),
  )
  .then(
    (r) {
      print('hasil url: $r');
      print('hasil code: ${Uri.parse(r).queryParameters['code']}');

      http.post(
        Uri.https(
          host,
          '/api/v2/auth/token/get',
          {
            'code': Uri.parse(r).queryParameters['code'],
            'partner_id': partner,
          },
        ),
      )
      .then(
        (r) {
          print('hasil token: ${r.body}');
        },
      );
    },
  );
}