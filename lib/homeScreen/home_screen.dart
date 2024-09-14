import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:users_app_web_admin/sellers/blocked_sellers_screen.dart';
import 'package:users_app_web_admin/sellers/verified_sellers_screen.dart';
import 'package:users_app_web_admin/users/blocked_users_screen.dart';
import 'package:users_app_web_admin/users/verified_users_screen.dart';
import 'package:users_app_web_admin/widgets/nav_appbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String liveTime = "";
  String liveDate = "";

  String formatCurrentLiveTime(DateTime time) {
    return DateFormat("hh:mm:ss a").format(time);
  }

  String formatCurrentLiveDate(DateTime time) =>
      DateFormat("dd MMM, yyyy").format(time);

  getCurrentLiveTimeDate() {
    liveTime = formatCurrentLiveTime(DateTime.now());
    liveDate = formatCurrentLiveDate(DateTime.now());

    setState(() {
      liveTime;
      liveDate;
    });
  }

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 1), (timer) {
      getCurrentLiveTimeDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: NavAppbar(
        title: 'iShop',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                liveTime + "\n" + liveDate,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // users activate and block accts button ui
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // active users
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => VerifiedUsersScreen(),
                      ),
                    );
                  },
                  child: Image.asset(
                    "images/verified_users.png",
                    width: 200,
                  ),
                ),
                SizedBox(
                  width: 200,
                ),
                // block users
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => BlockedUsersScreen(),
                      ),
                    );
                  },
                  child: Image.asset(
                    "images/blocked_users.png",
                    width: 200,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            // vendor activate and block accts button ui
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // active Vendors
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => VerifiedSellersScreen(),
                        ));
                  },
                  child: Image.asset(
                    "images/verified_seller.png",
                    width: 200,
                  ),
                ),
                SizedBox(
                  width: 200,
                ),
                // block vendor
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => BlockedSellersScreen(),
                        ));
                  },
                  child: Image.asset(
                    "images/blocked_seller.png",
                    width: 200,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
