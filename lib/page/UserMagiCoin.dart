import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:magicoincompanion/page/MagiCoin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:magicoincompanion/util/magi_api.dart';

String? error;

Future<String?> checkIfUsernameExists() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedUsername = prefs.getString('username');
  return savedUsername;
}

// ignore: must_be_immutable
class UserMagiCoin extends StatelessWidget {
  bool showError = true;
  final String error;
  UserMagiCoin({super.key, this.error = ''});

  Widget welcomeSection = Container(
    padding: const EdgeInsets.all(32),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            text:
                'Your participation is crucial in our application, which is why we will need your username. To provide you with the best experience, we connect with the official APIs of ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w200,
              color: Color.fromRGBO(0, 0, 0, 1),
            ),
            children: <TextSpan>[
              const TextSpan(
                  text: 'Bowserlab-Pool, Lidonia, ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
              const TextSpan(
                  text: 'and',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                  )),
              const TextSpan(
                  text: ' Zpoo ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
              const TextSpan(
                  text: 'at ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                  )),
              TextSpan(
                text: 'https://magi.duinocoin.com ',
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    final url = Uri.parse('https://magi.duinocoin.com');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
              ),
              const TextSpan(
                  text: 'This helps us track miners accurately.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                  )),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Thank you for being part of our community. We are excited to have you here!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    ),
  );

  final TextEditingController _usernameController = TextEditingController();

  Widget inputUser(BuildContext context) => Container(
        padding: const EdgeInsets.all(32),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller:
                    _usernameController, // Assign the TextEditingController
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .white), // Set the active input field color to white
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.black, // Set the label text color to black
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(
                        0.5), // Set the hint text color to black with opacity
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFF4285F4)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                String username = _usernameController
                    .text; // Retrieve the text from the TextEditingController
                // Do something with the username
                fetchMagiUser(username, context).then((magiUser) async {
                  if (magiUser == null) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => UserMagiCoin(
                                error: 'Fail to load',
                              )),
                    );
                  } else {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('username', username);

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => MagiCoin(
                              username: username,
                              balance: magiUser.balance,
                              stakedbalance: magiUser.stakedbalance,
                              usernameMagi: magiUser.usernameMagi,
                              priceMax: magiUser.priceMax,
                              paid24h: magiUser.paid24h,
                              nextpay: magiUser.nextpay,
                              Transactions: magiUser.Transactions,
                              Miners: magiUser.Miners)),
                    );
                  }
                });
              },
              child: const Text('Next'),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F5FF),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(173.0), // Set the desired height here
        child: AppBar(
          backgroundColor: Color(int.parse('0xFF6AC2EE')),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          flexibleSpace: const Align(
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
      body: FutureBuilder<String?>(
        future: checkIfUsernameExists(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          print(snapshot.data);
          if (snapshot.data == null) {
            return Column(
              children: [
                welcomeSection,
                inputUser(context),
                if (error.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(10),
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
            );
          } else {
            String username = snapshot.data!;
            fetchMagiUser(username, context).then((magiUser) async {
              if (magiUser == null) {
                print("Fail to load");
                
                // Delay for 1 minute (60 seconds)
                await Future.delayed(const Duration(minutes: 1));

                // Navigate to the desired screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserMagiCoin(
                      error: 'Fail to load',
                    ),
                  ),
                );
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => MagiCoin(
                          username: username,
                          balance: magiUser.balance,
                          stakedbalance: magiUser.stakedbalance,
                          usernameMagi: magiUser.usernameMagi,
                          priceMax: magiUser.priceMax,
                          paid24h: magiUser.paid24h,
                          nextpay: magiUser.nextpay,
                          Transactions: magiUser.Transactions,
                          Miners: magiUser.Miners)),
                );
              }
            });
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                      'Retrying please wait 1 minute...',
                      style: TextStyle(fontSize: 16),
                    )
                ],
              ),
            ); // or any other loading indicator
          }
        },
      ),
    );
  }
}
