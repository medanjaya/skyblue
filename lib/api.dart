import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

final String host = 'openplatform.sandbox.test-stable.shopee.sg';
final SupabaseClient sb = Supabase.instance.client;

bool isAuth = false;

Future<void> authPartner() async {
  final
  prefs = await SharedPreferences.getInstance(),

  partner = prefs.getString('partner') ?? '',
  secret = prefs.getString('secret') ?? '',

  path = '/api/v2/shop/auth_partner',
  time = '${DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond}',
  
  hmac = Hmac(sha256, base64Decode(secret)),
  sign = hmac.convert(utf8.encode(partner + path + time));

  if (!isAuth) {
    isAuth = true;
    
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
      )
      .toString(),
      callbackUrlScheme: 'https',
      options: const FlutterWebAuth2Options(
        httpsHost: 'open.shopee.com',
      ),
    )
    .then(
      (r) {
        final
        path = '/api/v2/auth/token/get',
        sign = hmac.convert(utf8.encode(partner + path + time)),
        
        code = Uri.parse(r).queryParameters['code'],
        shop = Uri.parse(r).queryParameters['shop_id'];
        
        prefs.setString('shop', shop!);

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
              'code': code,
              'shop_id': shop,
            },
          ),
        )
        .then(
          (r) {
            final result = jsonDecode(r.body);

            prefs.setString('token', result['access_token']);
            prefs.setString('refresh', result['refresh_token']);
            
            prefs.setString(
              'expiry',
              '${
                DateTime.now().add(
                  const Duration(
                    hours: 4,
                  ),
                )
                .millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond
              }'
            );

            isAuth = false;
          },
        );
      },
    )
    .catchError(
      (e) {
        isAuth = false;
      },
    );
  }
}

Future<void> refreshToken() async {
  final
  prefs = await SharedPreferences.getInstance(),

  expiry = prefs.getString('expiry') ?? '',
  
  partner = prefs.getString('partner') ?? '',
  secret = prefs.getString('secret') ?? '',

  path = '/api/v2/auth/access_token/get',
  time = '${DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond}',

  hmac = Hmac(sha256, base64Decode(secret)),
  sign = hmac.convert(utf8.encode(partner + path + time)),

  refresh = prefs.getString('refresh') ?? '',
  shop = prefs.getString('shop') ?? '';

  int.parse(expiry) > int.parse(time)
  ? http.post(
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
        'partner_id': int.parse(partner),
        'refresh_token': refresh,
        'shop_id': int.parse(shop),
      },
    ),
  )
  .then(
    (r) {
      final result = jsonDecode(r.body);

      prefs.setString('token', result['access_token']);
      prefs.setString('refresh', result['refresh_token']);

      prefs.setString(
        'expiry',
        '${
          DateTime.now().add(
            const Duration(
              hours: 3,
              minutes: 59,
              seconds: 59,
            ),
          )
          .millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond
        }'
      );
    },
  )
  : authPartner();
}

Stream getItemList() async* {
  while (true) {
    yield await fetchItemList();
    await Future.delayed(
      const Duration(
        seconds: 3,
      ),
    );
  }
}

Future fetchItemList() async {
  final
  prefs = await SharedPreferences.getInstance(),

  partner = prefs.getString('partner') ?? '',
  secret = prefs.getString('secret') ?? '',

  path = '/api/v2/product/get_item_list',
  time = '${DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond}',
  
  token = prefs.getString('token') ?? '',
  shop = prefs.getString('shop') ?? '',

  hmac = Hmac(sha256, base64Decode(secret)),
  sign = hmac.convert(utf8.encode(partner + path + time + token + shop));

  return refreshToken()
  .then(
    (r) {
      return http.get(
        Uri.https(
          host,
          path,
          {
            'partner_id': partner,
            'timestamp': time,
            'access_token': token,
            'shop_id': shop,
            'sign': sign.toString(),
            'offset': '0',
            'page_size': '100',
            'update_time_from': '1423958400',
            'update_time_to': time,
            'item_status': [
              'NORMAL',
              'BANNED',
              'UNLIST',
              'REVIEWING',
              /* 'SELLER_DELETE',
              'SHOPEE_DELETE', */ //FIXME ini rawan eror sepertinya
            ],
          },
        ),
      )
      .then(
        (r) {
          //FIXME print(r.body);
          
          final
          result = jsonDecode(r.body)['response']['item'],
          
          path = '/api/v2/product/get_item_base_info',
          time = '${DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond}',
          
          sign = hmac.convert(utf8.encode(partner + path + time + token + shop));

          return http.get(
            Uri.https(
              host,
              path,
              {
                'partner_id': partner,
                'timestamp': time,
                'access_token': token,
                'shop_id': shop,
                'sign': sign.toString(),
                'item_id_list': List.generate(
                  result.length,
                  (i) {
                    return result[i]['item_id'].toString();
                  },
                )
                .join(','),
              },
            ),
          )
          .then(
            (r) {
              //FIXME print(r.body);
              return jsonDecode(r.body)['response']['item_list'];
            }
          );
        },
      );
    },
  );
}

Stream getModelList(int id) async* {
  while (true) {
    yield await fetchModelList(id);
    await Future.delayed(
      const Duration(
        seconds: 3,
      ),
    );
  }
}

Future fetchModelList(int id) async {
  final
  prefs = await SharedPreferences.getInstance(),

  partner = prefs.getString('partner') ?? '',
  secret = prefs.getString('secret') ?? '',

  path = '/api/v2/product/get_model_list',
  time = '${DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond}',
  
  token = prefs.getString('token') ?? '',
  shop = prefs.getString('shop') ?? '',

  hmac = Hmac(sha256, base64Decode(secret)),
  sign = hmac.convert(utf8.encode(partner + path + time + token + shop));

  return refreshToken()
  .then(
    (r) {
      return http.get(
        Uri.https(
          host,
          path,
          {
            'partner_id': partner,
            'timestamp': time,
            'access_token': token,
            'shop_id': shop,
            'sign': sign.toString(),
            'item_id': id.toString(),
          },
        ),
      )
      .then(
        (r) {
          //FIXME print(r.body);
          return jsonDecode(r.body)['response']['model'];
        },
      );
    },
  );
}

Stream getOrderList() async* {
  while (true) {
    yield await fetchOrderList();
    await Future.delayed(
      const Duration(
        seconds: 3,
      ),
    );
  }
}

Future fetchOrderList() async {
  final
  prefs = await SharedPreferences.getInstance(),

  partner = prefs.getString('partner') ?? '',
  secret = prefs.getString('secret') ?? '',

  path = '/api/v2/order/get_order_list',
  time = '${DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond}',
  
  token = prefs.getString('token') ?? '',
  shop = prefs.getString('shop') ?? '',

  hmac = Hmac(sha256, base64Decode(secret)),
  sign = hmac.convert(utf8.encode(partner + path + time + token + shop)),

  from = '${
    DateTime.now().subtract(
      const Duration(
        days: 15,
      ),
    )
    .millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond
  }';

  return refreshToken()
  .then(
    (r) {
      return http.get(
        Uri.https(
          host,
          path,
          {
            'partner_id': partner,
            'timestamp': time,
            'access_token': token,
            'shop_id': shop,
            'sign': sign.toString(),
            'time_range_field': 'create_time',
            'time_from': from,
            'time_to': time,
            'page_size': '100',
          },
        ),
      )
      .then(
        (r) {
          //FIXME print(r.body);
          
          final
          result = jsonDecode(r.body)['response']['order_list'],
          
          path = '/api/v2/order/get_order_detail',
          time = '${DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond}',
          
          sign = hmac.convert(utf8.encode(partner + path + time + token + shop));

          return http.get(
            Uri.https(
              host,
              path,
              {
                'partner_id': partner,
                'timestamp': time,
                'access_token': token,
                'shop_id': shop,
                'sign': sign.toString(),
                'order_sn_list': List.generate(
                  result.length,
                  (i) {
                    return result[i]['order_sn'];
                  },
                )
                .join(','),
                'response_optional_fields': [
                  'buyer_username',
                  'item_list',
                  'total_amount',
                ]
                .join(','),
              },
            ),
          )
          .then(
            (r) {
              //FIXME print(r.body);
              return jsonDecode(r.body)['response']['order_list'];
            }
          );
        },
      );
    },
  );
}

Future fetchCategoryList() async {
  final
  prefs = await SharedPreferences.getInstance(),

  partner = prefs.getString('partner') ?? '',
  secret = prefs.getString('secret') ?? '',

  path = '/api/v2/product/get_category',
  time = '${DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond}',
  
  token = prefs.getString('token') ?? '',
  shop = prefs.getString('shop') ?? '',

  hmac = Hmac(sha256, base64Decode(secret)),
  sign = hmac.convert(utf8.encode(partner + path + time + token + shop));

  return refreshToken()
  .then(
    (r) {
      return http.get(
        Uri.https(
          host,
          path,
          {
            'partner_id': partner,
            'timestamp': time,
            'access_token': token,
            'shop_id': shop,
            'sign': sign.toString(),
            'language': 'id',
          },
        ),
      )
      .then(
        (r) {
          //FIXME print(r.body);
          return jsonDecode(r.body)['response']['category_list'];
        },
      );
    },
  );
}

Future fetchChannelList() async {
  final
  prefs = await SharedPreferences.getInstance(),

  partner = prefs.getString('partner') ?? '',
  secret = prefs.getString('secret') ?? '',

  path = '/api/v2/logistics/get_channel_list',
  time = '${DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond}',
  
  token = prefs.getString('token') ?? '',
  shop = prefs.getString('shop') ?? '',

  hmac = Hmac(sha256, base64Decode(secret)),
  sign = hmac.convert(utf8.encode(partner + path + time + token + shop));

  return refreshToken()
  .then(
    (r) {
      return http.get(
        Uri.https(
          host,
          path,
          {
            'partner_id': partner,
            'timestamp': time,
            'access_token': token,
            'shop_id': shop,
            'sign': sign.toString(),
          },
        ),
      )
      .then(
        (r) {
          //FIXME print(r.body);
          return jsonDecode(r.body)['response']['logistics_channel_list'];
        },
      );
    },
  );
}

Future fetchAttributeTree(int id) async {
  final
  prefs = await SharedPreferences.getInstance(),

  partner = prefs.getString('partner') ?? '',
  secret = prefs.getString('secret') ?? '',

  path = '/api/v2/product/get_attribute_tree',
  time = '${DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond}',
  
  token = prefs.getString('token') ?? '',
  shop = prefs.getString('shop') ?? '',

  hmac = Hmac(sha256, base64Decode(secret)),
  sign = hmac.convert(utf8.encode(partner + path + time + token + shop));

  return refreshToken()
  .then(
    (r) {
      return http.get(
        Uri.https(
          host,
          path,
          {
            'partner_id': partner,
            'timestamp': time,
            'access_token': token,
            'shop_id': shop,
            'sign': sign.toString(),
            'category_id_list': id.toString(),
            'language': 'id',
          },
        ),
      )
      .then(
        (r) {
          //FIXME print(r.body);
          return jsonDecode(r.body)['response']['list'][0]['attribute_tree'];
        },
      );
    },
  );
}

Future<void> updateStock(int id, int value) async {
  final
  prefs = await SharedPreferences.getInstance(),

  partner = prefs.getString('partner') ?? '',
  secret = prefs.getString('secret') ?? '',

  path = '/api/v2/product/update_stock',
  time = '${DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond}',
  
  token = prefs.getString('token') ?? '',
  shop = prefs.getString('shop') ?? '',

  hmac = Hmac(sha256, base64Decode(secret)),
  sign = hmac.convert(utf8.encode(partner + path + time + token + shop));

  refreshToken()
  .then(
    (r) {
      http.post(
        Uri.https(
          host,
          path,
          {
            'partner_id': partner,
            'timestamp': time,
            'access_token': token,
            'shop_id': shop,
            'sign': sign.toString(),
          },
        ),
        body: jsonEncode(
          {
            'item_id': id,
            'stock_list': [
              {
                'seller_stock': [
                  {
                    'stock': value,
                  },
                ],
              },
            ],
          },
        ),
      )
      .then(
        (r) {
          //FIXME print(r.body);
        },
      );
    },
  );
}

Future<void> addItem(Map item) async {
  final
  prefs = await SharedPreferences.getInstance(),

  partner = prefs.getString('partner') ?? '',
  secret = prefs.getString('secret') ?? '',

  path = '/api/v2/product/add_item',
  time = '${DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond}',
  
  token = prefs.getString('token') ?? '',
  shop = prefs.getString('shop') ?? '',

  hmac = Hmac(sha256, base64Decode(secret)),
  sign = hmac.convert(utf8.encode(partner + path + time + token + shop)),
  
  minimum = item['minimum'];
  item.remove('minimum');

  refreshToken()
  .then(
    (r) {
      http.post(
        Uri.https(
          host,
          path,
          {
            'partner_id': partner,
            'timestamp': time,
            'access_token': token,
            'shop_id': shop,
            'sign': sign.toString(),
          },
        ),
        body: jsonEncode(item),
      )
      .then(
        (r) {
          //FIXME print(r.body);
          sb.from('stock').insert(
            {
              'id': jsonDecode(r.body)['response']['item_id'],
              'minimum': minimum,
            },
          );
        },
      );
    },
  );
}

Future uploadImage(dynamic media) async {
  final
  prefs = await SharedPreferences.getInstance(),

  partner = prefs.getString('partner') ?? '',
  secret = prefs.getString('secret') ?? '',

  path = '/api/v2/media/upload_image',
  time = '${DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond}',
  
  hmac = Hmac(sha256, base64Decode(secret)),
  sign = hmac.convert(utf8.encode(partner + path + time));

  return refreshToken()
  .then(
    (r) async {
      final request = http.MultipartRequest(
        'POST',
        Uri.https(
          host,
          path,
          {
            'partner_id': partner,
            'timestamp': time,
            'sign': sign.toString(),
          },
        ),
      );

      request.fields.addAll(
        {
          'business': '2',
          'scene': '1',
        }
      );

      for (final image in media) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images',
            image.path,
          ),
        );
      }

      return await http.Response.fromStream(
        await request.send(),
      )
      .then(
        (r) {
          //FIXME print(r.body);
          return jsonDecode(r.body)['response']['image_list'];
        }
      );
    },
  );
}