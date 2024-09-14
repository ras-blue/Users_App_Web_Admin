import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_app_web_admin/functions/functions.dart';
import 'package:users_app_web_admin/homeScreen/home_screen.dart';
import 'package:users_app_web_admin/widgets/nav_appbar.dart';

class VerifiedSellersScreen extends StatefulWidget {
  const VerifiedSellersScreen({super.key});

  @override
  State<VerifiedSellersScreen> createState() => _VerifiedSellersScreenState();
}

class _VerifiedSellersScreenState extends State<VerifiedSellersScreen> {
  QuerySnapshot? allApprovedVendors;

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
                  Map<String, dynamic> vendorDataMap = {
                    'status': 'not approved',
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

  getAllVerifiedVendors() async {
    FirebaseFirestore.instance
        .collection('vendor')
        .where('status', isEqualTo: 'approved')
        .get()
        .then((allVerifiedVendors) {
      setState(() {
        allApprovedVendors = allVerifiedVendors;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getAllVerifiedVendors();
  }

  @override
  Widget build(BuildContext context) {
    Widget verifiedVendorsDesign() {
      if (allApprovedVendors == null) {
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
          itemCount: allApprovedVendors!.docs.length,
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
                            allApprovedVendors!.docs[index].get('photoUrl'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    allApprovedVendors!.docs[index].get('name'),
                  ),
                  Text(
                    allApprovedVendors!.docs[index].get('email'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //block now
                      GestureDetector(
                        onTap: () {
                          showDialogBox(allApprovedVendors!.docs[index].id);
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

                      //earnings
                      GestureDetector(
                        onTap: () {
                          showReusableSnackBar(
                            context,
                            'Total Earnings = '.toUpperCase() +
                                'N' +
                                allApprovedVendors!.docs[index]
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
                                    allApprovedVendors!.docs[index]
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
        title: 'Verified Vendors Account',
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: verifiedVendorsDesign(),
        ),
      ),
    );
  }
}
