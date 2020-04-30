import 'package:adira_finance/model/kecamatan_model.dart';
import 'package:adira_finance/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class BlocKecamatan{
  final _repository = Repository();
  final _kecamatanFetcher = PublishSubject<KecamatanModel>();

  Stream<KecamatanModel> get allKecamatan => _kecamatanFetcher.stream;

  fetchAllKecamatan() async{
    KecamatanModel _kecamatanModel = await _repository.fetchAllKecamatan();
    _kecamatanFetcher.sink.add(_kecamatanModel);
  }

  dispose(){
    _kecamatanFetcher.close();
  }
}