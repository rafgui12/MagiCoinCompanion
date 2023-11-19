import 'package:flutter/material.dart';
import 'package:magicoincompanion/page/MagiCoin.dart';
import 'dart:async';

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
        Text(
          'Your participation is crucial in our application, which is why we will need your username. To provide you with the best experience, we connect with the official APIs of Bowserlab-Pool, Lidonia, and Zpoo at https://magi.duinocoin.com/ This helps us track miners accurately.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w200,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Thank you for being part of our community. We are excited to have you here!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
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
            ),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          child: Text('Next'),
          onPressed: () {
            String username = _usernameController.text; // Retrieve the text from the TextEditingController
            // Do something with the username
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MagiCoin(
                username: username,
              )),
            );
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