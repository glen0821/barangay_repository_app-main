import 'package:barangay_repository_app/widgets/core/core_button/core_button.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class VerifyUserEmailPage extends StatefulWidget {
  final String email;
  const VerifyUserEmailPage({Key? key, required this.email}) : super(key: key);
  @override
  _VerifyUserEmailPageState createState() => _VerifyUserEmailPageState();
}

class _VerifyUserEmailPageState extends State<VerifyUserEmailPage> {
  late List<FocusNode> _otpFocusNodes;
  late List<TextEditingController> _otpControllers;

  late EmailAuth emailAuth;

  @override
  void initState() {
    super.initState();
    emailAuth = EmailAuth(
      sessionName: "Sample session",
    );

    _otpFocusNodes = List.generate(6, (index) => FocusNode());
    _otpControllers = List.generate(
      6,
          (index) => TextEditingController(),
    );
    sendOtp();
  }

  @override
  void dispose() {
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }

    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  bool verify() {
    bool validationResult = emailAuth.validateOtp(
      recipientMail: widget.email,
      userOtp: _otpControllers.map((controller) => controller.text).join(),
    );
    print(validationResult);
    return validationResult;
  }

  void verifyAndPop() {
    bool isVerified = verify();
    if (isVerified) {

      Navigator.pop(context, true);
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        desc: "Wrong OTP. Do you want to resend the code?",
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
              sendOtp();
            },
            child: const Text('Resend'),
          ),
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ).show();
    }
  }


  void sendOtp() async {
    bool result = await emailAuth.sendOtp(
      recipientMail: widget.email,
      otpLength: 6,
    );
    if (result) {
      setState(() {
       print("succesful senttttttttttttt");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 30),
            const Text(
              'VERIFICATION',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
            const SizedBox(height: 80),
             Text(
              'Enter the 6-digit code that was sent to\n${widget.email}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF7F7F7F),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                6,
                    (index) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
                      controller: _otpControllers[index],
                      focusNode: _otpFocusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      onChanged: (value) {
                        for (var controller in _otpControllers) {
                          print(controller.text);
                        }
                        if (value.isNotEmpty) {
                          if (index < _otpFocusNodes.length - 1) {
                            FocusScope.of(context).requestFocus(
                                 _otpFocusNodes[index + 1]);
                          } else {
                            // Handle submission or verification here
                            // _handleSubmitted();
                          }
                        } else {
                          for (var i = 0; i < _otpControllers.length; ++i) {
                            _otpControllers[i].addListener(() {
                              if (_otpControllers[i].text.isEmpty) {
                                FocusScope.of(context).requestFocus(
                                    _otpFocusNodes[i - 1]);
                              }
                            });
                          }
                        }
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onSaved: (value) {},
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            CoreButton(
              text: 'Verify',
              onPressed: () {
               verifyAndPop();
              },
            ),
            const SizedBox(height: 80),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Did not receive a code?',
                    style: TextStyle(
                      color: Color(0xFF7F7F7F),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: ' Resend',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        sendOtp();
                      },
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
