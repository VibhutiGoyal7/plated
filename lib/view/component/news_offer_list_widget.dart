import 'package:flutter/material.dart';

import '../../model/response/offersResponse.dart';

class NewsOfferListWidget extends StatelessWidget {
  late final List<OfferResponse> data;

  //NewsOfferListWidget(ScrollController scrollController);

  NewsOfferListWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      height: 130,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        //controller: _scrollController,
        itemCount: data.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 5),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            width: screenWidth / 2.8,
            child: Center(
                child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              margin: EdgeInsets.zero,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        topLeft: Radius.circular(15.0)),
                    child: Image.network(
                      data[index].image,
                      width: screenWidth,
                      height: 50,
                      fit: BoxFit.none,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 28,
                      width: 50,
                      child: Card(
                        child: Center(child: Text(data[index].daysLeft, style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold
                        ),)),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 40,),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                              width: screenWidth,
                              padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5,),
                                  Text(
                                    data[index].title,
                                    style: TextStyle(fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    data[index].description,
                                    style: TextStyle(fontSize: 11),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ))),
                    ],
                  ),

                ],
              ),
            )),
          );
          // I omit the part to build card items from the list
        },
      ),
    );
  }
}
