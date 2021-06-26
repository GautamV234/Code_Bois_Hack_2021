import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_summernote/flutter_summernote.dart';

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

  GlobalKey<FlutterSummernoteState> _keyEditor = GlobalKey();
  late TextEditingController _toController;
  late TextEditingController _subjectController;
  late TextEditingController _ccController;
  late TextEditingController _bccController;

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
      body: SingleChildScrollView(
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
                    onPressed: () {
                      //TODO: Send Mail
                    },
                  ),
                  OutlinedButton.icon(
                    label: Text('Schedule'),
                    icon: Icon(Icons.schedule,),
                    onPressed: () {
                      //TODO: Schedule Mail
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