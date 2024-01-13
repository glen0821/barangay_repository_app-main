// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';
import 'package:barangay_repository_app/firebase_query.dart';
import 'package:barangay_repository_app/global/responsive_sizing.dart';
import 'package:barangay_repository_app/widgets/containers/auth/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:barangay_repository_app/constants/colors.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

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
 final TextEditingController _firstNameController = TextEditingController();
 final TextEditingController _lastNameController = TextEditingController();
 final TextEditingController _middleInitialController = TextEditingController();
 final TextEditingController _suffixNameController = TextEditingController();
 final TextEditingController _emailController = TextEditingController();
 final TextEditingController _addressController = TextEditingController();
 final TextEditingController _lengthOfStayController = TextEditingController();
 final TextEditingController _precintNumberController =
 TextEditingController();
 final TextEditingController _ageController = TextEditingController();
  // TextEditingController _bioController = TextEditingController();
  bool _isEditMode = false;
  bool? _isFingerprintOn = false;
  final ImagePicker _picker = ImagePicker();
  String? imageURL;


 @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _lengthOfStayController.dispose();
    _precintNumberController.dispose();
    _ageController.dispose();
    // _bioController.dispose();
    super.dispose();
  }


 @override
 void initState() {
   // _isFingerprintOn =  storage.getItem('fingerprint');
   if (storage.getItem('fingerprint') != null) {
     _isFingerprintOn = true;
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
         _ageController.text = value['age'];
         _firstNameController.text = value['firstName'];
         _lastNameController.text = value['lastName'];
         _middleInitialController.text = value['middleInitial'];
         _suffixNameController.text = value['suffixName'];
         imageURL = value['profileURL'];
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

 void toggleEdit() {
   if (_isEditMode) {
     // Save profile logic here
     String firstName = _firstNameController.text;
     String lastName = _lastNameController.text;
     String middleInitial = _middleInitialController.text;
     String suffixName = _suffixNameController.text;
     String email = _emailController.text;
     String address = _addressController.text;
     String lengthOfStay = _lengthOfStayController.text;
     String precintNumber = _precintNumberController.text;
     String age = _ageController.text;
     if (firstName != '' ||
         lastName != '' ||
         middleInitial != '' ||
         lastName != '' ||
         email != '' ||
         address != '' ||
         lengthOfStay != '' ||
         precintNumber != '') {
       setState(() {
         _isEditMode = false;
       });

       firebaseQuery.updateProfile(
           firstName,
           lastName,
           middleInitial,
           suffixName,
           lengthOfStay,
           precintNumber,
           address,
           _auth.currentUser,
           age);
     } else {
       Alert(
           context: context,
           type: AlertType.error,
           desc: "Profile information cannot be empty.",
           closeFunction: null,
           closeIcon: null,
           buttons: [
             DialogButton(
                 onPressed: (() => Navigator.pop(context)),
                 child: const Text('OK'))
           ]).show();
     }
   } else {
     setState(() {
       _isEditMode = !_isEditMode;
     });
   }
 }

 void pickPhoto() async {
   final ImagePickerPlatform imagePickerImplementation =
       ImagePickerPlatform.instance;
   if (imagePickerImplementation is ImagePickerAndroid) {
     imagePickerImplementation.useAndroidPhotoPicker = true;
   }
   XFile? image = await _picker.pickImage(source: ImageSource.gallery);
   Fluttertoast.showToast(
       msg: "Uploading Image",
       toastLength: Toast.LENGTH_SHORT,
       gravity: ToastGravity.CENTER,
       timeInSecForIosWeb: 1,
       backgroundColor: Color.fromARGB(137, 0, 0, 0),
       textColor: Colors.white,
       fontSize: 16.0);
   if (image != null) {
     String? downloadUrl = await uploadImageToFirebaseStorage(
         image, "${_auth.currentUser!.uid}.png");
     if (downloadUrl != null) {
       await firestoreDB
           .collection('votersList')
           .doc(_auth.currentUser!.uid)
           .update({'profileURL': downloadUrl});
       setState(() {
         imageURL = downloadUrl;
       });
     }
   }
 }

 Future<String?> uploadImageToFirebaseStorage(
     XFile? imageFile, filename) async {
   if (imageFile == null) return null;

   File file = File(imageFile.path);
   String fileName = DateTime.now().millisecondsSinceEpoch.toString();

   try {
     await FirebaseStorage.instance.ref('images/$fileName').putFile(file);
     String downloadURL = await FirebaseStorage.instance
         .ref('images/$fileName')
         .getDownloadURL();

     return downloadURL;
   } catch (e) {
     print('Error uploading image to Firebase Storage: $e');
     return null;
   }
 }


 @override
  Widget build(BuildContext context) {
    ResponsiveSizing responsive = ResponsiveSizing(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                          GestureDetector(
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: imageURL == null
                                  ? Image.asset(
                                'assets/avatar.png',
                              )
                                  : Image.network(imageURL!),
                            ),
                            onTap: () => {
                              if (_isEditMode) {pickPhoto()}
                            },
                          ),
                          IconButton(
                            icon: Icon(_isEditMode ? Icons.done : Icons.edit),
                            onPressed: toggleEdit,
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
                        Row(
                          // direction: Axis.horizontal,
                          children: [
                            buildProfileField(
                              icon: Icons.abc_rounded,
                              label: _isEditMode ? 'First Name' : 'Name',
                              controller: _firstNameController,
                              enabled: _isEditMode,
                              inRow: true,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            buildProfileField(
                              // icon: Icons.abc_rounded,
                              label: _isEditMode ? 'M.I.' : '',
                              controller: _middleInitialController,
                              enabled: _isEditMode,
                              inRow: true,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            buildProfileField(
                              // icon: Icons.abc_rounded,
                              label: _isEditMode ? 'Last Name' : '',
                              controller: _lastNameController,
                              enabled: _isEditMode,
                              inRow: true,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            buildProfileField(
                              // icon: Icons.abc_rounded,
                              label: _isEditMode ? 'Suffix' : '',
                              controller: _suffixNameController,
                              enabled: _isEditMode,
                              inRow: true,
                            ),
                          ],
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
                        Row(
                          children: [
                            Text('With Fingerprint'),
                            Switch(
                              value: _isFingerprintOn!,
                              onChanged: (value) {
                                setState(() {
                                  _isFingerprintOn = value;
                                });
                                if (value) {
                                  storage.setItem('fingerprint', 'yes');
                                  storage.setItem('email', _emailController.text);
                                } else {
                                  storage.clear();
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        SizedBox(
                          width: responsive
                              .calc_width(MediaQuery.of(context).size.width),
                          child: ElevatedButton(
                            onPressed: _isEditMode
                                ? () {
                              // Save profile logic here
                              String firstName = _firstNameController.text;
                              String lastName = _lastNameController.text;
                              String middleInitial =
                                  _middleInitialController.text;
                              String suffixName =
                                  _suffixNameController.text;
                              String email = _emailController.text;
                              String address = _addressController.text;
                              String lengthOfStay =
                                  _lengthOfStayController.text;
                              String precintNumber =
                                  _precintNumberController.text;
                              String age = _ageController.text;
                              if (firstName != '' ||
                                  lastName != '' ||
                                  middleInitial != '' ||
                                  suffixName != '' ||
                                  email != '' ||
                                  address != '' ||
                                  lengthOfStay != '' ||
                                  precintNumber != '') {
                                setState(() {
                                  _isEditMode = false;
                                });

                                firebaseQuery.updateProfile(
                                    firstName,
                                    lastName,
                                    middleInitial,
                                    suffixName,
                                    lengthOfStay,
                                    precintNumber,
                                    address,
                                    _auth.currentUser,
                                    age);
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
                        Visibility(
                          visible: !_isEditMode,
                          child: SizedBox(
                              width: responsive
                                  .calc_width(MediaQuery.of(context).size.width),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed)) {
                                        return Colors.red;
                                      }
                                      return Colors.red;
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  firebaseQuery.logout(_auth, (value) {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  });
                                },
                                child: Text('Logout'),
                              )),
                        )
                      ],
                    ))
              ],
            ),
          )),
    );
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

 Widget buildProfileField(
     {IconData? icon,
       required String label,
       required TextEditingController controller,
       bool enabled = false,
       int maxLines = 1,
       bool inRow = false,
       TextInputType? inputType}) {
   return enabled
       ? inRow
       ? Flexible(
     child: TextField(
       controller: controller,
       maxLines: maxLines,
       decoration: InputDecoration(
         labelText: label,
       ),
     ),
   )
       : TextField(
     controller: controller,
     maxLines: maxLines,
     decoration: InputDecoration(
       labelText: label,
     ),
     keyboardType: inputType,
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
