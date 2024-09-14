import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_app_web_admin/functions/functions.dart';
import 'package:users_app_web_admin/homeScreen/home_screen.dart';
import 'package:users_app_web_admin/widgets/nav_appbar.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  QuerySnapshot? allBlockedUsers;

  showDialogBox(userDocumentId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Activate Account',
              style: TextStyle(
                fontSize: 25,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Do you want to activate this account?',
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'No',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Map<String, dynamic> userDataMap = {
                    'status': 'approved',
                  };

                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(userDocumentId)
                      .update(userDataMap)
                      .whenComplete(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => HomeScreen()));

                    showReusableSnackBar(
                      context,
                      'Activated successfully',
                    );
                  });
                },
                child: Text(
                  'Yes',
                ),
              ),
            ],
          );
        });
  }

  getAllBlockedUsers() async {
    FirebaseFirestore.instance
        .collection('users')
        .where('status', isEqualTo: 'not approved')
        .get()
        .then((getAllBlockedUsers) {
      setState(() {
        allBlockedUsers = getAllBlockedUsers;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getAllBlockedUsers();
  }

  @override
  Widget build(BuildContext context) {
    Widget blockedUsersDesign() {
      if (allBlockedUsers == null) {
        return Center(
          child: Text(
            'No Records Found',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        );
      } else {
        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: allBlockedUsers!.docs.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      width: 100,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            allBlockedUsers!.docs[index].get('photoUrl'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    allBlockedUsers!.docs[index].get('name'),
                  ),
                  Text(
                    allBlockedUsers!.docs[index].get('email'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialogBox(allBlockedUsers!.docs[index].id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18.0, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/activate.png',
                            width: 56,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Activate Now',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    }

    return Scaffold(
      appBar: NavAppbar(
        title: 'Blocked Users Account',
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: blockedUsersDesign(),
        ),
      ),
    );
  }
}
