import 'package:flutter/cupertino.dart';
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
    return (loading) ? LoadingWidget() : SingleChildScrollView(child: showHistoryData());
  }
}

Widget showHistoryData(){
  List<Widget> history = [];

  for(var i = 0; i < historyData.length; i++){
    history.add(
      ExpansionTile(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                      'To: ',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(historyData[i]['to'].join(', ')),
                ],
              ),
              Text(
                '${historyData[i]['subject']}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
        children: <Widget>[
          (historyData[i]['cc'].length == 0)
              ? Container()
              : Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 2.0, 12.0, 2.0),
                child: Row(
                  children: [
                    Text(
                      'cc: ',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                        historyData[i]['cc'].join(', '),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
          (historyData[i]['bcc'].length == 0)
              ? Container()
              : Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 2.0, 12.0, 2.0),
                child: Row(
                  children: [
                    Text(
                      'bcc: ',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      historyData[i]['bcc'].join(', '),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Html(
              data: historyData[i]['html_body']
            ),
          ),
        ],
      )
    );
  }
  return Column(
    children: history,
  );
}