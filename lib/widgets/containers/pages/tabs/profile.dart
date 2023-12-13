// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:barangay_repository_app/firebase_query.dart';
import 'package:barangay_repository_app/global/responsive_sizing.dart';
import 'package:barangay_repository_app/widgets/containers/auth/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:barangay_repository_app/constants/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
 final LocalStorage storage = LocalStorage('fingerprint');
  final FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseQuery firebaseQuery = FirebaseQuery();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _lengthOfStayController = TextEditingController();
  final TextEditingController _precintNumberController =
      TextEditingController();
  // TextEditingController _bioController = TextEditingController();
  bool _isEditMode = false;
  bool? _isFingerprintOn = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _lengthOfStayController.dispose();
    _precintNumberController.dispose();
    // _bioController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // _isFingerprintOn =  storage.getItem('fingerprint');
    if(storage.getItem('fingerprint') != null){
      _isFingerprintOn =  true;
      print(storage.getItem('fingerprint'));
    }
    var temp = firebaseQuery
        .getUserCredentials(_auth.currentUser!.uid.toString())
        .then(
      (value) {
        setState(() {
          _addressController.text = value['completeAddress'];
          _lengthOfStayController.text = value['lengthOfStay'];
          _precintNumberController.text = value['precintNumber'];
        });
      },
    );
    setState(() {
      _nameController.text = _auth.currentUser?.displayName as String;
      _emailController.text = _auth.currentUser?.email as String;
    });

    print(_auth.currentUser);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSizing responsive = ResponsiveSizing(context);
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Edit Profile'),
        //   actions: [],
        // ),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // height: responsive
                //     .calc_height(MediaQuery.of(context).size.height * 0.3),
                color: AppColors.primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.asset(
                            'assets/avatar.png',
                          ),
                        ),
                        IconButton(
                          icon: Icon(_isEditMode ? Icons.done : Icons.edit),
                          onPressed: () {
                            if (_isEditMode) {
                              // Save profile logic here
                              String name = _nameController.text;
                              String email = _emailController.text;
                              String address = _addressController.text;
                              String lengthOfStay =
                                  _lengthOfStayController.text;
                              String precintNumber =
                                  _precintNumberController.text;
                              if (name != '' ||
                                  email != '' ||
                                  address != '' ||
                                  lengthOfStay != '' ||
                                  precintNumber != '') {
                                setState(() {
                                  _isEditMode = false;
                                });

                                firebaseQuery.updateProfile(name, lengthOfStay,
                                    precintNumber, address, _auth.currentUser);
                              } else {
                                Alert(
                                    context: context,
                                    type: AlertType.error,
                                    desc:
                                        "Profile information cannot be empty.",
                                    closeFunction: null,
                                    closeIcon: null,
                                    buttons: [
                                      DialogButton(
                                          onPressed: (() =>
                                              Navigator.pop(context)),
                                          child: const Text('OK'))
                                    ]).show();
                              }
                            } else {
                              setState(() {
                                _isEditMode = !_isEditMode;
                              });
                            }
                          },
                        ),
                        // IconButton(
                        //     onPressed: () {
                        //       firebaseQuery.logout(_auth, (value) {
                        //         Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (context) => LoginPage()));
                        //       });
                        //     },
                        //     icon: Icon(Icons.exit_to_app))
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.0),
                      buildProfileField(
                        icon: Icons.abc_rounded,
                        label: 'Name',
                        controller: _nameController,
                        enabled: _isEditMode,
                      ),
                      SizedBox(height: 20.0),
                      buildProfileField(
                        icon: Icons.pin_drop_rounded,
                        label: 'Address',
                        controller: _addressController,
                        enabled: _isEditMode,
                      ),
                      SizedBox(height: 20.0),
                      buildProfileField(
                        icon: Icons.calendar_view_day_rounded,
                        label: 'Length of Stay',
                        controller: _lengthOfStayController,
                        enabled: _isEditMode,
                      ),
                      SizedBox(height: 20.0),
                      buildProfileField(
                        icon: Icons.numbers_rounded,
                        label: 'Precint Number',
                        controller: _precintNumberController,
                        enabled: _isEditMode,
                      ),
                      SizedBox(height: 20.0),
                      buildProfileFieldDisabled(
                        icon: Icons.email_rounded,
                        label: 'Email',
                        controller: _emailController,
                      ),
                      SizedBox(height: 20.0),
                      Row(children: [
                        Text('With Fingerprint'),
                        Switch(value: _isFingerprintOn!, onChanged:(value) {
                          setState(() {
                            
                            _isFingerprintOn = value;
                          });
                          if(value){
                             storage.setItem('fingerprint', 'yes');
                             storage.setItem('email', _emailController.text);
                          }
                          else{
                            storage.clear();
                          }
                      },),
                      ],),
                      
                      SizedBox(height: 20.0),
                      SizedBox(
                        width: responsive
                            .calc_width(MediaQuery.of(context).size.width),
                        child: ElevatedButton(
                          onPressed: _isEditMode
                              ? () {
                                  // Save profile logic here
                                  String name = _nameController.text;
                                  String email = _emailController.text;
                                  String address = _addressController.text;
                                  String lengthOfStay =
                                      _lengthOfStayController.text;
                                  String precintNumber =
                                      _precintNumberController.text;
                                  if (name != '' ||
                                      email != '' ||
                                      address != '' ||
                                      lengthOfStay != '' ||
                                      precintNumber != '') {
                                    setState(() {
                                      _isEditMode = false;
                                    });

                                    firebaseQuery.updateProfile(
                                        name,
                                        lengthOfStay,
                                        precintNumber,
                                        address,
                                        _auth.currentUser);
                                  } else {
                                    Alert(
                                        context: context,
                                        type: AlertType.error,
                                        desc:
                                            "Profile information cannot be empty.",
                                        closeFunction: null,
                                        closeIcon: null,
                                        buttons: [
                                          DialogButton(
                                              onPressed: (() =>
                                                  Navigator.pop(context)),
                                              child: const Text('OK'))
                                        ]).show();
                                  }
                                }
                              : null,
                          child: Text('Save'),
                        ),
                      ),
                      SizedBox(
                          width: responsive
                              .calc_width(MediaQuery.of(context).size.width),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.red;
                                  }
                                  return Colors.red;
                                },
                              ),
                            ),
                            onPressed: () {
                              firebaseQuery.logout(_auth, (value) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              });
                            },
                            child: Text('Logout'),
                          ))
                    ],
                  ))
            ],
          ),
        ));
    // return Scaffold(
    //   body: Container(
    //       width: MediaQuery.of(context).size.width,
    //       child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             Text('Hello ${_auth.currentUser?.email}'),
    //             ElevatedButton(
    //                 onPressed: () => firebaseQuery.logout(_auth, (value) {
    //                       Navigator.push(
    //                           context,
    //                           MaterialPageRoute(
    //                               builder: (context) => LoginPage()));
    //                     }),
    //                 child: const Text('Logout'))
    //           ])),
    // );
  }

  Widget buildProfileField({
    IconData? icon,
    required String label,
    required TextEditingController controller,
    bool enabled = false,
    int maxLines = 1,
  }) {
    return enabled
        ? TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              labelText: label,
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.grey,
                    size: 16,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    label,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                controller.text,
                style: TextStyle(fontSize: 16.0),
              )
            ],
          );
  }

  Widget buildProfileFieldDisabled({
    IconData? icon,
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.grey,
              size: 16,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              label,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          controller.text,
          style: TextStyle(fontSize: 16.0),
        )
      ],
    );
  }
}
