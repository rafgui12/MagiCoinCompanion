import 'package:flutter/material.dart';
import 'package:magicoincompanion/page/UserMagiCoin.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:magicoincompanion/util/magi_api.dart';


class MagiCoin extends StatelessWidget {
  final String username;
  final double balance;
  final double stakedbalance;
  final String usernameMagi;
  final double priceMax;
  final double paid24h;
  final double nextpay;
  final List Transactions;
  final List Miners;

  MagiCoin(
      {super.key,
      String? username,
      double? balance,
      double? stakedbalance,
      String? usernameMagi,
      double? priceMax,
      double? paid24h,
      double? nextpay,
      List? Transactions,
      List? Miners})
      : username = username ?? '',
        balance = balance ?? 0,
        stakedbalance = stakedbalance ?? 0,
        usernameMagi = usernameMagi ?? '',
        priceMax = priceMax ?? 0,
        paid24h = paid24h ?? 0,
        nextpay = nextpay ?? 0,
        Transactions = Transactions ?? [],
        Miners = Miners ?? [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NavigationMagiCoin(
          username: username,
          balance: balance,
          stakedbalance: stakedbalance,
          usernameMagi: usernameMagi,
          priceMax: priceMax,
          paid24h: paid24h,
          nextpay: nextpay,
          Transactions: Transactions,
          Miners: Miners),
    );
  }
}

class NavigationMagiCoin extends StatefulWidget {
  final String username;
  final double balance;
  final double stakedbalance;
  final String usernameMagi;
  final double priceMax;
  final double paid24h;
  final double nextpay;
  final List Transactions;
  final List Miners;

  const NavigationMagiCoin(
      {super.key,
      required this.username,
      required this.balance,
      required this.stakedbalance,
      required this.usernameMagi,
      required this.priceMax,
      required this.paid24h,
      required this.nextpay,
      required this.Transactions,
      required this.Miners});
  @override
  State<NavigationMagiCoin> createState() => _NavigationMagiCoinState();
}

Future<void> _refresh(String username, context) {
  print(username);
  fetchMagiUser(username).then((magiUser) async {
    if (magiUser == null) {
      // Delay for 1 minute (60 seconds)
      await Future.delayed(const Duration(minutes: 1));

      // Navigate to the desired screen
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
  return Future.delayed(const Duration(seconds: 60));
}

class _NavigationMagiCoinState extends State<NavigationMagiCoin> {
  int currentPageIndex = 0;
  late String username;
  late double balance;
  late double stakedbalance;
  late String usernameMagi;
  late double priceMax;
  late double paid24h;
  late double nextpay;
  late List Transactions;
  late List Miners;

  @override
  void initState() {
    super.initState();
    username = widget.username;
    balance = widget.balance;
    stakedbalance = widget.stakedbalance;
    usernameMagi = widget.usernameMagi;
    priceMax = widget.priceMax;
    paid24h = widget.paid24h;
    nextpay = widget.nextpay;
    Transactions = widget.Transactions;
    Miners = widget.Miners;
    // You can perform any other necessary operations here
  }

  void deleteUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => UserMagiCoin(
              error: '',
        )
      )
    );
  }

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
          actions: [
            IconButton(
              onPressed: () {
                // Handle the button press here
                // Add code to delete storage
                deleteUsername();
              },
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
                size: 26,
              ),
            ),
          ],
          flexibleSpace: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Account of ',
                    style: const TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: username,
                        style: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (balance != 0)
                  Text.rich(
                    TextSpan(
                      text: 'Σ ',
                      style: const TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Inter',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '${balance.toString().split('.')[0]}.',
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'Inter',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: balance.toString().split('.')[1],
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'Inter',
                            fontSize: 32,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const Text(
                    '\$ ' '0.0',
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                if (priceMax != 0 && balance != 0)
                  Text(
                    '\$ ${(balance) * (priceMax)}',
                    style: const TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  )
                else
                  const Text(
                    '\$ ' '0.0',
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  )
              ],
            ),
          ),
          centerTitle: true,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        backgroundColor: const Color(0xFF6AC2EE),
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.transparent,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.home,
              color: Color(0xFFFFFFFF),
              size: 61,
            ),
            icon: Icon(
              Icons.home_outlined,
              color: Color(0xFF4285F4),
              size: 61,
            ),
            label: '',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.memory,
              color: Color(0xFFFFFFFF),
              size: 61,
            ),
            icon: Icon(
              Icons.memory_outlined,
              color: Color(0xFF4285F4),
              size: 61,
            ),
            label: '',
          ),
        ],
      ),
      body: <Widget>[
        RefreshIndicator(
          child: 
          /// Home page
            Column(children: [
              Container(
                  padding: const EdgeInsets.only(
                      top: 14, bottom: 0, left: 32, right: 32),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 80,
                              child: Card(
                                color: const Color(0xFF6AC2EE),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Magi Price',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    if (priceMax != 0)
                                      Text(
                                        '\$ ${(priceMax).toStringAsFixed(8)}',
                                        style: const TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w200),
                                      )
                                    else
                                      const Text(
                                        '\$ ' '0.0',
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w200),
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
                            SizedBox(
                              width: 100,
                              height: 80,
                              child: Card(
                                color: const Color(0xFF6AC2EE),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '24h Earning',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    if (paid24h != 0)
                                      Text(
                                        'Σ ${(paid24h).toStringAsFixed(6)}',
                                        style: const TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w200),
                                      )
                                    else
                                      const Text(
                                        'Σ ' '0.0',
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w200),
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
                            SizedBox(
                              width: 100,
                              height: 80,
                              child: Card(
                                color: const Color(0xFF6AC2EE),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Staking Balance',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    if (stakedbalance != 0)
                                      Text(
                                        'Σ $stakedbalance',
                                        style: const TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w200),
                                      )
                                    else
                                      const Text(
                                        'Σ ' '0.0',
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w200),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),

              /// Add line break here ///
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 32, top: 16),
                child: const Text(
                  'Last Transactions',
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Inter',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              /// Add line break here ///
              Container(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (Transactions.isNotEmpty)
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.4, // Adjust the height as needed
                        width: MediaQuery.of(context).size.width *
                            0.9, // Adjust the width as needed
                        child: ListView.builder(
                          itemCount: Transactions.length,
                          itemBuilder: (context, index) {
                            final reversedIndex = Transactions.length - 1 - index;
                            final item = Transactions[reversedIndex];
                            if (item['recipient'] == username) {
                              return Card(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween, // Alinea las columnas a los extremos
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              text: "+",
                                              style: const TextStyle(
                                                  color: Color(0xFF06A10C),
                                                  fontFamily: 'Inter',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      " ${item['amount']} to ${item['recipient']}",
                                                  style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontFamily: 'Inter',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text("${item['memo']}",
                                              style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w200)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                              (item['datetime']).toString().split(' ')[0],
                                              style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w200)),
                                          Text(
                                              (item['datetime']).toString().split(' ')[1],
                                              style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w200)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Card(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween, // Alinea las columnas a los extremos
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              text: "-",
                                              style: const TextStyle(
                                                  color: Color(0xFFFF0000),
                                                  fontFamily: 'Inter',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      " ${item['amount']} to ${item['recipient']}",
                                                  style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontFamily: 'Inter',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text("${item['memo']}",
                                              style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w200)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                              (item['datetime']).toString().split(' ')[0],
                                              style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w200)),
                                          Text(
                                              (item['datetime']).toString().split(' ')[1],
                                              style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w200)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      )
                    else
                      Container(
                        child: const Text("No data",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w200)),
                      ),
                  ],
                ),
              ),
            ]),
          onRefresh: () => _refresh(username, context),
        ),
        RefreshIndicator(
          child: 
          /// Miner page
            Column(children: [
              Container(
                  padding: const EdgeInsets.only(
                      top: 14, bottom: 0, left: 32, right: 32),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 80,
                              child: Card(
                                color: const Color(0xFF6AC2EE),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '# of miners',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    if (Miners.isNotEmpty)
                                      Text(
                                        '${Miners.length}',
                                        style: const TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w200),
                                      )
                                    else
                                      const Text(
                                        '0',
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w200),
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
                            SizedBox(
                              width: 100,
                              height: 80,
                              child: Card(
                                color: const Color(0xFF6AC2EE),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '24h Earning',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    if (paid24h != 0)
                                      Text(
                                        'Σ ${paid24h.toStringAsFixed(6)}',
                                        style: const TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w200),
                                      )
                                    else
                                      const Text(
                                        'Σ ' '0.0',
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
                            SizedBox(
                              width: 100,
                              height: 80,
                              child: Card(
                                color: const Color(0xFF6AC2EE),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Next Pay',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    if (nextpay != 0)
                                      Text(
                                        'Σ $nextpay',
                                        style: const TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w200),
                                      )
                                    else
                                      const Text(
                                        'Σ ' '0.0',
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w200),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),

              /// Add line break here ///
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 32, top: 16),
                child: const Text(
                  'Miners',
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Inter',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              /// Add line break here ///
              Container(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (Miners.isNotEmpty)
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.4, // Adjust the height as needed
                        width: MediaQuery.of(context).size.width *
                            0.9, // Adjust the width as needed
                        child: ListView.builder(
                          itemCount: Miners.length,
                          itemBuilder: (context, index) {
                            final reversedIndex = Miners.length - 1 - index;
                            final item = Miners[reversedIndex];
                            return Card(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, // Alinea las columnas a los extremos
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 16, bottom: 10, right: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${item['ID']}",
                                            style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Text("${item['version']}",
                                            style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w200)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, right: 16, bottom: 10, left: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("${(item['accepted'])}",
                                            style: const TextStyle(
                                                color: Color(0xFF06A10C),
                                                fontFamily: 'Inter',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w200)),
                                        Text("${(item['rejected'])}",
                                            style: const TextStyle(
                                                color: Color(0xFFFF0000),
                                                fontFamily: 'Inter',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w200)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    else
                      Container(
                        child: const Text("No data",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w200)),
                      ),
                  ],
                ),
              ),
            ]),
          onRefresh: () => _refresh(username, context),
        ),
        
      ][currentPageIndex],
    );
  }
}
