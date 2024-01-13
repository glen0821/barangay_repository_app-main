import 'package:flutter/material.dart';


void showTransactionReceipt(BuildContext context, String transactionId,) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(15),
        title: Column(
          children: [
            Center(
              child: Image.asset(
                  'assets/paypal.png',
                  width: 200,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Transaction Receipt',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: SizedBox(
          height: 360,
          width: 600,
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(5, (index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                      leading: Text(
                        label(index),
                        style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        Value(index, transactionId),
                        style: const TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                    const Divider(),
                  ],
                );
              }),
            ),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Powered by: ',
                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 10),
              Image.asset(
                'assets/paypal.png',
                width: 60,
                height: 60,
              ),
              const SizedBox(width: 10),

            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              transactionId = '';
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF253B80)),
              minimumSize: MaterialStateProperty.all(const Size(double.infinity, 40)),
            ),
            child: const Text(
              'CONFIRM',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],

      );
    },
  );
}

String label(int index) {
  switch (index) {
    case 0:
      return 'Transaction ID:\n\n\n';
    case 1:
      return 'Transaction Date';
    case 2:
      return 'Amount Paid';
    case 3:
      return 'Item';
    case 4:
      return 'Quantity';
    default:
      return '';
  }
}

String Value(int index, String transactionId) {
  switch (index) {
    case 0:
      return transactionId;
    case 1:
      return dateToday();
    case 2:
      return '₱100.00';
    case 3:
      return 'Barangay ID Card';
    case 4:
      return '1 pcs.';
    default:
      return '';
  }
}

String dateToday() {
  DateTime now = DateTime.now();
  String formattedDate = '${now.month.toString().padLeft(2, '0')}/'
      '${now.day.toString().padLeft(2, '0')}/'
      '${now.year}';
  return formattedDate;
}

Future<bool> showPaypalConfirmationDialog(BuildContext context) async {
  bool shouldProceed = false;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(15),
        title: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/paypal.png',
                width: 200,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Confirmation',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: const SizedBox(
          width: 600,
          height: 200,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Before proceeding make sure that:',
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  '‣ You have a PayPal account',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                Text(
                  '‣ You have a ₱100.00 balance in your PayPal account',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                Text(
                  '‣ The item you will be paying is for Barangay ID',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          )
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              minimumSize: MaterialStateProperty.all(const Size(double.infinity, 40)),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              shouldProceed = true;
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF253B80)),
              minimumSize: MaterialStateProperty.all(const Size(double.infinity, 40)),
            ),
            child: const Text(
              'Proceed',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    },
  );

  return shouldProceed;
}

Future<bool> showAppointmentConfirmationDialog(BuildContext context) async {
  bool shouldProceed = false;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(15),
        title: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/id-boy.png',
                width: 200,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Before proceeding',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: const SizedBox(
            width: 600,
            height: 100,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Take Note:',
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    '‣ Bring any valid I.D for verification on the date of your appointment',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            )
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              minimumSize: MaterialStateProperty.all(const Size(double.infinity, 40)),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              shouldProceed = true;
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF253B80)),
              minimumSize: MaterialStateProperty.all(const Size(double.infinity, 40)),
            ),
            child: const Text(
              'Proceed',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    },
  );

  return shouldProceed;
}

Future<void> showMediaOptionDialog(BuildContext context, Function(bool isImage) onOptionSelected) async {
  await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Pick Image'),
            onTap: () {
              Navigator.pop(context);
              onOptionSelected(true);//true kapag image
            },
          ),
          ListTile(
            leading: const Icon(Icons.videocam),
            title: const Text('Pick Video'),
            onTap: () {
              Navigator.pop(context);
              onOptionSelected(false); // false kapag video
            },
          ),
        ],
      );
    },
  );
}

