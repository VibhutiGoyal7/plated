import 'package:Payrio/model/response/transactionListReponse.dart';
import 'package:floor/floor.dart';

import '../response/dashboardResponse.dart';

@dao
abstract class DashboardTransactionDao {
  @Query('SELECT * FROM TransactionDetails ORDER BY createdAt DESC')
  Future<List<TransactionDetails?>> findAllTransactions();
  @insert
  Future<void> insertTransaction(TransactionDetails transaction);

  @delete
  Future<void> deleteTransaction(TransactionDetails transaction);

  @update
  Future<void> updateTransaction(TransactionDetails transaction);

  @Query('DELETE FROM TransactionDetails')
  Future<void> clearAllTransactions();
}

@dao
abstract class CustomerDataDao {
  @Query('SELECT * FROM CustomerData WHERE email = :email')
  Future<CustomerData?> findCustomerByEmail(String email);

  @insert
  Future<void> insertCustomer(CustomerData customer);

  @delete
  Future<void> deleteCustomer(CustomerData customer);

  @update
  Future<void> updateCustomer(CustomerData customer);

  @Query('DELETE FROM CustomerData')
  Future<void> clearAllCustomerDetails();
}
