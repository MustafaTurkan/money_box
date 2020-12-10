class DbString {
  static const String name = 'money_box.db';
}



class GoalString {
  static const String tableName = 'goal';
  static const String id = 'id';
  static const String title = 'title';
  static const String img = 'img';
  static const String targetDate = 'targetDate';
  static const String targetAmount = 'targetAmount';
  static const String deposited = 'deposited';
  static const String currency = 'Currency';
  static const String frequency = 'frequency';
  static const String createTable = 'CREATE TABLE $tableName ($id INTEGER PRIMARY KEY AUTOINCREMENT, $title TEXT, $img BLOB, $targetAmount REAL, $targetDate TEXT, $deposited REAL, $currency TEXT,$frequency INTEGER)';
}

class MobilityString {
  static const String tableName = 'mobility';
  static const String id = 'id';
  static const String goalId = 'goalId';
  static const String title = 'title';
  static const String transactionDate = 'transactionDate';
  static const String amount = 'amount';
  static const String createTable = 'CREATE TABLE $tableName ($id INTEGER PRIMARY KEY AUTOINCREMENT, $title TEXT, $goalId INTEGER, $transactionDate TEXT, $amount REAL)';

}
