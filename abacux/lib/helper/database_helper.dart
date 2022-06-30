import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "abacux.db";
  static final _databaseVersion = 32;

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    // Delete the database
    //await deleteDatabase(path);

    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onOpen: _onOpen,
        onUpgrade: _onUpgrade);
  }

  Future _onOpen(Database db) async {
    //_onCreate(db, _databaseVersion);
  }

  Future _onUpgrade(
      Database db, final int oldVersion, final int newVersion) async {
    if (newVersion > oldVersion) {
      _onCreate(db, _databaseVersion);
    }
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute("DROP TABLE IF EXISTS UserRoles");

    await db.execute("CREATE TABLE IF NOT EXISTS UserRoles("
        "id INTEGER PRIMARY KEY,"
        "userId INTEGER,"
        "isDeleted INTEGER,"
        "createdBy INTEGER,"
        "createdAt INTEGER,"
        "updatedBy TEXT,"
        "updatedAt INTEGER,"
        "companyRoleId TEXT"
        ")");

    await db.execute("CREATE TABLE IF NOT EXISTS CompanyRoles("
        "id INTEGER PRIMARY KEY,"
        "role_name TEXT,"
        "is_deleted INTEGER,"
        "created_by INTEGER,"
        "created_at INTEGER,"
        "updated_by INTEGER,"
        "updated_at TEXT,"
        "company_id INTEGER,"
        "company_name TEXT"
        ")");

    await db.execute("CREATE TABLE IF NOT EXISTS PurchaseProduct("
        "id INTEGER PRIMARY KEY,"
        "uuid TEXT,"
        "product TEXT,"
        "pid INTEGER,"
        "productId INTEGER,"
        "productUomsId INTEGER,"
        "quantity REAL,"
        "basicPrice REAL,"
        "price REAL,"
        "taxTypeId INTEGER,"
        "taxType INTEGER,"
        "tax REAL,"
        "discount REAL,"
        "discountAmount REAL,"
        "amount REAL,"
        "cgst REAL,"
        "igst REAL,"
        "sgst REAL,"
        "salesTax REAL,"
        "subTotal REAL"
        ")");

    await db.execute("CREATE TABLE IF NOT EXISTS PurchaseAdditionalCharges("
        "id INTEGER PRIMARY KEY,"
        "uuid TEXT,"
        "additionalChargeId INTEGER,"
        "additionalCharge TEXT,"
        "amount REAL,"
        "taxType INTEGER,"
        "tax REAL,"
        "totalAmount REAL"
        ")");

    await db.execute("CREATE TABLE IF NOT EXISTS EstimateProduct("
        "id INTEGER PRIMARY KEY,"
        "uuid TEXT,"
        "product TEXT,"
        "pid INTEGER,"
        "productId INTEGER,"
        "productUomsId INTEGER,"
        "quantity REAL,"
        "basicPrice REAL,"
        "price REAL,"
        "taxType INTEGER,"
        "tax REAL,"
        "discount REAL,"
        "discountAmount REAL,"
        "amount REAL,"
        "cgst REAL,"
        "igst REAL,"
        "sgst REAL,"
        "salesTax REAL,"
        "subTotal REAL"
        ")");

    await db.execute("CREATE TABLE IF NOT EXISTS EstimateAdditionalCharges("
        "id INTEGER PRIMARY KEY,"
        "uuid TEXT,"
        "additionalChargeId INTEGER,"
        "additionalCharge TEXT,"
        "amount REAL,"
        "taxType INTEGER,"
        "tax REAL,"
        "totalAmount REAL"
        ")");

    await db.execute("CREATE TABLE IF NOT EXISTS ProformaInvoiceProduct("
        "id INTEGER PRIMARY KEY,"
        "uuid TEXT,"
        "product TEXT,"
        "pid INTEGER,"
        "productId INTEGER,"
        "productUomsId INTEGER,"
        "quantity REAL,"
        "basicPrice REAL,"
        "price REAL,"
        "taxTypeId INTEGER,"
        "taxType INTEGER,"
        "tax REAL,"
        "discount REAL,"
        "discountAmount REAL,"
        "amount REAL,"
        "cgst REAL,"
        "igst REAL,"
        "sgst REAL,"
        "salesTax REAL,"
        "subTotal REAL"
        ")");

    await db
        .execute("CREATE TABLE IF NOT EXISTS ProformaInvoiceAdditionalCharges("
            "id INTEGER PRIMARY KEY,"
            "uuid TEXT,"
            "additional_charge_id INTEGER,"
            "additonal_charge_name TEXT,"
            "additional_charge_amount  REAL,"
            "additional_tax_type INTEGER,"
            "additional_tax_percentage REAL,"
            "additional_total_amount REAL"
            ")");

    await db.execute("CREATE TABLE IF NOT EXISTS SalesInvoiceProduct("
        "id INTEGER PRIMARY KEY,"
        "uuid TEXT,"
        "product TEXT,"
        "pid INTEGER,"
        "productId INTEGER,"
        "productUomsId INTEGER,"
        "quantity REAL,"
        "basicPrice REAL,"
        "price REAL,"
        "taxTypeId INTEGER,"
        "taxType INTEGER,"
        "tax REAL,"
        "discount REAL,"
        "discountAmount REAL,"
        "amount REAL,"
        "cgst REAL,"
        "igst REAL,"
        "sgst REAL,"
        "salesTax REAL,"
        "subTotal REAL"
        ")");

    await db.execute("CREATE TABLE IF NOT EXISTS SalesInvoiceAdditionalCharges("
        "id INTEGER PRIMARY KEY,"
        "uuid TEXT,"
        "additional_charge_id INTEGER,"
        "additonal_charge_name TEXT,"
        "additional_charge_amount  REAL,"
        "additional_tax_type INTEGER,"
        "additional_tax_percentage REAL,"
        "additional_total_amount REAL"
        ")");

    await db.execute("CREATE TABLE IF NOT EXISTS CreditNotesProduct("
        "id INTEGER PRIMARY KEY,"
        "uuid TEXT,"
        "product TEXT,"
        "pid INTEGER,"
        "productId INTEGER,"
        "productUomsId INTEGER,"
        "quantity REAL,"
        "basicPrice REAL,"
        "price REAL,"
        "taxTypeId INTEGER,"
        "taxType INTEGER,"
        "tax REAL,"
        "discount REAL,"
        "discountAmount REAL,"
        "amount REAL,"
        "cgst REAL,"
        "igst REAL,"
        "sgst REAL,"
        "salesTax REAL,"
        "subTotal REAL"
        ")");

    await db.execute("CREATE TABLE IF NOT EXISTS PurchaseBillAdditionalCharge("
        "id INTEGER PRIMARY KEY,"
        "uuid TEXT,"
        "additionalChargeId INTEGER,"
        "additionalCharge TEXT,"
        "amount REAL,"
        "taxType INTEGER,"
        "tax REAL,"
        "totalAmount REAL"
        ")");

    await db.execute("CREATE TABLE IF NOT EXISTS PurchaseBillProduct("
        "id INTEGER PRIMARY KEY,"
        "uuid TEXT,"
        "product TEXT,"
        "pid INTEGER,"
        "productId INTEGER,"
        "productUomsId INTEGER,"
        "quantity REAL,"
        "basicPrice REAL,"
        "price REAL,"
        "taxTypeId INTEGER,"
        "taxType INTEGER,"
        "tax REAL,"
        "discount REAL,"
        "discountAmount REAL,"
        "amount REAL,"
        "cgst REAL,"
        "igst REAL,"
        "sgst REAL,"
        "salesTax REAL,"
        "subTotal REAL"
        ")");

    await db.execute("CREATE TABLE IF NOT EXISTS DebitNotesProduct("
        "id INTEGER PRIMARY KEY,"
        "uuid TEXT,"
        "product TEXT,"
        "pid INTEGER,"
        "productId INTEGER,"
        "productUomsId INTEGER,"
        "quantity REAL,"
        "basicPrice REAL,"
        "price REAL,"
        "taxTypeId INTEGER,"
        "taxType INTEGER,"
        "tax REAL,"
        "discount REAL,"
        "discountAmount REAL,"
        "amount REAL,"
        "cgst REAL,"
        "igst REAL,"
        "sgst REAL,"
        "salesTax REAL,"
        "subTotal REAL"
        ")");

    await db.execute("CREATE TABLE IF NOT EXISTS DebitNotesAdditionalCharge("
        "id INTEGER PRIMARY KEY,"
        "uuid TEXT,"
        "additionalChargeId INTEGER,"
        "additionalCharge TEXT,"
        "amount REAL,"
        "taxType INTEGER,"
        "tax REAL,"
        "totalAmount REAL"
        ")");
  }
}
