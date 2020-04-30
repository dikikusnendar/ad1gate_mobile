import 'dart:io';

import 'package:adira_finance/custom/constan_pop_up_menu.dart';
import 'package:adira_finance/resources/get_data_tracking_api_provider.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pdfLib;

import '../main.dart';

class DetailTracking extends StatefulWidget {
  final String branchId,nomorApplication;
  const DetailTracking({Key key,this.branchId, this.nomorApplication}) : super(key: key);

  @override
  _DetailTrackingState createState() => _DetailTrackingState();
}

class _DetailTrackingState extends State<DetailTracking> {

  Directory externalDir;
  var path = "No Data";
  String dirLoc = "";
  PermissionStatus permissionStatus;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GetDataTrackingApiProvider _getDataTrackingApiProvider;
  var _dataDetailTrackingOrder;
  var _loadData = false;

  checkPermission() async{
    permissionStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    print(permissionStatus);
    if(permissionStatus == PermissionStatus.denied){
      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      print(permissions.toString());

      if(Platform.isAndroid){
        dirLoc = "/sdcard/Adira PDF";
        try{
          FileUtils.mkdir([dirLoc]);
        }
        catch(e){
          print(e.toString());
        }
      }
      else{
        dirLoc = (await getApplicationDocumentsDirectory()).path;
      }
    }
    else{
      dirLoc = "/sdcard/Adira PDF";
      print("cek dirLoc $dirLoc");
    }
  }

  generatePDF() async {
    final pdfLib.Document pdf = pdfLib.Document();

    final font = await rootBundle.load("fonts/NunitoSans-Regular.ttf");
    final ttf = pdfLib.Font.ttf(font);
    final fontBold = await rootBundle.load("fonts/NunitoSans-Bold.ttf");
    final ttfBold = pdfLib.Font.ttf(fontBold);
    final fontItalic = await rootBundle.load("fonts/NunitoSans-Italic.ttf");
    final ttfItalic = pdfLib.Font.ttf(fontItalic);
    final fontBoldItalic =
    await rootBundle.load("fonts/NunitoSans-Italic.ttf");
    final ttfBoldItalic = pdfLib.Font.ttf(fontBoldItalic);
    final pdfLib.Theme theme = pdfLib.Theme.withFont(
      base: ttf,
      bold: ttfBold,
      italic: ttfItalic,
      boldItalic: ttfBoldItalic,
    );

    pdf.addPage(
        pdfLib.Page(
            pageFormat: PdfPageFormat.a4,
            theme: theme,
            build: (context) {
              return
                pdfLib.Column(
                    crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                    children: <pdfLib.Widget>[
                      pdfLib.Text('Data Tracking',style: pdfLib.TextStyle(font: ttfBold,fontSize: 18)),
                      pdfLib.SizedBox(height: 16),
                      pdfLib.Row(
                          children:  <pdfLib.Widget>[
                            pdfLib.Expanded(flex: 5, child: pdfLib.Text("Nomor Aplikasi", style: pdfLib.TextStyle(font: ttf,))),
                            pdfLib.Expanded(flex: 1, child: pdfLib.Text(":", style: pdfLib.TextStyle(font: ttf,))),
                            pdfLib.Expanded(flex: 6, child: pdfLib.Text(
                                _dataDetailTrackingOrder['SZAPPLNO'] != null
                                    ?
                                _dataDetailTrackingOrder['SZAPPLNO'] : "", style: pdfLib.TextStyle(font: ttf))),
                          ]
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                          children:  <pdfLib.Widget>[
                            pdfLib.Expanded(flex: 5, child: pdfLib.Text("Branch ID", style: pdfLib.TextStyle(font: ttf,))),
                            pdfLib.Expanded(flex: 1, child: pdfLib.Text(":", style: pdfLib.TextStyle(font: ttf,))),
                            pdfLib.Expanded(flex: 6, child: pdfLib.Text(_dataDetailTrackingOrder['SZBRID'] != null ? _dataDetailTrackingOrder['SZBRID'] : "", style: pdfLib.TextStyle(font: ttf))),
                          ]
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                          children:  <pdfLib.Widget>[
                            pdfLib.Expanded(flex: 5, child: pdfLib.Text("Branch Name", style: pdfLib.TextStyle(font: ttf,))),
                            pdfLib.Expanded(flex: 1, child: pdfLib.Text(":", style: pdfLib.TextStyle(font: ttf,))),
                            pdfLib.Expanded(flex: 6, child: pdfLib.Text(_dataDetailTrackingOrder['SZBRANCH_NAME'] != null ? _dataDetailTrackingOrder['SZBRANCH_NAME'] : "",style: pdfLib.TextStyle(font: ttf))),
                          ]
                      ),
                      pdfLib.Row(
                          children:  <pdfLib.Widget>[
                            pdfLib.Expanded(flex: 5, child: pdfLib.Text("Dealer Name", style: pdfLib.TextStyle(font: ttf,))),
                            pdfLib.Expanded(flex: 1, child: pdfLib.Text(":", style: pdfLib.TextStyle(font: ttf,))),
                            pdfLib.Expanded(flex: 6, child: pdfLib.Text(_dataDetailTrackingOrder['SZDEALER_NAME'] != null ? _dataDetailTrackingOrder['SZDEALER_NAME'] : "", style: pdfLib.TextStyle(font: ttf))),
                          ]
                      ),
                      pdfLib.Text('Data Nasabah',style: pdfLib.TextStyle(font: ttfBold,fontSize: 18)),
                      pdfLib.SizedBox(height: 16),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Nomor KTP',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZNOKTP'] != null ? _dataDetailTrackingOrder['SZNOKTP'] : "",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Nama',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZNAME'] != null ? _dataDetailTrackingOrder['SZNAME'] :"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Tempat Lahir',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZPLACE'] != null ? _dataDetailTrackingOrder['SZPLACE'] : "",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Tanggal Lahir',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZBDATE'] != null ? _dataDetailTrackingOrder['SZBDATE'] : "",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Status Pernikahan',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZMARITALSTATUS'] != null ? _dataDetailTrackingOrder['SZMARITALSTATUS'] :"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Alamat Survey',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZADDRESS'] != null ? _dataDetailTrackingOrder['SZADDRESS'] : "",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Alamat KTP',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZADDRESSKTP'] != null ? _dataDetailTrackingOrder['SZADDRESSKTP'] :"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Telepon Rumah',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZTELPHOME'] != null ? _dataDetailTrackingOrder['SZTELPHOME']:"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Telepon Kantor',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child:pdfLib.Text(_dataDetailTrackingOrder['SZTELPKANTOR'] ? _dataDetailTrackingOrder['SZTELPKANTOR'] : "",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Handphone 1',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child:pdfLib.Text(_dataDetailTrackingOrder['SZTELPHP1'] != null ? _dataDetailTrackingOrder['SZTELPHP1']:"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Handphone 2',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child:pdfLib.Text(_dataDetailTrackingOrder['SZTELPHP2'] != null ? _dataDetailTrackingOrder['SZTELPHP2']:"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Text('Data Pendukung',style: pdfLib.TextStyle(font: ttfBold,fontSize: 18)),
                      pdfLib.SizedBox(height: 16),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Nama Pasangan',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZSPOUSE'] != null ? _dataDetailTrackingOrder['SZSPOUSE']:"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Nama Gadis Ibu Kandung',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZMOTHERS'] != null ? _dataDetailTrackingOrder['SZMOTHERS'] :"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
//                      pdfLib.Divider(height: 1,color: Colors.black),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Text('Data Kendaraan',style: pdfLib.TextStyle(font: ttfBold,fontSize: 18)),
                      pdfLib.SizedBox(height: 16),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Merk',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZBRAND'] != null ? _dataDetailTrackingOrder['SZBRAND']:"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Type',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZTYPE']!=null ? _dataDetailTrackingOrder['SZTYPE']:"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Model',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZMODEL'] != null ? _dataDetailTrackingOrder['SZMODEL']:"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Tahun Produksi',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZMFGYEAR'] != null ? _dataDetailTrackingOrder['SZMFGYEAR']:"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Text('Data Pengajuan Kredit',style: pdfLib.TextStyle(font: ttfBold,fontSize: 18)),
                      pdfLib.SizedBox(height: 16),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('OTR (Rp)',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZOTR'] != null ? _dataDetailTrackingOrder['SZOTR'] :"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Tenor',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZTOP'] != null ? _dataDetailTrackingOrder['SZTOP']:"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('DP (Down Payment)',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZDP'] == null ? "RP.0" : _dataDetailTrackingOrder['SZDP'],style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
//                      pdfLib.Row(
//                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
//                        children: <pdfLib.Widget>[
//                          pdfLib.Expanded(child: pdfLib.Text('Net DP (Down Payment)',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
//                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
//                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZNETDP'],style: pdfLib.TextStyle(font: ttf)),flex: 6,)
//                        ],
//                      ),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Angsuran / Bulan',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZINSTAMT'] != null ? _dataDetailTrackingOrder['SZINSTAMT']:"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Survey Date',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZSURVEYDATE'] != null ? _dataDetailTrackingOrder['SZSURVEYDATE']:"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Note',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZDEALNOTE'] != null ? _dataDetailTrackingOrder['SZDEALNOTE']:"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Kontrak ID',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZKONTRAK'] != null ? _dataDetailTrackingOrder['SZKONTRAK']:"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
//                      pdfLib.Row(
//                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
//                        children: <pdfLib.Widget>[
//                          pdfLib.Expanded(child: pdfLib.Text('PO',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
//                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
//                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZPO:'],style: pdfLib.TextStyle(font: ttf)),flex: 6,)
//                        ],
//                      ),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('No. Dealer Account',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZDLRACCNO'] != null ? _dataDetailTrackingOrder['SZDLRACCNO'] :"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Jenis Angsuran',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZADVARR'] != null ? _dataDetailTrackingOrder['SZADVARR']:"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Order Date',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(_dataDetailTrackingOrder['SZORDERDATE'] != null ? _dataDetailTrackingOrder['SZORDERDATE']:"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.SizedBox(height: 8),
                    ]
                );
            })
    );

//    pdf.addPage(
//        pdfLib.MultiPage(
//            theme: theme,
//            build: (context) => [
//              pdfLib.Table.fromTextArray(
//                  context: context,
//                  data: <List<String>>[
//                    [
//                      'asdasasd',
//                      'asdsadsadsad',
//                      'asdasdasdasdasdasdass',
//                      'asd',
//                      'asdasdasd'
//                    ]
//                  ]
//              ),
//            ]
//        )
//    );


    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyyHHmmss');
    String formatted = formatter.format(now);
    print(formatted);
    setState(() {
      path = "$dirLoc/$formatted\.pdf";
    });
    print(path);
    final File file = File(path);
    await file.writeAsBytes(pdf.save());
    _showSnackBar("File save in Internal Storage/Adira PDF");
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
    _getDataTrackingApiProvider = GetDataTrackingApiProvider();
    _getDetailTrackingOrder();
  }

  _getDetailTrackingOrder() async{
    print("cek nomer aplication ${widget.nomorApplication}");
    setState(() {
      _loadData = true;
    });
    var _result = await _getDataTrackingApiProvider.getDetailTrackingOrder(widget.branchId, widget.nomorApplication);
    print(_result);
    if(_result['status']){
      print("cek result ${_result['dataDetailTrackingOrder']}");
      setState(() {
        _dataDetailTrackingOrder = _result['dataDetailTrackingOrder'];
        _loadData = false;
      });
//      print("cek result _dataDetailTrackingOrder $_dataDetailTrackingOrder");
    }
    else{
      print(_result['message']);
      setState(() {
        _loadData = false;
      });
      _showSnackBar(_result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Detail Tracking",style:TextStyle(fontFamily: "NunitoSans",color: Colors.black)),
        centerTitle: true,
        backgroundColor: myPrimaryColor,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context){
              return Constants.choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _loadData
            ?
        Center(child: CircularProgressIndicator())
            : _dataDetailTrackingOrder == null ? Center(child: Text("Data Not Found"),):
        ListView(
          children: <Widget>[
            Text('Data Tracking',style: TextStyle(fontFamily: 'NunitoSansSemiBold',fontSize: 18)),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Nomor Aplikasi", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(":", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text(
                      _dataDetailTrackingOrder['SZAPPLNO'] != null
                          ?
                      _dataDetailTrackingOrder['SZAPPLNO'] : "",
                      style: TextStyle(fontFamily: "NunitoSans", fontSize: 16
                      )
                  )),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Branch ID", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(":", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(
                      flex: 5,
                      child: Text(
                          _dataDetailTrackingOrder['SZBRID'] != null ? _dataDetailTrackingOrder['SZBRID'] : "",
                          style: TextStyle(
                              fontFamily: "NunitoSans", fontSize: 16
                          )
                      )),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Branch Name", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(":", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(
                      flex: 5,
                      child: Text(
                          _dataDetailTrackingOrder['SZBRANCH_NAME'] != null
                              ?
                          _dataDetailTrackingOrder['SZBRANCH_NAME'] : "",
                          style: TextStyle(fontFamily: "NunitoSans", fontSize: 16
                          )
                      )
                  ),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Dealer Name", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(":", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text(_dataDetailTrackingOrder['SZDEALER_NAME'] != null ? _dataDetailTrackingOrder['SZDEALER_NAME'] : "", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Divider(height: 1,color: Colors.black),
            SizedBox(height: 8),
            Text('Data Nasabah',style: TextStyle(fontFamily: 'NunitoSansSemiBold',fontSize: 18)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('No. KTP',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZNOKTP'] != null ? _dataDetailTrackingOrder['SZNOKTP'] : "",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(child: Text('Nama',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZNAME'] != null ? _dataDetailTrackingOrder['SZNAME'] :"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('C Name',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZCNAME'] != null ? _dataDetailTrackingOrder['SZCNAME'] : "",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(child: Text('Tempat Lahir',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZPLACE'] != null ? _dataDetailTrackingOrder['SZPLACE'] : "",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Tanggal Lahir',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZBDATE'] != null ? _dataDetailTrackingOrder['SZBDATE'] : "",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(child: Text('Status Pernikahan',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZMARITALSTATUS'] != null ? _dataDetailTrackingOrder['SZMARITALSTATUS'] :"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Alamat Survey',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZADDRESS'] != null ? _dataDetailTrackingOrder['SZADDRESS'] : "",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Alamat KTP',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZADDRESSKTP'] != null ? _dataDetailTrackingOrder['SZADDRESSKTP'] :"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Telepon Rumah',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZTELPHOME'] != null ? _dataDetailTrackingOrder['SZTELPHOME']:"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Telepon Kantor',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZTELPKANTOR'] !=null ? _dataDetailTrackingOrder['SZTELPKANTOR'] : "",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Handphone 1',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZTELPHP1'] != null ? _dataDetailTrackingOrder['SZTELPHP1']:"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Handphone 2',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZTELPHP2'] != null ? _dataDetailTrackingOrder['SZTELPHP2']:"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            SizedBox(height: 8),
            Divider(height: 1,color: Colors.black),
            SizedBox(height: 8),
            Text('Data Pendukung',style: TextStyle(fontFamily: 'NunitoSansSemiBold',fontSize: 18)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Nama Pasangan',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZSPOUSE'] != null ? _dataDetailTrackingOrder['SZSPOUSE']:"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Ibu Kandung',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZMOTHERS'] != null ? _dataDetailTrackingOrder['SZMOTHERS'] :"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Objest Desc',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZOBJTDESC'] != null ? _dataDetailTrackingOrder['SZOBJTDESC']:"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            SizedBox(height: 8),
            Divider(height: 1,color: Colors.black),
            SizedBox(height: 8),
            Text('Data Kendaraan',style: TextStyle(fontFamily: 'NunitoSansSemiBold',fontSize: 18)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Merk',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZBRAND'] != null ? _dataDetailTrackingOrder['SZBRAND']:"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Type',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZTYPE']!=null ? _dataDetailTrackingOrder['SZTYPE']:"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Model',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZMODEL'] != null ? _dataDetailTrackingOrder['SZMODEL']:"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Tahun Produksi',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZMFGYEAR'] != null ? _dataDetailTrackingOrder['SZMFGYEAR']:"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            SizedBox(height: 8),
            Divider(height: 1,color: Colors.black),
            SizedBox(height: 8),
            Text('Data Pengajuan Kredit',style: TextStyle(fontFamily: 'NunitoSansSemiBold',fontSize: 18)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('OTR (Rp)',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZOTR'] != null ? "${_dataDetailTrackingOrder['SZOTR']}" :"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Tenor',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZTOP'] != null ? "${_dataDetailTrackingOrder['SZTOP']}":"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('DP (Down Payment)',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZDP'] == null ? "Rp.0" :"${ _dataDetailTrackingOrder['SZDP']}",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Net DP (Down Payment)',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZNETDP'] !=null ? "${_dataDetailTrackingOrder['SZNETDP']}":"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Angsuran / Bulan',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZINSTAMT'] != null ? "${_dataDetailTrackingOrder['SZINSTAMT']}":"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Survey Date',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZSURVEYDATE'] != null ? _dataDetailTrackingOrder['SZSURVEYDATE']:"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Note',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZDEALNOTE'] != null ? _dataDetailTrackingOrder['SZDEALNOTE']:"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Kontrak ID',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZKONTRAK'] != null ? _dataDetailTrackingOrder['SZKONTRAK']:"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Expanded(child: Text('PO',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
//                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
//                Expanded(child: Text(_dataDetailTrackingOrder['SZPO'],style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
//              ],
//            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('No. Dealer Account',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZDLRACCNO'] != null ? _dataDetailTrackingOrder['SZDLRACCNO'] :"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Jenis Angsuran',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZADVARR'] != null ? _dataDetailTrackingOrder['SZADVARR']:"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Order Date',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(_dataDetailTrackingOrder['SZORDERDATE'] != null ? _dataDetailTrackingOrder['SZORDERDATE']:"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
          ],
        ),
      ),
    );
  }

  void choiceAction(String choice){
    if(choice == Constants.Download){
//      generatePDF();
    }
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState
        .showSnackBar(
        SnackBar(
            content: Text(text),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3)
        )
    );
  }
}
