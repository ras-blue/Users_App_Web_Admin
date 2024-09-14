import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_app_web_admin/functions/functions.dart';
import 'package:users_app_web_admin/homeScreen/home_screen.dart';
import 'package:users_app_web_admin/widgets/nav_appbar.dart';

class VerifiedUsersScreen extends StatefulWidget {
  const VerifiedUsersScreen({super.key});

  @override
  State<VerifiedUsersScreen> createState() => _VerifiedUsersScreenState();
}

class _VerifiedUsersScreenState extends State<VerifiedUsersScreen> {
  QuerySnapshot? allApprovedUsers;

  showDialogBox(userDocumentId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Block Account',
              style: TextStyle(
                fontSize: 25,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Do you want to block this account?',
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
                    'status': 'not approved',
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
                      'Blocked successfully',
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

  getAllVerifiedUsers() async {
    FirebaseFirestore.instance
        .collection('users')
        .where('status', isEqualTo: 'approved')
        .get()
        .then((allVerifiedUsers) {
      setState(() {
        allApprovedUsers = allVerifiedUsers;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getAllVerifiedUsers();
  }

  @override
  Widget build(BuildContext context) {
    Widget verifiedUsersDesign() {
      if (allApprovedUsers == null) {
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
          itemCount: allApprovedUsers!.docs.length,
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
                            allApprovedUsers!.docs[index].get('photoUrl'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    allApprovedUsers!.docs[index].get('name'),
                  ),
                  Text(
                    allApprovedUsers!.docs[index].get('email'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialogBox(allApprovedUsers!.docs[index].id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18.0, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/block.png',
                            width: 56,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Block Now',
                            style: TextStyle(
                              color: Colors.redAccent,
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
        title: 'Verified Users Account',
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: verifiedUsersDesign(),
        ),
      ),
    );
  }
}
