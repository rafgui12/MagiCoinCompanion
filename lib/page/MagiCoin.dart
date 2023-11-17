import 'dart:convert';
import 'dart:async';

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
  final List Transactions;

  const MagiUser({
    required this.address,
    required this.balance,
    required this.stakedbalance,
    required this.usernameMagi,
    required this.priceMax,
    required this.Transactions
  });

  factory MagiUser.fromJson(Map<String, dynamic> json) {
    return MagiUser(
      address: json['result']['balance']['address'] as String,
      balance: json['result']['balance']['balance'] as double,
      stakedbalance: json['result']['balance']['staked_balance'] as double,
      usernameMagi: json['result']['balance']['username'] as String,
      priceMax: json['result']['price']['max'] as double,
      Transactions:json['result']['transactions'] as List
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
  
  Widget build (BuildContext context) { 
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
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
    ),
    body: Column(
      children:[
        Container(
        padding: const EdgeInsets.all(32),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 80,
                    child: Card(
                      color: Color(0xFF6AC2EE),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              'Magi Price',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          SizedBox(height: 12),
                          FutureBuilder<MagiUser>(
                          future: futureMagiUser,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                  '\$ ' + (snapshot.data!.priceMax).toStringAsFixed(8),
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w200
                                  ),
                                );
                            } else if (snapshot.hasError) {
                              return Text(
                                  '\$ ' + '0.0',
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w200
                                  ),
                                );
                            }
                            // By default, show a loading spinner.
                            return const CircularProgressIndicator();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 80,
                    child: Card(
                      color: Color(0xFF6AC2EE),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '24h Earning',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text('\$ '+'0.0', 
                            style: TextStyle(
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 80,
                    child: Card(
                      color: Color(0xFF6AC2EE),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Staking Balance',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 12),
                          FutureBuilder<MagiUser>(
                          future: futureMagiUser,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                  'Σ ' + (snapshot.data!.stakedbalance).toString(),
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w200
                                  ),
                                );
                            } else if (snapshot.hasError) {
                              return Text(
                                  'Σ ' + '0.0',
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w200
                                  ),
                                );
                            }
                            // By default, show a loading spinner.
                            return const CircularProgressIndicator();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
/// Add line break here ///
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 32,top: 16),
          child: Text(
            'Last Transactions',
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontFamily: 'Inter',
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
/// Add line break here ///
         Container(
          padding: const EdgeInsets.all(32),
          child: Row(
            children: [
              FutureBuilder<MagiUser>(
              future: futureMagiUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.4, // Adjust the height as needed
                    width: MediaQuery.of(context).size.width * 0.8, // Adjust the width as needed
                    child: ListView.builder(
                      itemCount: snapshot.data!.Transactions.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data!.Transactions[index];
                        print(item);
                        return Card(
                          child: ListTile(
                            title: Text("${item['amount']} to ${item['recipient']}"),
                            subtitle: Text("${item['memo']}"),
                          ),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
                },
              ),
            ],
          ),
         ), 
      ] 
    ),
  );
  }
  
}

