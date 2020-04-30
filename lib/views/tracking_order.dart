import 'package:adira_finance/custom/responsive_screen.dart';
import 'package:adira_finance/views/submit_page.dart';
import 'package:adira_finance/views/tracking_page.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class TrackingOrder extends StatefulWidget {
  final String title;
  final Function onMapTap;

  const TrackingOrder({Key key, this.title, this.onMapTap}) : super(key: key);
  @override
  _TrackingOrderState createState() => _TrackingOrderState();
}

class _TrackingOrderState extends State<TrackingOrder> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Screen size;

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
        Text(
            "Tracking Order",
            style: TextStyle(
                fontFamily: "NunitoSans",color: Colors.black
            )
        ),
        centerTitle: true,
        backgroundColor: myPrimaryColor,
        bottom: TabBar(
            labelStyle: TextStyle(fontFamily: "NunitoSans"),
            controller: _tabController,
            indicatorColor: Colors.black,
            tabs: <Widget>[
              Tab(text: "Detail",),
              Tab(text: "Summary",), //Tracking//Submit
            ]
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            SubmitPage(),
            TrackingPageTab()
          ]
      ),
    );
  }
}