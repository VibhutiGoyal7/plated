import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransferScreen extends StatefulWidget{
  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Send", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                    SizedBox(width: double.infinity,height: 1.0, child: Container(
                    color: Colors.black12,
                    ),),
                    SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: 1.0,
                    ),
                    Text("Currently you cannot send money because action is disabled", textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: 1.0,
                    )
                ]
              ),
            )
        )
    );
  }
}