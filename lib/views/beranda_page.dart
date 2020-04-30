import 'package:adira_finance/custom/responsive_screen.dart';
import 'package:adira_finance/main.dart';
import 'package:adira_finance/views/form_transaksional_page.dart';
import 'package:flutter/material.dart';

import 'detail_data_transaksional.dart';

class BerandaPage extends StatefulWidget {
  @override
  _BerandaPageState createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {

  Screen size;
  TextEditingController editingController = TextEditingController();
  String filter;
  DataModel _dataModel;
  List<DataModel> _listTrans = [];
  List<DataModel> _newData = [];

  @override
  void initState() {
    super.initState();
    prosesData();
  }

  onSearchTextChanged(String text) async {
    _newData.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _listTrans.forEach((dataNasabah) {
      if (dataNasabah.ktp.toLowerCase().contains(text) || dataNasabah.namaLengkap.toLowerCase().contains(text)){
        setState(() {
          _newData.add(dataNasabah);
        });
      }
    });
  }

  prosesData(){
    for(var u in listDataTransaksional){
      _dataModel = DataModel(
          u['dealerCabang'],
          u['kendaraan'],
          u['model'],
          u['tipe'],
          u['merk'],
          u['thnProduksi'],
          u['namaBPKB'],
          u['jenisPembiayaan'],
          u['otr'],
          u['tenor'],
          u['ktp'],
          u['namaLengkap'],
          u['namaPanggilan'],
          u['tmptLahir'],
          u['tglLahir'],
          u['statusNikah'],
          u['alamatSurvey'],
          u['kecamatan'],
          u['kelurahan'],
          u['kodePos'],
          u['tlpn'],
          u['hp'],
          u['namaPasangan'],
          u['namaIbu'],
          u['catatan']);
      _listTrans.add(_dataModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      body: Theme(
        data:ThemeData(primaryColor: Colors.black),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: size.hp(1.5),horizontal: size.wp(2)),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: size.wp(1.5),right: size.wp(1.5)),
                child: TextField(
                  decoration: new InputDecoration(
                      labelText: 'Cari sekarang',
                      labelStyle: TextStyle(fontFamily: "NunitoSans",color: Colors.black),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      suffixIcon: Icon(Icons.search)
                  ),
                  controller: editingController,
                  onChanged: onSearchTextChanged,
                ),
              ),
              Expanded(
                  child: _newData != null && _newData.length != 0
                      ?
                  ListView.builder(
                    itemBuilder: (context,index){
                      return
                        InkWell(
                          onTap: (){
//                            Navigator.of(context).push(
//                                MaterialPageRoute(builder: (context) =>
//                                    DetailTransaksional(_newData[index],0)));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: size.hp(2)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    _newData[index].namaLengkap,
                                    style: TextStyle(fontFamily: 'NunitoSansSemiBold')
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                        _newData[index].ktp,
                                        style: TextStyle(fontFamily: 'NunitoSans')
                                    ),
                                    Text(
                                        ' - ',
                                        style: TextStyle(fontFamily: 'NunitoSans')
                                    ),
                                    Text(
                                        _newData[index].kendaraan,
                                        style: TextStyle(fontFamily: 'NunitoSans')
                                    ),
                                  ],
                                ),
                                Text(
                                    _newData[index].dealerCabang,
                                    style: TextStyle(fontFamily: 'NunitoSans')
                                ),
                              ],
                            ),
                          ),
                        );
                    },
                    itemCount: _newData.length,
                    padding: EdgeInsets.only(top: size.hp(2),left: size.wp(3),right: size.wp(3)),
                  )
                      :
                  ListView.builder(
                    itemBuilder: (context,index){
                      return
                        InkWell(
                          onTap: (){
//                            Navigator.of(context).push(
//                                MaterialPageRoute(builder: (context) =>
//                                    DetailTransaksional(_listTrans[index],0)));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: size.hp(2)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    _listTrans[index].namaLengkap,
                                    style: TextStyle(fontFamily: 'NunitoSansSemiBold')
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                        _listTrans[index].ktp,
                                        style: TextStyle(fontFamily: 'NunitoSans')
                                    ),
                                    Text(
                                        ' - ',
                                        style: TextStyle(fontFamily: 'NunitoSans')
                                    ),
                                    Text(
                                        _listTrans[index].kendaraan,
                                        style: TextStyle(fontFamily: 'NunitoSans')
                                    ),
                                  ],
                                ),
                                Text(
                                    _listTrans[index].dealerCabang,
                                    style: TextStyle(fontFamily: 'NunitoSans')
                                ),
                              ],
                            ),
                          ),
                        );
                    },
                    itemCount: _listTrans.length,
                    padding: EdgeInsets.only(top: size.hp(2),left: size.wp(3),right: size.wp(3)),
                  )
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormTransaksionalPage(),
            ),
          );
        },
        child: Icon(Icons.add,color: Colors.black),
        backgroundColor: myPrimaryColor,
      ),
    );
  }

  var listDataTransaksional = [
    {
      "dealerCabang" : "Yanuar Motor",
      "kendaraan":"Motor",
      "model":"Trail",
      "tipe":"KLX 250 cc",
      "merk":"Kawasaki",
      "thnProduksi":"2017",
      "namaBPKB":"Joko Susanto",
      "jenisPembiayaan":"Kredit",
      "otr":"Rp.59,200,000",
      "tenor":"36",
      "ktp":"357100288760003",
      "namaLengkap":"Bambang Saputro",
      "namaPanggilan":"Bambang",
      "tmptLahir":"Jakarta",
      "tglLahir":"20 - 12 - 1977",
      "statusNikah":"Kawin",
      "alamatSurvey":"Jl. Cemara Indah no 707 Jakarta Pusat",
      "kecamatan":"Sawah Besar",
      "kelurahan":"Karang Anyar",
      "kodePos":"10740",
      "tlpn":"021-95032109",
      "hp":"0812-3456-7890",
      "namaPasangan":"Ayu Lidya Sari",
      "namaIbu":"Linda Nina",
      "catatan":"Motor minta warna hitam",
    },
    {
      "dealerCabang" : "Sukses Motor",
      "kendaraan":"Mobil",
      "model":"Sedan",
      "tipe":"M4 Coupe",
      "merk":"BMW",
      "thnProduksi":"2019",
      "namaBPKB":"Andi Riyadi",
      "jenisPembiayaan":"Kredit",
      "otr":"Rp.2,030,000,000",
      "tenor":"36",
      "ktp":"357100455760009",
      "namaLengkap":"Ganda Lius",
      "namaPanggilan":"Ganda",
      "tmptLahir":"Surabaya",
      "tglLahir":"2 - 10 - 1987",
      "statusNikah":"Kawin",
      "alamatSurvey":"Jl. Kutilang Indah no 107 Jakarta Barat",
      "kecamatan":"Cengkareng",
      "kelurahan":"Cengkareng Barat",
      "kodePos":"11730",
      "tlpn":"021-34577991",
      "hp":"0815-6789-0123",
      "namaPasangan":"Dewi Pertiwi",
      "namaIbu":"Andini Luis Anastasya",
      "catatan":"Mobil minta warna merah",
    },
    {
      "dealerCabang" : "Jaya Abadi Motor",
      "kendaraan":"Motor",
      "model":"Sport",
      "tipe":"R25",
      "merk":"Yamaha",
      "thnProduksi":"2018",
      "namaBPKB":"Risky Abdul Latif",
      "jenisPembiayaan":"Kredit",
      "otr":"Rp.59,780,000",
      "tenor":"24",
      "ktp":"3571002807900005",
      "namaLengkap":"Harun Prasetyo",
      "namaPanggilan":"Pras",
      "tmptLahir":"Jakarta",
      "tglLahir":"20 - 12 - 1990",
      "statusNikah":"Belum Kawin",
      "alamatSurvey":"Jl. Persada Permai no 909 Jakarta Selatan",
      "kecamatan":"Cilandak",
      "kelurahan":"Lebak Bulus",
      "kodePos":"12440",
      "tlpn":"021-8769013",
      "hp":"0813-7890-6543",
      "namaPasangan":"",
      "namaIbu":"Sri Ningsih",
      "catatan":"Motor minta yang movistar",
    }
  ];
}

class DataModel{
  final String dealerCabang;
  final String kendaraan;
  final String model;
  final String tipe;
  final String merk;
  final String thnProduksi;
  final String namaBPKB;
  final String jenisPembiayaan;
  final String otr;
  final String tenor;
  final String ktp;
  final String namaLengkap;
  final String namaPanggilan;
  final String tmptLahir;
  final String tglLahir;
  final String statusNikah;
  final String alamatSurvey;
  final String kecamatan;
  final String kelurahan;
  final String kodePos;
  final String tlpn;
  final String hp;
  final String namaPasangan;
  final String namaIbu;
  final String catatan;

  DataModel(this.dealerCabang, this.kendaraan, this.model, this.tipe, this.merk,
      this.thnProduksi, this.namaBPKB, this.jenisPembiayaan, this.otr,
      this.tenor, this.ktp, this.namaLengkap, this.namaPanggilan,
      this.tmptLahir, this.tglLahir, this.statusNikah, this.alamatSurvey,
      this.kecamatan, this.kelurahan, this.kodePos, this.tlpn, this.hp,
      this.namaPasangan, this.namaIbu, this.catatan);

}
