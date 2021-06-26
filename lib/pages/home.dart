import 'package:flutter/material.dart';
import '../data/history_data.dart';
import 'package:flutter_html/flutter_html.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: showHomeData());
  }
}

Widget showHomeData(){
  List<Widget> home = [];

  for(var i = 0; i < homeData.length; i++){
    home.add(
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
                    Text(homeData[i]['to'].join(', ')),
                  ],
                ),
                Text(
                  homeData[i]['subject'],
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
          children: <Widget>[
            (homeData[i]['cc'].length == 0)
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
                    homeData[i]['cc'].join(', '),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            (homeData[i]['bcc'].length == 0)
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
                    homeData[i]['bcc'].join(', '),
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
                  data: homeData[i]['html_body']
              ),
            ),
          ],
        )
    );
  }
  return Column(
    children: home,
  );
}