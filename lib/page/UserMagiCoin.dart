import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:magicoincompanion/page/MagiCoin.dart';


Future<MagiUser?> fetchMagiUser(username, BuildContext context) async {
  final response = await http.get(Uri.parse('https://magi.duinocoin.com//users/' + username));
  if (response.statusCode == 200) {
    if ((json.decode(response.body))['success'] == true){
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final responseMiners = await http.get(Uri.parse('https://bowserlab.ddns.net:8080/api/walletEx?address=' + jsonDecode(response.body)['result']['balance']['address']));
      if(responseMiners.statusCode == 200)
        if (responseMiners.body != ' '){
          return MagiUser.fromJson(jsonDecode(response.body) as Map<String, dynamic>, jsonDecode(responseMiners.body) as Map<String, dynamic>);
        }else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => UserMagiCoin(
            error: 'Fail to load',
          )),
        );
      }
    }else{
      Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => UserMagiCoin(
        error: (json.decode(response.body))['message'] as String,
      )),
    );
    }
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => UserMagiCoin(
        error: 'Failed to load',
      )),
    );
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

  const MagiUser({
    required this.address,
    required this.balance,
    required this.stakedbalance,
    required this.usernameMagi,
    required this.priceMax,
    required this.paid24h,
    required this.nextpay,
    required this.Transactions,
    required this.Miners
  });

  factory MagiUser.fromJson(Map<String, dynamic> data1, Map<String, dynamic> data2) {
    return MagiUser(
      address: data1['result']['balance']['address'] as String,
      balance: data1['result']['balance']['balance'] as double,
      stakedbalance: data1['result']['balance']['staked_balance'] as double,
      usernameMagi: data1['result']['balance']['username'] as String,
      priceMax: data1['result']['price']['max'] as double,
      paid24h:data2['paid24h'] as double,
      nextpay:data2['balance'] as double,
      Transactions:data1['result']['transactions'] as List,
      Miners:data2['miners'] as List
    );
  }
}

// ignore: must_be_immutable
class UserMagiCoin extends StatelessWidget {
  bool showError = true;
  final String error;
  UserMagiCoin({
      Key? key, 
      this.error = ''
    }) : super(key: key); 

  Widget welcomeSection = Container(
    padding: const EdgeInsets.all(32),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            text: 'Your participation is crucial in our application, which is why we will need your username. To provide you with the best experience, we connect with the official APIs of ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w200,
              color: Color.fromRGBO(0, 0, 0, 1),
            ),
            children: <TextSpan>[
              TextSpan(text: 'Bowserlab-Pool, Lidonia, ', 
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
              TextSpan(text: 'and', 
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w200,
              )),
              TextSpan(text: ' Zpoo ', 
              style: TextStyle(
                fontSize: 16,
              fontWeight: FontWeight.bold,
              )),
              TextSpan(text: 'at ', 
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w200,
              )),
              TextSpan(
                text: 'https://magi.duinocoin.com ',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
                recognizer: TapGestureRecognizer()..onTap = () async {
                      final url = Uri.parse('https://magi.duinocoin.com');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
              ),
              TextSpan(text: 'This helps us track miners accurately.', 
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w200,
              )),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Thank you for being part of our community. We are excited to have you here!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    ),
  );
  
  TextEditingController _usernameController = TextEditingController();
  
  Widget inputUser(BuildContext context) => Container(padding: const EdgeInsets.all(32),
    child: Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _usernameController, // Assign the TextEditingController
            decoration: InputDecoration(
              labelText: 'Username',
              hintText: 'Enter your username',
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Set the active input field color to white
                ),
              labelStyle: TextStyle(
                  color: Colors.black, // Set the label text color to black
                ),
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.5), // Set the hint text color to black with opacity
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          child: Text('Next'),
          style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF4285F4)), 
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
          onPressed: () {
            String username = _usernameController.text; // Retrieve the text from the TextEditingController
            // Do something with the username
             fetchMagiUser(username,context).then((magiUser) { 
              if (magiUser == null){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => UserMagiCoin(
                    error: 'Fail to load',
                  )),
                );
              }else{
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MagiCoin(
                    username: username,
                    balance: magiUser.balance,
                    stakedbalance: magiUser.stakedbalance,
                    usernameMagi: magiUser.usernameMagi,
                    priceMax: magiUser.priceMax,
                    paid24h: magiUser.paid24h,
                    nextpay: magiUser.nextpay,
                    Transactions: magiUser.Transactions,
                    Miners: magiUser.Miners
                  )),
                );
              }
            });
            
          },
        ),
      ],
    ),
  );


  @override
  Widget build(BuildContext context) {
      return Scaffold(
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
                    'Magi Coin Companion',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'Inter',
                      fontSize: 32,
                    ),
                  ),
                  SizedBox(height: 10), // Add line break here
                  Text(
                    'Welcome',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'Inter',
                      fontSize: 32,
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: Column(
          children: [
            welcomeSection,
            inputUser(context),
            if (error.isNotEmpty) Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.6),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                error,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
}