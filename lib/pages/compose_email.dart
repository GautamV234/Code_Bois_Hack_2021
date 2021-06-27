import 'package:code_bois/data/history_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_summernote/flutter_summernote.dart';
import '../widgets/loading_widget.dart';
import '../utils/authentication_service.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

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
  double _height = 0;
  double _width = 0;

  String _setTime = "";
  String _setDate = "";

  String _hour = "";
  String _minute = "";
  String _time = "";

  String dateTime = "";

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  void initState() {
    super.initState();
    _toController = TextEditingController();
    _subjectController = TextEditingController();
    _ccController = TextEditingController();
    _bccController = TextEditingController();
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
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
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
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
                        String id = emailid + cTime.second.toString() + cTime.hour.toString() + cTime.minute.toString() + cTime.day.toString() + cTime.month.toString() + cTime.year.toString();
                        showDialog(
                          context: context,
                          builder: (context) {
                            String _chosenValue = "None";
                            bool thisLoading = false;
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: Center(child: Text("Schedule Mail")),
                                  content: (thisLoading) ? LoadingWidget() : Column(
                                    children: <Widget>[
                                      SizedBox(height: 20,),
                                      Text("Choose Date"),
                                      SizedBox(height: 10,),
                                      InkWell(
                                        onTap: () {
                                          _selectDate(context);
                                        },
                                        child: Container(
                                          width: _width / 1.7,
                                          height: _height / 9,
                                          margin: EdgeInsets.only(top: 30),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(color: Colors.grey[200]),
                                          child: TextFormField(
                                            style: TextStyle(fontSize: 40),
                                            textAlign: TextAlign.center,
                                            enabled: false,
                                            keyboardType: TextInputType.text,
                                            controller: _dateController,
                                            onSaved: (String? val) {
                                              _setDate = val!;
                                            },
                                            decoration: InputDecoration(
                                                disabledBorder:
                                                UnderlineInputBorder(borderSide: BorderSide.none),
                                                // labelText: 'Time',
                                                contentPadding: EdgeInsets.only(top: 0.0)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      Text("Choose Time"),
                                      SizedBox(height: 10,),
                                      InkWell(
                                        onTap: () {
                                          _selectTime(context);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 30),
                                          width: _width / 1.7,
                                          height: _height / 9,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(color: Colors.grey[200]),
                                          child: TextFormField(
                                            style: TextStyle(fontSize: 40),
                                            textAlign: TextAlign.center,
                                            onSaved: (String? val) {
                                              _setTime = val!;
                                            },
                                            enabled: false,
                                            keyboardType: TextInputType.text,
                                            controller: _timeController,
                                            decoration: InputDecoration(
                                                disabledBorder:
                                                UnderlineInputBorder(borderSide: BorderSide.none),
                                                // labelText: 'Time',
                                                contentPadding: EdgeInsets.all(5)),
                                          ),
                                        ),
                                      ),
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
                                              'seconds': (_chosenValue == "Every 20 Seconds")?"20":((_chosenValue == "Every 30 Seconds")?"30":"0"),
                                              'minutes': selectedTime.minute.toString(),
                                              'hours': selectedTime.hour.toString(),
                                              'day': selectedDate.weekday.toString(),
                                              'date': selectedDate.day.toString(),
                                              'month': selectedDate.month.toString(),
                                              'year': selectedDate.year.toString(),
                                              "id": id
                                            };
                                            loading = true;
                                            thisLoading = true;
                                            setState(() {});
                                            await scheduleMail(mailOptions);
                                            await getMails();
                                            loading = false;
                                            thisLoading = false;
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