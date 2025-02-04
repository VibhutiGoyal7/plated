// database.dart

// required package imports
import 'dart:async';
import 'package:Plated/model/db/dao.dart';
import 'package:Plated/model/response/dashboardResponse.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../response/notificationListResponse.dart';
import '../response/transactionListReponse.dart';

part 'PlatedDatabase.g.dart'; // the generated code will be there

@Database(version: 1, entities: [CustomerData, TransactionDetails, NotificationDetail])
abstract class PlatedDatabase extends FloorDatabase {
  CustomerDataDao get personDao;
  DashboardTransactionDao get dashboardTransactionDao;
  NotificationDao get notificationDao;
}