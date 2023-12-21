// util/magi_api.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<MagiUser?> fetchMagiUser(username) async {
  final response = await http.get(Uri.parse('https://magi.duinocoin.com//users/' + username));
  if (response.statusCode == 200) {
    if ((json.decode(response.body))['success'] == true) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final responseMiners = await http.get(Uri.parse(
          'https://bowserlab.ddns.net:8080/api/walletEx?address=' +
              jsonDecode(response.body)['result']['balance']['address']));
      if (responseMiners.statusCode == 200) if (responseMiners.body.length >
          5) {
        return MagiUser.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
            jsonDecode(responseMiners.body) as Map<String, dynamic>);
      } else {
        return null;
      }
    } else {
      return null;
    }
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    return null;
  }
  return null;
}

class MagiUser {
  final String address;
  final double balance;
  final double stakedbalance;
  final String usernameMagi;
  final double priceMax;
  final double paid24h;
  final double nextpay;
  final List Transactions;
  final List Miners;

  const MagiUser(
      {required this.address,
      required this.balance,
      required this.stakedbalance,
      required this.usernameMagi,
      required this.priceMax,
      required this.paid24h,
      required this.nextpay,
      required this.Transactions,
      required this.Miners});

  factory MagiUser.fromJson(
      Map<String, dynamic> data1, Map<String, dynamic> data2) {
    return MagiUser(
        address: data1['result']['balance']['address'] as String,
        balance: data1['result']['balance']['balance'] as double,
        stakedbalance: data1['result']['balance']['staked_balance'] as double,
        usernameMagi: data1['result']['balance']['username'] as String,
        priceMax: data1['result']['price']['max'] as double,
        paid24h: data2['paid24h'] as double,
        nextpay: data2['balance'] as double,
        Transactions: data1['result']['transactions'] as List,
        Miners: data2['miners'] as List);
  }
}