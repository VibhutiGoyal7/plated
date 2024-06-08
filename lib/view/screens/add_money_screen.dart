import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class AddMoneyScreen extends StatefulWidget {
  final NavController? navController;

  AddMoneyScreen({this.navController});

  @override
  _AddMoneyScreenState createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  String amount = "";
  bool expanded = false;

  final List<Map<String, dynamic>> items = [
    {'icon': 'assets/united_states_flag_icon.svg', 'label': 'USD'},
    {'icon': 'assets/india_flag_icon.svg', 'label': 'INR'},
  ];

  Map<String, dynamic> selectedItem = {
    'icon': 'assets/united_states_flag_icon.svg',
    'label': 'USD'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      widget.navController?.navigateUp();
                    },
                    child: Icon(Icons.arrow_back_ios)
                  ),
                ),
                Text(
                  'Add Money',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontFamily: 'popins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 1.0,
              child: Container(
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Enter amount',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontFamily: 'popins',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: '0.0',
                  labelStyle: TextStyle(fontFamily: 'popins'),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    amount = value;
                  });
                },
                cursorColor: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: amount.isNotEmpty
                          ? () {
                        widget.navController?.navigate(Screen.VerifyIdentityScreen.route);
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        /*primary: amount.isNotEmpty
                            ? Theme.of(context).colorScheme.onBackground
                            : Theme.of(context).colorScheme.onSecondary,*/
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(fontFamily: 'popins'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavController {
  void navigateUp() {
    // Implement navigation logic
  }

  void navigate(String route) {
    // Implement navigation logic
  }
}

class Screen {
  static const VerifyIdentityScreen = Screen._('VerifyIdentityScreen');

  final String route;

  const Screen._(this.route);
}
