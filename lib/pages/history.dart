import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../data/history_data.dart';
import '../widgets/loading_widget.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({ Key? key }) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool datastatus = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5)).then((e) async {
      datastatus = await getMails();
      print(historyData);
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (loading) ? LoadingWidget() : SingleChildScrollView(child: showHistoryData())
    );
  }
}

Widget showHistoryData(){
  List<Widget> history = [];

  for(var i = 0; i < historyData.length; i++){
    history.add(
      ExpansionTile(
        title: Text('${historyData[i]['to']}'),
        children: <Widget>[
          Html(
            data: historyData[i]['html_body']
          ),
          Text('${historyData[i]['subject']}'),
        ],
      )
    );
  }
  return Column(
    children: history,
  );
}