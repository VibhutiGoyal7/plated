// database.dart

// required package imports
import 'dart:async';
import 'package:FlutterBasicStructure/model/db/dao.dart';
import 'package:FlutterBasicStructure/model/response/dashboardResponse.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../response/notificationListResponse.dart';
import '../response/transactionListReponse.dart';

part 'PayorioDatabase.g.dart'; // the generated code will be there

@Database(version: 1, entities: [CustomerData, TransactionDetails, NotificationDetail])
abstract class BasicStructureDatabase extends FloorDatabase {
  CustomerDataDao get personDao;
  DashboardTransactionDao get dashboardTransactionDao;
  NotificationDao get notificationDao;
}