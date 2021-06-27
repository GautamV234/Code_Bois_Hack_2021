import 'package:code_bois/data/history_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_summernote/flutter_summernote.dart';
import '../widgets/loading_widget.dart';
import '../utils/authentication_service.dart';

class ComposeEmailPage extends StatefulWidget {
  const ComposeEmailPage({ Key? key }) : super(key: key);

  @override
  _ComposeEmailPageState createState() => _ComposeEmailPageState();
}

class _ComposeEmailPageState extends State<ComposeEmailPage> {  
  void handleTap(String value) {
    switch (value) {
      case 'SIGNOUT':
        FirebaseAuth.instance.signOut();
        break;
      default:
        return;
    }
  }

  bool loading = false;

  GlobalKey<FlutterSummernoteState> _keyEditor = GlobalKey();
  late TextEditingController _toController;
  late TextEditingController _subjectController;
  late TextEditingController _ccController;
  late TextEditingController _bccController;

//  String _chosenValue = "None";

  @override
  void initState() {
    super.initState();
    _toController = TextEditingController();
    _subjectController = TextEditingController();
    _ccController = TextEditingController();
    _bccController = TextEditingController();
  }

  @override
  void dispose() {
    _toController.dispose();
    _subjectController.dispose();
    _ccController.dispose();
    _bccController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FLIPR HACK'),
        actions: [
          PopupMenuButton<String>(
            onSelected: handleTap,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Sign out'),
                value: 'SIGNOUT',
              ),
            ],
          ),
        ],
      ),
      body: (loading) ? LoadingWidget() : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Text(
                  'To:',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'To',
                ),
                controller: _toController,
              ),
              SizedBox(height: 20,),
              Text(
                'Subject:',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Subject',
                ),
                controller: _subjectController,
              ),
              SizedBox(height: 20,),
              Text(
                'cc:',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'cc',
                ),
                controller: _ccController,
              ),
              SizedBox(height: 20,),
              Text(
                'bcc:',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'bcc',
                ),
                controller: _bccController,
              ),
              SizedBox(height: 20,),
              FlutterSummernote(
                  hint: "Your Mail Body here...",
                  key: _keyEditor
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    label: Text('Send'),
                    icon: Icon(Icons.send,),
                    onPressed: () async {
                      if (_toController.text == '') {
                        showDialog(
                          context: context,
                          builder: (_) => new AlertDialog(
                            content: Text(
                                'Please provide the receiptant email id'),
                          ),
                        );
                      } else {
                        final _etEditor = await _keyEditor.currentState!.getText();
                        var c = _keyEditor.currentState;
                        var s = (c != null)?await c.getText():"null";
                        var mailOptions = {
                          'to': _toController.text,
                          'subject': _subjectController.text,
                          'cc': _ccController.text,
                          'bcc': _bccController.text,
                          'html': s,
                          'schedule': 'false',
                          'method': "-",
                          'seconds': "-",
                          'minutes': "-",
                          'hours': "-",
                          'day': "-",
                          'date': "-",
                          'month': "-",
                          'year': "-"
                        };
                        loading = true;
                        setState(() {});
                        await scheduleMail(mailOptions);
                        await getMails();
                        loading = false;
                        Navigator.pop(context);
                      }
                    },
                  ),
                  OutlinedButton.icon(
                    label: Text('Schedule'),
                    icon: Icon(Icons.schedule,),
                    onPressed: () async {
                      //TODO: Schedule Mail
                      if (_toController.text == '') {
                        showDialog(
                          context: context,
                          builder: (_) => new AlertDialog(
                            content: Text(
                                'Please provide the receiptant email id'),
                          ),
                        );
                      } else {
                        final _etEditor = await _keyEditor.currentState!.getText();
                        var c = _keyEditor.currentState;
                        var s = (c != null)?await c.getText():"null";
                        var to = _toController.text;
                        var subject = _subjectController.text;
                        var cc = _ccController.text;
                        var bcc = _bccController.text;
                        DateTime cTime = DateTime.now();
                        var id = emailid + cTime.second.toString() + cTime.hour.toString() + cTime.minute.toString() + cTime.day.toString() + cTime.month.toString() + cTime.year.toString();
                        showDialog(
                          context: context,
                          builder: (context) {
                            String _chosenValue = "None";
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: Center(child: Text("Schedule Mail")),
                                  content: Column(
                                    children: <Widget>[
                                      SizedBox(height: 20,),
                                      Text("When to send?"),
                                      SizedBox(height: 20,),
                                      Text("Choose Recur Type"),
                                      SizedBox(height: 10,),
                                      DropdownButton<String>(
                                        focusColor:Colors.white,
                                        value: _chosenValue,
                                        //elevation: 5,
                                        style: TextStyle(color: Colors.white),
                                        iconEnabledColor:Colors.black,
                                        items: <String>[
                                          'None',
                                          'Every 20 Seconds',
                                          'Every 30 Seconds',
                                          'Daily',
                                          'Weekly',
                                          'Monthly',
                                          'Yearly'
                                        ].map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value,style:TextStyle(color:Colors.black),),
                                          );
                                        }).toList(),
                                        onChanged: (String? value) {
                                          setState(() {
                                            _chosenValue = value!;
                                          });
                                        },
                                      ),
                                      SizedBox(height: 20,),
                                      OutlinedButton.icon(
                                          label: Text('Schedule'),
                                          icon: Icon(Icons.schedule,),
                                          onPressed: () async {
                                            var mailOptions = {
                                              'to': to,
                                              'subject': subject,
                                              'cc': cc,
                                              'bcc': bcc,
                                              'html': s,
                                              'schedule': (_chosenValue == "None")?'false':'true',
                                              'method': _chosenValue,
                                              'seconds': "-",
                                              'minutes': "-",
                                              'hours': "-",
                                              'day': "-",
                                              'date': "-",
                                              'month': "-",
                                              'year': "-",
                                              "id": id
                                            };
                                            loading = true;
                                            setState(() {});
                                            await scheduleMail(mailOptions);
                                            await getMails();
                                            loading = false;
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                            Navigator.pop(context);
                                          }
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}