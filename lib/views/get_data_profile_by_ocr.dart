import 'dart:async';
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

class GetDataProfileByOCR extends StatefulWidget {
  final ValueChanged<List> dataKTP;

  const GetDataProfileByOCR({Key key, this.dataKTP}) : super(key: key);
  @override
  _GetDataProfileByOCRState createState() => _GetDataProfileByOCRState();
}

class _GetDataProfileByOCRState extends State<GetDataProfileByOCR> {
  File pickedImage;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timerShowBottomSheet();
  }

  _timerShowBottomSheet(){
    Timer(Duration(milliseconds: 300), () {
      _settingModalBottomSheet(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: myPrimaryColor,
        title: Text("Get Profile Data by OCR"),
        actions: <Widget>[
          FlatButton(onPressed: (){
            _settingModalBottomSheet(context);}, child: Text("Take Picture"))
        ],
      ),
      body: pickedImage != null ? Center(
        child: Container(
            margin: EdgeInsets.only(left: 16,right: 16),
            child: ClipRRect(
              child: Image.file(pickedImage,height: 350,width: 400,),
              borderRadius: new BorderRadius.circular(8.0),
            )
        ),
      ) : SizedBox(height: 0.0,width: 0.0),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                FlatButton(
                    onPressed: () {
                      _pilihKamera();
                      Navigator.pop(context);
                    },
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.photo_camera,
                            color: Colors.black,
                            size: 22.0,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Text(
                            "Kamera",
                            style: TextStyle(fontSize: 18.0),
                          )
                        ])),
                FlatButton(
                    onPressed: () {
                      _loadAsset();
                      Navigator.pop(context);
                    },
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.photo,
                            color: Colors.black,
                            size: 22.0,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Text(
                            "Galeri",
                            style: TextStyle(fontSize: 18.0),
                          )
                        ]
                    )
                ),
              ],
            ),
          );
        });
  }

  _pilihKamera() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
    if(image!=null){
      setState(() {
        pickedImage = image;
        readText();
      });
    }else{
      print("Tidak ada image dipilih");
    }
  }

  _loadAsset() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    if(image!=null){
      setState(() {
        pickedImage = image;
        readText();
      });
    }else{
      print("Tidak ada image dipilih");
    }
  }

  Future readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

//
//    List<String> _myText = [];
    List<String> _myLineText  = [];
//    TextBlock textBlock;
    String text = readText.text;
//    String _newText = text.replaceAll("NIK", "");
//    String _newText1 = _newText.replaceAll("Nama", "");
    print("cek _newText1 $text");

//    print("cek vision $text");
    List<String> _myText = [];
    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        _myLineText.add(line.text);
        for (TextElement textElement in line.elements)
          _myText.add(textElement.text);
      }
    }
    recognizeText.close();
    var _listDataOCR = [];
    if (_myText[0] != "PROVINSI") {
      _showSnackBar("Ini bukan KTP");
    }
    else {
//      for(var i=0; i < _myLineText.length; i++){
//        print(_myLineText[i]);
//      }

      var _listTempatLahir = [];
      var _listTanggalLahir = [];
      var _listRT = [];
      var _listRW = [];

      String _NIK = '';
      if (_myLineText[2].contains('NIK'))
        {
          _NIK = _myLineText[3];
        }
      else
        {
          _NIK = _myLineText[2];
        }

      _listDataOCR.add(_NIK); //0-NIK
      _listDataOCR.add(_myLineText[4]); //1-Nama

      String _splitTempatTglLahir = _myLineText[5];

      var _tempatTanggalLahir = _splitTempatTglLahir.split(",");
      _listTempatLahir.add(_tempatTanggalLahir[0]);
      _listDataOCR.add(_listTempatLahir[0]); //2-TempatLahir

      //_listTanggalLahir.add(_tempatTanggalLahir[1]);
      //_listDataOCR.add(_listTanggalLahir[0]); //3-TanggalLahir
      _listDataOCR.add(''); //3-TanggalLahir

      _listDataOCR.add(_myLineText[12]); //4-AlamatSurvey

      String _rtRw = '';
      if (_myLineText[9].contains('/'))
      {
      _rtRw = _myLineText[9];
      }
      else if (_myLineText[8].contains('/'))
      {
        _rtRw = _myLineText[8];
      }
      else if (_myLineText[7].contains('/'))
      {
      _rtRw = _myLineText[7];
      }
      else if (_myLineText[6].contains('/'))
      {
        _rtRw = _myLineText[6];
      }

      var _splitRtRw = _rtRw.split("/");
      _listRT.add(_splitRtRw[0]);
      _listDataOCR.add(_listRT[0]); //5-RT

      _listRW.add(_splitRtRw[1]);
      _listDataOCR.add(_listRW[0]); //6-RW

      widget.dataKTP(_listDataOCR);
    }
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text),behavior: SnackBarBehavior.floating));
  }


}
