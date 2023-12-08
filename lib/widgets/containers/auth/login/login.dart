// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'package:barangay_repository_app/firebase_query.dart';
import 'package:barangay_repository_app/widgets/containers/auth/login/login_functions.dart';
import 'package:barangay_repository_app/widgets/containers/auth/register/register.dart';
import 'package:barangay_repository_app/widgets/containers/pages/tabs/main_tab.dart';
import 'package:barangay_repository_app/widgets/core/core_button/core_button.dart';
import 'package:barangay_repository_app/widgets/core/core_textfield/core_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Biometrics
  LocalAuthentication auth = LocalAuthentication();
  final LocalStorage storage = LocalStorage('fingerprint');
  late bool _canCheckBiometric;
  late List<BiometricType> _availableBiometrics;
  String autherized = "Not autherized";
  FirebaseQuery firebaseQuery = FirebaseQuery();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Secured storage 
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<void> setUserData(String key, String value) async {
    await secureStorage.write(key: key, value: value);
  }

  bool isLoading = false;


  Future<void> _checkBiometric() async{
    bool canCheckBiometric = false;
    try{
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e){
      print(e);
    }
    if(!mounted) return;
    setState(() {
      _canCheckBiometric =  canCheckBiometric;
    });
  }

  Future<void> _getAvailableBiometric() async{
    List<BiometricType> availableBiometric = [];
    try{
      availableBiometric = await auth.getAvailableBiometrics();
    }on PlatformException catch(e){
      print(e);
    }
    setState(() {
      _availableBiometrics = availableBiometric;
    });
  }

  Future<void> _authenticate() async{
    bool authenticated =  false;
    try{
      authenticated =  await auth.authenticate(
        localizedReason: "Scan your finger to authenticate",
        options: const AuthenticationOptions(useErrorDialogs: true, stickyAuth: false)
        );
    }on PlatformException catch(e){
      print(e);
    }
    if(!mounted) return;
    print(storage.getItem('fingerprint'));
    print(storage.getItem('email'));
    print(storage.getItem('password'));
      if(storage.getItem('fingerprint') != null){

         LoginFunctions loginFunctions = LoginFunctions(
                        storage.getItem('email'),
                        storage.getItem('password'),
                        firebaseQuery,
                        context);

                    loginFunctions.loginAcount().then((value) {
                      if (value) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MainTab()));
                      }
                    });
      }else{
        
         Alert(
            context: context,
            type: AlertType.error,
            desc: 'Your biometrics is not yet enabled.',
            closeFunction: null,
            buttons: [
              DialogButton(
                  onPressed: (() {
                    Navigator.pop(context!);
                  }),
                  child: const Text('OK'))
            ]).show();
      }
  }



  @override
  void initState() {
    super.initState();
    firebaseQuery.main();
    _checkBiometric();
    _getAvailableBiometric();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoading
                    ? Center(
                        child:
                            CircularProgressIndicator(), // Add CircularProgressIndicator widget here
                      )
                    : Container(),
                Text(
                  'Barangay San Nicolas III Appointment APP',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
                ),
                 SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.asset(
                            'assets/sn3.png',
                          ),
                        ),
                SizedBox(
                  height: 16,
                ),
                CoreTextfield(
                  labelText: 'Email',
                  controller: emailController,
                ),
                SizedBox(height: 16.0),
                CoreTextfield(
                  labelText: 'Password',
                  controller: passwordController,
                  obscureText: true,
                ),
                SizedBox(height: 16),
                CoreButton(
                  text: 'Login',
                  onPressed: () async{
                    setState(() {
                      isLoading = true;
                    });
                    LoginFunctions loginFunctions = LoginFunctions(
                        emailController.text,
                        passwordController.text,
                        firebaseQuery,
                        context);

                    loginFunctions.loginAcount().then((value) {
                      setState(() {
                        isLoading = false;
                      });
                      if (value) {
                        storage.setItem('password', passwordController.text);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MainTab()));
                      }
                    });
                  },
                ),
                SizedBox(height: 10,),
                CoreButton(text: 'Login using Fingerprint', onPressed: _authenticate,),
                TextButton(
                    onPressed: (() => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()))
                        }),
                    child: Text("Don't have an account? Register here")),
                SizedBox(height: 10,),
                Text('HOTLINE NUMBERS',style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                SizedBox(height: 10,),
                Text('BRGY HALL (046)417 0773',textAlign: TextAlign.center,),
                SizedBox(height: 5,),
                Text('BDRRM ALERT 161',textAlign: TextAlign.center,),
                SizedBox(height: 5,),
                Text('BFD 046-4176060',textAlign: TextAlign.center,),
                SizedBox(height: 5,),
                Text('PNP 046-4176366',textAlign: TextAlign.center,),
                SizedBox(height: 10,),
                Text('Office hourse',textAlign: TextAlign.center,),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   SizedBox(
                          width: 42,
                          height: 42,
                          child: Image.asset(
                            'assets/call.png',
                          ),
                        ),
                  Text('Monday to Friday, 8AM to 5PM',textAlign: TextAlign.center,),
                ],)
                
              ],
            ),
          ))),
    );
  }
}
