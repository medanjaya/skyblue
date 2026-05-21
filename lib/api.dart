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
          'sign': sign.toString(),
          'partner_id': partner,
          'timestamp': time,
          'redirect': 'https://open.shopee.com',
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
        'sign': sign.toString(),
        'partner_id': partner,
        'timestamp': time,
        'redirect': 'https://open.shopee.com',
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
      
      final
      path = '/api/v2/auth/token/get',

      sign = hmac.convert(
        utf8.encode(partner + path + time),
      );
      
      http.post(
        Uri.https(
          host,
          path,
          {
            'partner_id': partner,
            'timestamp': time,
            'sign': sign.toString(),
          },
        ),
        body: jsonEncode(
          {
            'partner_id': partner,
            'code': Uri.parse(r).queryParameters['code'],
            'shop_id': Uri.parse(r).queryParameters['shop_id'],
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