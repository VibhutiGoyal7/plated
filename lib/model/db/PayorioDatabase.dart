// database.dart

// required package imports
import 'dart:async';
import 'package:Payrio/model/db/dao.dart';
import 'package:Payrio/model/response/dashboardResponse.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../response/transactionListReponse.dart';

part 'PayorioDatabase.g.dart'; // the generated code will be there

@Database(version: 1, entities: [CustomerData, TransactionDetails])
abstract class PayorioDatabase extends FloorDatabase {
  CustomerDataDao get personDao;
  DashboardTransactionDao get dashboardTransactionDao;
}