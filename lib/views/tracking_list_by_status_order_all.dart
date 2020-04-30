import 'package:adira_finance/main.dart';
import 'package:adira_finance/resources/get_data_tracking_api_provider.dart';
import 'package:adira_finance/views/list_tracking_by_status_order_except_all.dart';
import 'package:flutter/material.dart';

class ListTrackingByAllStatusOrder extends StatefulWidget {
  final String statusOrder,branchId,startDate,endDate,trackingId;

  const ListTrackingByAllStatusOrder({Key key, this.statusOrder, this.branchId,
    this.startDate, this.endDate, this.trackingId}) : super(key: key);
  @override
  _ListTrackingByAllStatusOrderState createState() => _ListTrackingByAllStatusOrderState();
}

class _ListTrackingByAllStatusOrderState extends State<ListTrackingByAllStatusOrder> {

  GetDataTrackingApiProvider _getDataTrackingApiProvider;
  var _lisTrackingByStatusOrderAll = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _total = 0;
  var _loadDataTrackingCount = false;

  @override
  void initState() {
    super.initState();
    _getDataTrackingApiProvider = GetDataTrackingApiProvider();
    _getDataTrackingByAllStatusOrder();
  }

  _getDataTrackingByAllStatusOrder() async{
    setState(() {
      _loadDataTrackingCount = true;
    });
    var _result = await _getDataTrackingApiProvider.getTrackingByStatusOrderAll(
        widget.statusOrder, widget.branchId, widget.startDate, widget.endDate, widget.trackingId
    );
    if(_result['status']){
      for(var i=0; i<_result["listDataTrackingCount"].length; i++){
        _lisTrackingByStatusOrderAll.add(_result['listDataTrackingCount'][i]);
        _total += _lisTrackingByStatusOrderAll[i]['Jumlah'];
      }
      setState(() {
        _loadDataTrackingCount = false;
      });
    }
    else{
      print(_result['Message']);
      setState(() {
        _loadDataTrackingCount = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title:
        Text(
            "Tracking Order All Status",
            style: TextStyle(
                fontFamily: "NunitoSans",color: Colors.black
            )
        ),
        centerTitle: true,
        backgroundColor: myPrimaryColor,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: _loadDataTrackingCount
          ?
      Center(
        child: CircularProgressIndicator(),
      )
          :
      ListView.builder(
        itemBuilder: (context,index){
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(_lisTrackingByStatusOrderAll[index]['Status'],style: TextStyle(fontFamily: "NunitoSans")),
                Text("${_lisTrackingByStatusOrderAll[index]['Jumlah']}",style: TextStyle(fontFamily: "NunitoSans")),
              ],
            ),
            onTap: (){
              print("cek branchid bro ${widget.branchId}");
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ListTrackingByCategory(
                    branchId: widget.branchId,
                    endDate: widget.endDate,
                    startDate: widget.startDate,
                    statusOrder: _lisTrackingByStatusOrderAll[index]['StatusValue'],
                    trackingId: widget.trackingId,
                  ))
              );
            },
          );
        },itemCount: _lisTrackingByStatusOrderAll.length,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        color: myPrimaryColor,
        child: Container(
          height: 50,
          margin: EdgeInsets.only(left: 16),
          child: Row(
            children: <Widget>[
              Expanded(child: Text("Total",style: TextStyle(fontFamily: "NunitoSans",fontSize: 16)),flex: 9),
              Expanded(child: Text("$_total",style: TextStyle(fontFamily: "NunitoSans",fontSize: 16)),flex: 1)
            ],
          ),
        ),
      ),
    );
  }
  void _showSnackBar(String text) {
    _scaffoldKey.currentState
        .showSnackBar(
        SnackBar(
            content: Text(text),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2)
        )
    );
  }
}
