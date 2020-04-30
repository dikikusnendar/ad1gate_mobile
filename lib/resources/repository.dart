import 'package:adira_finance/db_helper/database_helper.dart';
import 'package:adira_finance/model/kecamatan_model.dart';

class Repository{
  final dbHelper = DbHelper();

  Future<KecamatanModel> fetchAllKecamatan() => dbHelper.getKecamatan();
}