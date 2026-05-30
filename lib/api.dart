import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

final String host = 'openplatform.sandbox.test-stable.shopee.sg';

Future<void> authPartner() async {
  final
  prefs = await SharedPreferences.getInstance(),

  partner = prefs.getString('partner') ?? '',
  secret = prefs.getString('secret') ?? '',

  path = '/api/v2/shop/auth_partner',
  time = '${DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond}',
  
  hmac = Hmac(sha256, base64Decode(secret)),
  sign = hmac.convert(utf8.encode(partner + path + time));

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
      final
      path = '/api/v2/auth/token/get',
      sign = hmac.convert(utf8.encode(partner + path + time));
      
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
          final result = jsonDecode(r.body);

          prefs.setString('token', result['access_token']);
          prefs.setString('refresh', result['refresh_token']);
        },
      );
    },
  );
}