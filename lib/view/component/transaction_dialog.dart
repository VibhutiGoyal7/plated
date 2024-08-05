import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../model/response/transactionListReponse.dart';
import '../../utils/Util.dart';

/*
class TransactionDialog extends StatelessWidget {
  final TransactionDetails transaction;

  TransactionDialog({required this.transaction});*/
/*

  void _onKeyPressed(String value) {
    onKeyTap(value);
  }
*/

class TransactionDialog {
  /*final TransactionDetails transaction;
  final String symbol;

  TransactionDialog({required this.transaction,required this.symbol});*/

  static Future<void> showDialogBox({
    required BuildContext context,
    required TransactionDetails? transaction,
    required String symbol,
  }) {
    return showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              scrollable: true,
              insetPadding: EdgeInsets.all(10),
              contentPadding:
              EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    margin: EdgeInsets.only(bottom: 6),
                    child: Wrap(
                      spacing: 20,
                      children: <Widget>[
                        SizedBox(
                          height: 4,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            capitalizeFirstLetter("${transaction?.transactionType}"),
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                        ),
                        Column(
                          children: [
                            /*transaction.bankService != null
                                ? Column(
                              children: [
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Bank Service :"),
                                    Text(capitalizeFirstLetter(
                                        "${transaction.bankService}"))
                                  ],
                                ),
                              ],
                            )
                                : SizedBox(),*/
                            SizedBox(
                              height: 8,
                            ),
                            transaction?.amount != null
                                ? Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Amount :"),
                                Text(
                                    addCurrencySymbolTransaction(
                                        symbol,
                                        "${transaction?.amount}",
                                        capitalizeFirstLetter(
                                            "${transaction?.transactionType}")),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: colorPaymentType(
                                            capitalizeFirstLetter(
                                                "${transaction?.transactionType}"))))
                              ],
                            )
                                : SizedBox(),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Status :"),
                                Text(
                                  capitalizeFirstLetter(
                                      "${transaction?.status}"),
                                  style: TextStyle(
                                      color: colorStatus(capitalizeFirstLetter(
                                          "${transaction?.status}"), context)),
                                )
                              ],
                            ),
                            /*transaction.bankType != null
                                ? Column(
                              children: [
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Bank Type :"),
                                    Text(capitalizeFirstLetter(
                                        "${transaction.bankType}"))
                                  ],
                                ),
                              ],
                            )
                                : SizedBox(),*/
                            SizedBox(
                              height: 8,
                            ),
                           /* Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Currency :"),
                                Text("${transaction.currency}")
                              ],
                            ),*/
                            /*SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Request Type"),
                            Text("${transaction.requestType}")
                          ],
                        ),*/
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Payment Request Id :"),
                                Text("${transaction?.uniqueId}")
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
