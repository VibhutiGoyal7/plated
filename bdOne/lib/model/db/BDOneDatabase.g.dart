// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BDOneDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $BDOneDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $BDOneDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $BDOneDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<BDOneDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorBDOneDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $BDOneDatabaseBuilderContract databaseBuilder(String name) =>
      _$BDOneDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $BDOneDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$BDOneDatabaseBuilder(null);
}

class _$BDOneDatabaseBuilder implements $BDOneDatabaseBuilderContract {
  _$BDOneDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $BDOneDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $BDOneDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<BDOneDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$BDOneDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$BDOneDatabase extends BDOneDatabase {
  _$BDOneDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CustomerDataDao? _personDaoInstance;

  DashboardTransactionDao? _dashboardTransactionDaoInstance;

  NotificationDao? _notificationDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CustomerData` (`email` TEXT, `firstName` TEXT, `username` TEXT, `balance` TEXT, `countryName` TEXT, `countryPhoneCode` TEXT, `countryCurrencySymbol` TEXT, `imageUrl` TEXT, `kycStatus` TEXT, `tpin` TEXT, PRIMARY KEY (`email`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TransactionDetails` (`id` INTEGER, `amount` TEXT, `email` TEXT, `fullName` TEXT, `transactionType` TEXT, `uniqueId` TEXT, `username` TEXT, `phoneNumber` TEXT, `status` TEXT, `createdAt` TEXT, `senderUsername` TEXT, `senderFullName` TEXT, `receiverUsername` TEXT, `userId` INTEGER, `senderId` INTEGER, `receiverId` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `NotificationDetail` (`id` INTEGER, `title` TEXT, `message` TEXT, `notificationType` TEXT, `isRead` INTEGER, `createdAt` TEXT, `customerId` INTEGER, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CustomerDataDao get personDao {
    return _personDaoInstance ??= _$CustomerDataDao(database, changeListener);
  }

  @override
  DashboardTransactionDao get dashboardTransactionDao {
    return _dashboardTransactionDaoInstance ??=
        _$DashboardTransactionDao(database, changeListener);
  }

  @override
  NotificationDao get notificationDao {
    return _notificationDaoInstance ??=
        _$NotificationDao(database, changeListener);
  }
}

class _$CustomerDataDao extends CustomerDataDao {
  _$CustomerDataDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _customerDataInsertionAdapter = InsertionAdapter(
            database,
            'CustomerData',
            (CustomerData item) => <String, Object?>{
                  'email': item.email,
                  'firstName': item.firstName,
                  'username': item.username,
                  'balance': item.balance,
                  'countryName': item.countryName,
                  'countryPhoneCode': item.countryPhoneCode,
                  'countryCurrencySymbol': item.countryCurrencySymbol,
                  'imageUrl': item.imageUrl,
                  'kycStatus': item.kycStatus,
                  'tpin': item.tpin
                }),
        _customerDataUpdateAdapter = UpdateAdapter(
            database,
            'CustomerData',
            ['email'],
            (CustomerData item) => <String, Object?>{
                  'email': item.email,
                  'firstName': item.firstName,
                  'username': item.username,
                  'balance': item.balance,
                  'countryName': item.countryName,
                  'countryPhoneCode': item.countryPhoneCode,
                  'countryCurrencySymbol': item.countryCurrencySymbol,
                  'imageUrl': item.imageUrl,
                  'kycStatus': item.kycStatus,
                  'tpin': item.tpin
                }),
        _customerDataDeletionAdapter = DeletionAdapter(
            database,
            'CustomerData',
            ['email'],
            (CustomerData item) => <String, Object?>{
                  'email': item.email,
                  'firstName': item.firstName,
                  'username': item.username,
                  'balance': item.balance,
                  'countryName': item.countryName,
                  'countryPhoneCode': item.countryPhoneCode,
                  'countryCurrencySymbol': item.countryCurrencySymbol,
                  'imageUrl': item.imageUrl,
                  'kycStatus': item.kycStatus,
                  'tpin': item.tpin
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CustomerData> _customerDataInsertionAdapter;

  final UpdateAdapter<CustomerData> _customerDataUpdateAdapter;

  final DeletionAdapter<CustomerData> _customerDataDeletionAdapter;

  @override
  Future<CustomerData?> findCustomerByEmail(String email) async {
    return _queryAdapter.query('SELECT * FROM CustomerData WHERE email = ?1',
        mapper: (Map<String, Object?> row) => CustomerData(
            firstName: row['firstName'] as String?,
            email: row['email'] as String?,
            username: row['username'] as String?,
            balance: row['balance'] as String?,
            countryName: row['countryName'] as String?,
            countryPhoneCode: row['countryPhoneCode'] as String?,
            countryCurrencySymbol: row['countryCurrencySymbol'] as String?,
            imageUrl: row['imageUrl'] as String?,
            kycStatus: row['kycStatus'] as String?,
            tpin: row['tpin'] as String?),
        arguments: [email]);
  }

  @override
  Future<void> clearAllCustomerDetails() async {
    await _queryAdapter.queryNoReturn('DELETE FROM CustomerData');
  }

  @override
  Future<void> insertCustomer(CustomerData customer) async {
    await _customerDataInsertionAdapter.insert(
        customer, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCustomer(CustomerData customer) async {
    await _customerDataUpdateAdapter.update(customer, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCustomer(CustomerData customer) async {
    await _customerDataDeletionAdapter.delete(customer);
  }
}

class _$DashboardTransactionDao extends DashboardTransactionDao {
  _$DashboardTransactionDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _transactionDetailsInsertionAdapter = InsertionAdapter(
            database,
            'TransactionDetails',
            (TransactionDetails item) => <String, Object?>{
                  'id': item.id,
                  'amount': item.amount,
                  'email': item.email,
                  'fullName': item.fullName,
                  'transactionType': item.transactionType,
                  'uniqueId': item.uniqueId,
                  'username': item.username,
                  'phoneNumber': item.phoneNumber,
                  'status': item.status,
                  'createdAt': item.createdAt,
                  'senderUsername': item.senderUsername,
                  'senderFullName': item.senderFullName,
                  'receiverUsername': item.receiverUsername,
                  'userId': item.userId,
                  'senderId': item.senderId,
                  'receiverId': item.receiverId
                }),
        _transactionDetailsUpdateAdapter = UpdateAdapter(
            database,
            'TransactionDetails',
            ['id'],
            (TransactionDetails item) => <String, Object?>{
                  'id': item.id,
                  'amount': item.amount,
                  'email': item.email,
                  'fullName': item.fullName,
                  'transactionType': item.transactionType,
                  'uniqueId': item.uniqueId,
                  'username': item.username,
                  'phoneNumber': item.phoneNumber,
                  'status': item.status,
                  'createdAt': item.createdAt,
                  'senderUsername': item.senderUsername,
                  'senderFullName': item.senderFullName,
                  'receiverUsername': item.receiverUsername,
                  'userId': item.userId,
                  'senderId': item.senderId,
                  'receiverId': item.receiverId
                }),
        _transactionDetailsDeletionAdapter = DeletionAdapter(
            database,
            'TransactionDetails',
            ['id'],
            (TransactionDetails item) => <String, Object?>{
                  'id': item.id,
                  'amount': item.amount,
                  'email': item.email,
                  'fullName': item.fullName,
                  'transactionType': item.transactionType,
                  'uniqueId': item.uniqueId,
                  'username': item.username,
                  'phoneNumber': item.phoneNumber,
                  'status': item.status,
                  'createdAt': item.createdAt,
                  'senderUsername': item.senderUsername,
                  'senderFullName': item.senderFullName,
                  'receiverUsername': item.receiverUsername,
                  'userId': item.userId,
                  'senderId': item.senderId,
                  'receiverId': item.receiverId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TransactionDetails>
      _transactionDetailsInsertionAdapter;

  final UpdateAdapter<TransactionDetails> _transactionDetailsUpdateAdapter;

  final DeletionAdapter<TransactionDetails> _transactionDetailsDeletionAdapter;

  @override
  Future<List<TransactionDetails?>> findAllTransactions() async {
    return _queryAdapter.queryList(
        'SELECT * FROM TransactionDetails ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => TransactionDetails(
            id: row['id'] as int?,
            amount: row['amount'] as String?,
            email: row['email'] as String?,
            fullName: row['fullName'] as String?,
            transactionType: row['transactionType'] as String?,
            uniqueId: row['uniqueId'] as String?,
            username: row['username'] as String?,
            phoneNumber: row['phoneNumber'] as String?,
            status: row['status'] as String?,
            createdAt: row['createdAt'] as String?,
            senderUsername: row['senderUsername'] as String?,
            senderFullName: row['senderFullName'] as String?,
            receiverUsername: row['receiverUsername'] as String?,
            userId: row['userId'] as int?,
            senderId: row['senderId'] as int?,
            receiverId: row['receiverId'] as int?));
  }

  @override
  Future<void> clearAllTransactions() async {
    await _queryAdapter.queryNoReturn('DELETE FROM TransactionDetails');
  }

  @override
  Future<void> insertTransaction(TransactionDetails transaction) async {
    await _transactionDetailsInsertionAdapter.insert(
        transaction, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTransaction(TransactionDetails transaction) async {
    await _transactionDetailsUpdateAdapter.update(
        transaction, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTransaction(TransactionDetails transaction) async {
    await _transactionDetailsDeletionAdapter.delete(transaction);
  }
}

class _$NotificationDao extends NotificationDao {
  _$NotificationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _notificationDetailInsertionAdapter = InsertionAdapter(
            database,
            'NotificationDetail',
            (NotificationDetail item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'message': item.message,
                  'notificationType': item.notificationType,
                  'isRead': item.isRead == null ? null : (item.isRead! ? 1 : 0),
                  'createdAt': item.createdAt,
                  'customerId': item.customerId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<NotificationDetail>
      _notificationDetailInsertionAdapter;

  @override
  Future<List<NotificationDetail>> fetchNotifications(
    String type,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM NotificationDetail WHERE notificationType = ?1 ORDER BY createdAt DESC LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => NotificationDetail(id: row['id'] as int?, title: row['title'] as String?, message: row['message'] as String?, notificationType: row['notificationType'] as String?, isRead: row['isRead'] == null ? null : (row['isRead'] as int) != 0, customerId: row['customerId'] as int?, createdAt: row['createdAt'] as String?),
        arguments: [type, limit, offset]);
  }

  @override
  Future<void> insertNotification(NotificationDetail notification) async {
    await _notificationDetailInsertionAdapter.insert(
        notification, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertNotifications(
      List<NotificationDetail> notifications) async {
    await _notificationDetailInsertionAdapter.insertList(
        notifications, OnConflictStrategy.replace);
  }
}
