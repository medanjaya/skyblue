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
          'sign': sign,
        },
      ).toString()
    }',
  );
  
  FlutterWebAuth2.authenticate(
    url: Uri.https(
      host,
      path,
      {
        'partner_id': partner,
        'redirect': 'https://open.shopee.com',
        'timestamp': time,
        'sign': sign,
      },
    ).toString(),
    callbackUrlScheme: 'https',
    options: const FlutterWebAuth2Options(
      preferEphemeral: true,
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


/* void getAccessToken() {
  final
  partner = '1201347',
  path = '/api/v2/auth/token/get',
  time = '${DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond}',
  base = partner + path + time;
  
  final hmac = Hmac(
    sha256,
    base64Decode('c2hwazU2NjI0NzQ5NzM3OTZmNTc3NDU0NDU1MTc4NmE2YTZkNDg2ODc0NTI1MzYyNzc2ZDY2NjI2MjQyNjc3NA=='),
  );

  final hash = hmac.convert(utf8.encode(base));

  http.post(
    Uri.parse('https://openplatform.sandbox.test-stable.shopee.sg$path?partner_id=$partner&sign=$hash&timestamp=$time')
  )
  .then(
    (r) {
      print('hasilnya: ${r.body}');
    }
  );
} */

/* //NOTE cara membuat sign HMAC-SHA256 untuk API
    //1. gabung partner_id, api path, timestamp, access_token, dan shop_id menjadi base
    final
    partner = '1201347',
    path = '/api/v2/product/get_item_list',
    time = '${DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond}',
    token = '666164684d69686c5952727464485541',
    shop = '226708243',
    base = partner + path + time + token + shop;
    print('hasil base: $base');
    
    //2. hash base dengan HMAC-SHA256
    final hmac = Hmac(
      sha256,
      base64Decode('c2hwazU2NjI0NzQ5NzM3OTZmNTc3NDU0NDU1MTc4NmE2YTZkNDg2ODc0NTI1MzYyNzc2ZDY2NjI2MjQyNjc3NA=='),
    );
    final hash = hmac.convert(utf8.encode(base));
    print('hasil hash: $hash');
    
    http.get(
      Uri.parse('https://openplatform.sandbox.test-stable.shopee.sg/api/v2/product/get_item_list?partner_id=$partner&sign=$hash&timestamp=$time&shop_id=$shop&access_token=$token&offset=0&page_size=10&update_time_from=1423958400&update_time_to=$time&item_status=NORMAL')
    )
    .then(
      (r) {
        print('hasilnya: ${r.body}');
      }
    ); */