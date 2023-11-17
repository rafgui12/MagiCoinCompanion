import 'dart:convert';
import 'dart:async';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<MagiUser> fetchMagiUser(username) async {
  final response = await http
      .get(Uri.parse('https://magi.duinocoin.com//users/' + username));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return MagiUser.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class MagiUser {
  final String address;
  final double balance;
  final double stakedbalance;
  final String usernameMagi;
  final double priceMax;

  const MagiUser({
    required this.address,
    required this.balance,
    required this.stakedbalance,
    required this.usernameMagi,
    required this.priceMax
  });

  factory MagiUser.fromJson(Map<String, dynamic> json) {
    return MagiUser(
      address: json['result']['balance']['address'] as String,
      balance: json['result']['balance']['balance'] as double,
      stakedbalance: json['result']['balance']['staked_balance'] as double,
      usernameMagi: json['result']['balance']['username'] as String,
      priceMax: json['result']['price']['max'] as double,

    );
  }
}


class MagiCoin extends StatelessWidget {

  late Future<MagiUser> futureMagiUser = fetchMagiUser(username);

  final String username;
  MagiCoin({
      Key? key, 
      required this.username
    }) : super(key: key); 

  @override
  Widget titleSection = Container(
  padding: const EdgeInsets.all(32),
  child: Row(
    children: [
      Expanded(
        /*1*/
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: const Text(
                'Oeschinen Lake Campground',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              'Kandersteg, Switzerland',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
      /*3*/
      Icon(
        Icons.star,
        color: Colors.red[500],
      ),
      const Text('41'),
    ],
  ),
);
  Widget build (BuildContext context) { 
    print(futureMagiUser);
    return
    Scaffold(
    backgroundColor: Color(0xFFE0F5FF),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(173.0), // Set the desired height here
          child: AppBar(
            backgroundColor: Color(int.parse('0xFF6AC2EE')),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            flexibleSpace: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Account of ' + username,
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  SizedBox(height: 20),
                  FutureBuilder<MagiUser>(
                  future: futureMagiUser,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        'Σ ' + (snapshot.data!.balance).toString(),
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Inter',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        'Σ ' + '0.0',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Inter',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                    },
                  ),
                  FutureBuilder<MagiUser>(
                  future: futureMagiUser,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                          '\$ ' + ((snapshot.data!.balance)*(snapshot.data!.priceMax)).toString(),
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                          ),
                        );
                    } else if (snapshot.hasError) {
                      return Text(
                          '\$ ' + '0.0',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                          ),
                        );
                    }
                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                    },
                  ),// Add line break here
                  
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
    body: Column(
      children:[
        titleSection,
      ] 
    ),
  );
  }
  
}

