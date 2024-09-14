import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_app_web_admin/functions/functions.dart';
import 'package:users_app_web_admin/homeScreen/home_screen.dart';
import 'package:users_app_web_admin/widgets/nav_appbar.dart';

class BlockedSellersScreen extends StatefulWidget {
  const BlockedSellersScreen({super.key});

  @override
  State<BlockedSellersScreen> createState() => _BlockedSellersScreenState();
}

class _BlockedSellersScreenState extends State<BlockedSellersScreen> {
  QuerySnapshot? allBlockedVendors;

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
                  Map<String, dynamic> vendorDataMap = {
                    'status': 'approved',
                  };

                  FirebaseFirestore.instance
                      .collection('vendor')
                      .doc(userDocumentId)
                      .update(vendorDataMap)
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

  getAllBlockedVendors() async {
    FirebaseFirestore.instance
        .collection('vendor')
        .where('status', isEqualTo: 'not approved')
        .get()
        .then((getAllBlockedVendors) {
      setState(() {
        allBlockedVendors = getAllBlockedVendors;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getAllBlockedVendors();
  }

  @override
  Widget build(BuildContext context) {
    Widget blockedVendorsDesign() {
      if (allBlockedVendors == null) {
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
          itemCount: allBlockedVendors!.docs.length,
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
                            allBlockedVendors!.docs[index].get('photoUrl'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    allBlockedVendors!.docs[index].get('name'),
                  ),
                  Text(
                    allBlockedVendors!.docs[index].get('email'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialogBox(allBlockedVendors!.docs[index].id);
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
                      //earnings
                      GestureDetector(
                        onTap: () {
                          showReusableSnackBar(
                            context,
                            'Total Earnings = '.toUpperCase() +
                                'N' +
                                allBlockedVendors!.docs[index]
                                    .get('earnings')
                                    .toString(),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18.0, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/earnings.png',
                                width: 56,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'N' +
                                    allBlockedVendors!.docs[index]
                                        .get('earnings')
                                        .toString(),
                                style: TextStyle(
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
        title: 'Blocked Vendors Account',
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: blockedVendorsDesign(),
        ),
      ),
    );
  }
}
