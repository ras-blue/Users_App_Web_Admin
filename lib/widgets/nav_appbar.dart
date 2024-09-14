import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:users_app_web_admin/authentication/login_screen.dart';
import 'package:users_app_web_admin/homeScreen/home_screen.dart';

// ignore: must_be_immutable
class NavAppbar extends StatefulWidget implements PreferredSizeWidget {
  PreferredSizeWidget? preferredSizeWidget;
  String? title;

  NavAppbar({
    this.preferredSizeWidget,
    this.title,
  });

  @override
  State<NavAppbar> createState() => _NavAppbarState();

  @override
  Size get preferredSize => preferredSizeWidget == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

class _NavAppbarState extends State<NavAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pinkAccent,
              Colors.deepPurpleAccent,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(
              1.0,
              0.0,
            ),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
      title: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => HomeScreen()));
        },
        child: Text(
          widget.title.toString(),
          style: TextStyle(
            fontSize: 26,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      centerTitle: false,
      actions: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => HomeScreen()));
                },
                child: Text(
                  "Home",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Text(
              "|",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Sellers PieChart",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Text(
              "|",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Users PieChart",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Text(
              "|",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => LoginScreen(),
                    ),
                  );
                },
                child: Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
