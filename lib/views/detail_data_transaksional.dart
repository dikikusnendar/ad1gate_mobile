import 'dart:io';

import 'package:adira_finance/custom/constan_pop_up_menu.dart';
import 'package:adira_finance/custom/responsive_screen.dart';
import 'package:adira_finance/model/submit_order_model.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:pdf/pdf.dart';

import '../main.dart';
import 'submit_page.dart';
import 'home.dart';

class DetailTransaksional extends StatefulWidget {
  final ResultSubmitOrder resultSubmitOrder;

  const DetailTransaksional({Key key, this.resultSubmitOrder}) : super(key: key);
  @override
  _DetailTransaksionalState createState() => _DetailTransaksionalState();
}

class _DetailTransaksionalState extends State<DetailTransaksional> {

  PermissionStatus permissionStatus;
  String dirLoc = "";
  var path = "No Data";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
                      pdfLib.Text('Data Nasabah',style: pdfLib.TextStyle(font: ttfBold,fontSize: 18)),
                      pdfLib.SizedBox(height: 16),
                      pdfLib.Row(
                          children:  <pdfLib.Widget>[
                            pdfLib.Expanded(flex: 5, child: pdfLib.Text("Nomor KTP", style: pdfLib.TextStyle(font: ttf,))),
                            pdfLib.Expanded(flex: 1, child: pdfLib.Text(":", style: pdfLib.TextStyle(font: ttf,))),
                            pdfLib.Expanded(flex: 6, child: pdfLib.Text(
                                widget.resultSubmitOrder.KTP_No != null
                                    ?
                                widget.resultSubmitOrder.KTP_No : "", style: pdfLib.TextStyle(font: ttf))),
                          ]
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                          children:  <pdfLib.Widget>[
                            pdfLib.Expanded(flex: 5, child: pdfLib.Text("Nama Lengkap", style: pdfLib.TextStyle(font: ttf,))),
                            pdfLib.Expanded(flex: 1, child: pdfLib.Text(":", style: pdfLib.TextStyle(font: ttf,))),
                            pdfLib.Expanded(flex: 6, child: pdfLib.Text(widget.resultSubmitOrder.lastName != null ? widget.resultSubmitOrder.lastName  : "", style: pdfLib.TextStyle(font: ttf))),
                          ]
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                          children:  <pdfLib.Widget>[
                            pdfLib.Expanded(flex: 5, child: pdfLib.Text("Tempat Lahir", style: pdfLib.TextStyle(font: ttf,))),
                            pdfLib.Expanded(flex: 1, child: pdfLib.Text(":", style: pdfLib.TextStyle(font: ttf,))),
                            pdfLib.Expanded(flex: 6, child: pdfLib.Text(widget.resultSubmitOrder.BirthPlace != null ? widget.resultSubmitOrder.BirthPlace : "",style: pdfLib.TextStyle(font: ttf))),
                          ]
                      ),
                      pdfLib.Row(
                          children:  <pdfLib.Widget>[
                            pdfLib.Expanded(flex: 5, child: pdfLib.Text("Tanggal Lahir", style: pdfLib.TextStyle(font: ttf,))),
                            pdfLib.Expanded(flex: 1, child: pdfLib.Text(":", style: pdfLib.TextStyle(font: ttf,))),
                            pdfLib.Expanded(flex: 6, child: pdfLib.Text(widget.resultSubmitOrder.BirthDate != null ? widget.resultSubmitOrder.BirthDate : "", style: pdfLib.TextStyle(font: ttf))),
                          ]
                      ),
                      pdfLib.Text('Data Nasabah',style: pdfLib.TextStyle(font: ttfBold,fontSize: 18)),
                      pdfLib.SizedBox(height: 16),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Status Pernikahan',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.MaritalStatus != null ?widget.resultSubmitOrder.MaritalStatus : "",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Alamat Survey',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.Survey_Address,style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('RT/RW',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text("${widget.resultSubmitOrder.RT}/${widget.resultSubmitOrder.RW}",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Kecamatan',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.Kecamatan != null ? widget.resultSubmitOrder.Kecamatan : "",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Kelurahan',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.Kelurahan != null ? widget.resultSubmitOrder.Kelurahan : "",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Provinsi',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.Provinsi != null ? widget.resultSubmitOrder.Provinsi :"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Kabupaten/Kota',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.Kab_Kota != null ? widget.resultSubmitOrder.Kab_Kota : "",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Kode Pos',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.ZipCode != null ? widget.resultSubmitOrder.ZipCode :"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Alamat KTP',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child:pdfLib.Text(widget.resultSubmitOrder.KTP_Address,style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('KTP RT/KTP RW',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child:pdfLib.Text("${widget.resultSubmitOrder.KTP_RT}/${widget.resultSubmitOrder.KTP_RW}",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('KTP Kecamatan',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child:pdfLib.Text(widget.resultSubmitOrder.KTP_Kecamatan,style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('KTP Kelurahan',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.KTP_Kelurahan != null ? widget.resultSubmitOrder.KTP_Kelurahan :"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('KTP Kecamatan',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.KTP_Kecamatan != null ? widget.resultSubmitOrder.KTP_Kecamatan :"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('KTP Kab/Kota',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.KTP_KabKota != null ? widget.resultSubmitOrder.KTP_KabKota : "",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('KTP Prov',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.KTP_Provinsi != null ? widget.resultSubmitOrder.KTP_Provinsi : "",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('KTP KodePos',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.KTP_ZipCode,style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Phone No',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.Phone_No != null ? widget.resultSubmitOrder.Phone_No : "",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('No HP',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text( widget.resultSubmitOrder.HP_No != null ? widget.resultSubmitOrder.HP_No :"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Pekerjaan',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.Pekerjaan,style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 16),
                      pdfLib.Text('Data Kendaraan',style: pdfLib.TextStyle(font: ttfBold,fontSize: 18)),
                      pdfLib.SizedBox(height: 16),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Jenis Kendaraan',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.Jenis_Kendaraan != null ? widget.resultSubmitOrder.Jenis_Kendaraan :"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Model Kendaraan',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.Model_Kendaraan != null ? widget.resultSubmitOrder.Model_Kendaraan :"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Type Kendaraan',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.Type_kendaraan != null ? widget.resultSubmitOrder.Type_kendaraan :"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Merk Kendaraan',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.Merk_Kendaraan != null ? widget.resultSubmitOrder.Merk_Kendaraan :"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Tahun Kendaraan',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.Tahun_Kendaraan,style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('BPKB Nama',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.BPKB_Name,style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 16),
                      pdfLib.Text('Data Pengajuan Kredit',style: pdfLib.TextStyle(font: ttfBold,fontSize: 18)),
                      pdfLib.SizedBox(height: 16),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Jenis Pembiayaan',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text("${widget.resultSubmitOrder.Jenis_Pembiayaan}",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('OTR',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text("Rp ${widget.resultSubmitOrder.OTR}",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Tenor',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text("${widget.resultSubmitOrder.Tenor}",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('DP',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.Gross_DP != null ? "Rp ${widget.resultSubmitOrder.Gross_DP}" :"Rp ${widget.resultSubmitOrder.NET_DP}",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Installment',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text("Rp ${widget.resultSubmitOrder.Installment}",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 16),
                      pdfLib.Text('Data Lain',style: pdfLib.TextStyle(font: ttfBold,fontSize: 18)),
                      pdfLib.SizedBox(height: 16),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Order NO',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.orderNo,style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Order Date',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.orderDate,style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Survey Date',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.SurveyDate,style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: <pdfLib.Widget>[
                          pdfLib.Expanded(child: pdfLib.Text('Catatan Dealer',style: pdfLib.TextStyle(font: ttf)),flex: 5,),
                          pdfLib.Expanded(child: pdfLib.Text(':',style: pdfLib.TextStyle(font: ttf)),flex: 1,),
                          pdfLib.Expanded(child: pdfLib.Text(widget.resultSubmitOrder.DLC_Note != null ? widget.resultSubmitOrder.HP_No :"",style: pdfLib.TextStyle(font: ttf)),flex: 6,)
                        ],
                      ),
                      pdfLib.SizedBox(height: 8),
                      pdfLib.SizedBox(height: 8),
                    ]
                );
            })
    );

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

  void choiceAction(String choice){
    if(choice == Constants.Download){
      generatePDF();
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
  Screen size;

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Detail data",style: TextStyle(fontFamily: "NunitoSans",color: Colors.black)),
        centerTitle: true,
        backgroundColor: myPrimaryColor,
        iconTheme: IconThemeData(color: Colors.black),
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
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: size.wp(3)),
        child: ListView(
          padding: EdgeInsets.only(top: size.hp(2),bottom: size.hp(2)),
          children: <Widget>[
            Text('Data Nasabah',style: TextStyle(fontFamily: 'NunitoSansSemiBold',fontSize: 18)),
            SizedBox(height: size.hp(2)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Nomor KTP',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.KTP_No,style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Nama Lengkap',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.lastName,style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Tempat Lahir',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.BirthPlace,style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Tanggal Lahir',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.BirthDate,style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Status Perkawinan',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.MaritalStatus != null ?widget.resultSubmitOrder.MaritalStatus : "",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Alamat Survey',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.Survey_Address,style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('RT/RW',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text("${widget.resultSubmitOrder.RT}/${widget.resultSubmitOrder.RW}",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Kecamatan',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.Kecamatan != null ? widget.resultSubmitOrder.Kecamatan : "",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Kelurahan',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.Kelurahan != null ? widget.resultSubmitOrder.Kelurahan : "",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Kabupaten/Kota',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.Kab_Kota != null ? widget.resultSubmitOrder.Kab_Kota : "",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Provinsi ',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.Provinsi != null ? widget.resultSubmitOrder.Provinsi :"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Kode Pos',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.ZipCode != null ? widget.resultSubmitOrder.ZipCode :"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Alamat KTP',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.KTP_Address,style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('RT KTP/RW KTP',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text("${widget.resultSubmitOrder.KTP_RT}/${widget.resultSubmitOrder.KTP_RW}",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Kecamatan KTP',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.KTP_Kecamatan,style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Kecamatan KTP',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.KTP_Kecamatan != null ? widget.resultSubmitOrder.KTP_Kecamatan :"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Kelurahan KTP',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.KTP_Kelurahan != null ? widget.resultSubmitOrder.KTP_Kelurahan :"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Kabupaten/Kota KTP',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.KTP_KabKota != null ? widget.resultSubmitOrder.KTP_KabKota : "",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Provinsi KTP',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.KTP_Provinsi != null ? widget.resultSubmitOrder.KTP_Provinsi : "",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('KTP KodePos',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.KTP_ZipCode,style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Telepon',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(
                    widget.resultSubmitOrder.Phone_No != null
                        ?
                    widget.resultSubmitOrder.Phone_No
                        :
                    "",
                    style: TextStyle(fontFamily: 'NunitoSans')
                ),
                    flex: 6
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Handphone',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.HP_No != null ? widget.resultSubmitOrder.HP_No :"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Pekerjaan',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.Pekerjaan,style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            SizedBox(height: size.hp(2)),
            Divider(height: 1,color: Colors.black),
            SizedBox(height: size.hp(2)),
            Text('Data Kendaraan',style: TextStyle(fontFamily: 'NunitoSansSemiBold',fontSize: 18)),
            SizedBox(height: size.hp(2)),
            Row(
              children: <Widget>[
                Expanded(child: Text('Jenis Kendaraan',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.Jenis_Kendaraan != null ? widget.resultSubmitOrder.Jenis_Kendaraan :"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Model',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.Model_Kendaraan != null ? widget.resultSubmitOrder.Model_Kendaraan :"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(child: Text('Tipe',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.Type_kendaraan != null ? widget.resultSubmitOrder.Type_kendaraan :"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Merk',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.Merk_Kendaraan != null ? widget.resultSubmitOrder.Merk_Kendaraan :"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(child: Text('Tahun Kendaraan',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.Tahun_Kendaraan,style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Nama BPKB',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.BPKB_Name,style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            SizedBox(height: size.hp(2)),
            Divider(height: 1,color: Colors.black),
            SizedBox(height: size.hp(2)),
            Text('Data Pengajuan Kredit',style: TextStyle(fontFamily: 'NunitoSansSemiBold',fontSize: 18)),
            SizedBox(height: size.hp(2)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Jenis Pembiayaan',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text("${widget.resultSubmitOrder.Jenis_Pembiayaan}",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('OTR',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text("Rp ${widget.resultSubmitOrder.OTR}",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Tenor',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text("${widget.resultSubmitOrder.Tenor}",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('DP',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.Gross_DP != null ? "Rp ${widget.resultSubmitOrder.Gross_DP}" :"Rp ${widget.resultSubmitOrder.NET_DP}",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Installment',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text("Rp ${widget.resultSubmitOrder.Installment}",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            SizedBox(height: size.hp(2)),
            Divider(height: 1,color: Colors.black),
            SizedBox(height: size.hp(2)),
            Text('Data Lain',style: TextStyle(fontFamily: 'NunitoSansSemiBold',fontSize: 18)),
            SizedBox(height: size.hp(2)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Order No',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.orderNo,style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Order Date',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.orderDate,style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Survey Date',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.SurveyDate,style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Catatan Dealer',style: TextStyle(fontFamily: 'NunitoSans')),flex: 5,),
                Expanded(child: Text(':',style: TextStyle(fontFamily: 'NunitoSans')),flex: 1,),
                Expanded(child: Text(widget.resultSubmitOrder.DLC_Note != null ? widget.resultSubmitOrder.HP_No :"",style: TextStyle(fontFamily: 'NunitoSans')),flex: 6,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
