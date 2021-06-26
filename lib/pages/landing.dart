import 'package:code_bois/utils/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../data/history_data.dart';
import '../widgets/loading_widget.dart';

//pages
import './home.dart';
import './history.dart';
import './compose_email.dart';

// ignore: must_be_immutable
class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User? user = FirebaseAuth.instance.currentUser;
  int selectedIndex = 0;

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

  Future<void> handleTap(String value) async {
    switch (value) {
      case 'SIGNOUT':
        await AuthenticationService().signOut();
        break;
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return (loading) ? LoadingWidget() : Scaffold(
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
      body: IndexedStack(
        children: <Widget>[
          HomePage(),
          HistoryPage()
        ],
        index: selectedIndex,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => 
                  ComposeEmailPage(),
                ),
            );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}