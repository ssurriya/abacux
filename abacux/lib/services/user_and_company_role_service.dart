import 'package:abacux/helper/database_helper.dart';
import 'package:abacux/model/login_model.dart';
import 'package:sqflite/sqflite.dart';

class UserAndCompanyRoleService {
  Future insertUserRole(UserRole userRole) async {
    Database db = await DatabaseHelper.instance.database;

    print('UserRoleId ${userRole.userId}');

    var raw = await db.rawInsert(
        "INSERT Into UserRoles (id,userId,isDeleted,createdBy,createdAt,updatedBy,updatedAt,companyRoleId)"
        " VALUES (?,?,?,?,?,?,?,?)",
        [
          userRole.id,
          userRole.userId,
          userRole.isDeleted,
          userRole.createdBy,
          userRole.createdAt,
          userRole.updatedBy,
          userRole.updatedAt,
          userRole.companyRoleId
        ]);

    return raw;
  }

  Future deleteUserRole() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawQuery("DELETE From UserRoles");

    return raw;
  }

  Future insertCompanyRole(CompanyRole companyRole) async {
    Database db = await DatabaseHelper.instance.database;

    print('companyRoleId ${companyRole.companyId}');

    var raw = await db.rawInsert(
        "INSERT Into CompanyRoles (id,role_name,is_deleted,created_by,created_at,updated_by,updated_at,company_id,company_name)"
        " VALUES (?,?,?,?,?,?,?,?,?)",
        [
          companyRole.id,
          companyRole.roleName,
          companyRole.isDeleted,
          companyRole.createdBy,
          companyRole.createdAt,
          companyRole.updatedBy,
          companyRole.updatedAt,
          companyRole.companyId,
          companyRole.companyName
        ]);

    return raw;
  }

  Future<List<CompanyRole>> getCompanyRoles() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawQuery("SELECT * From CompanyRoles");

    print(raw);

    List<CompanyRole> companyRoles = [];

    raw.map((e) {
      print(e);
      companyRoles.add(CompanyRole.fromJson(e));
    }).toList();

    return companyRoles;
  }

  Future deleteCompanyRole() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawQuery("DELETE From CompanyRoles");

    return raw;
  }
}
