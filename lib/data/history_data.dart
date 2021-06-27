import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

List<dynamic> results = [];
List<dynamic> historyData = [];
List<dynamic> homeData = [];
var mailData = {};

Future<bool> getMails() async {
  try {
    results = [];
    historyData = [];
    homeData = [];
    mailData = {};

    print("hey");
    print(googlesigninornot);
    print(accesstoken);
    print(emailid);
    print(uid);

    if(emailid == "none"){
      emailid = FirebaseAuth.instance.currentUser!.email!;
      if(emailid.endsWith("@codebois.com")){
        googlesigninornot = false;
      }
    }

    if(uid == "none"){
      uid = FirebaseAuth.instance.currentUser!.uid;
    }
    
    if (googlesigninornot == true && emailid != "none" && uid != "none") {
      print(accesstoken);
      print(emailid);
      print(uid);
      print(googlesigninornot);
      var queryParameters = {
        'api_key': 'GAURAV',
        'email_id': emailid,
      };
      
      var baseUrl = "stark-castle-06298.herokuapp.com";
      
      var uri = Uri.https(baseUrl, '/getMails', queryParameters);
      print("PINGING:" + uri.toString());
      
      var response = await http.get(uri);
      Map<String, dynamic> responseJson = jsonDecode(response.body);
       
      if(responseJson['success'] == true){
        results = responseJson['results'] as List<dynamic>;
        
        if(results.length > 0){
          mailData = results[0];
          historyData = mailData["sent_mails"] as List<dynamic>;
          homeData = mailData["future_mails"] as List<dynamic>;
        }        
        
        print(historyData);
        return true;       
      } 
      else {
        print(responseJson['message']);
        return false;
      }
    } 
    else {
      return false;
    }

  } on Exception catch (e) {
    print(e);
    return false;
  }
}

Future<bool> scheduleMail(mailData) async {
  try {
    if(emailid == "none"){
      emailid = FirebaseAuth.instance.currentUser!.email!;
      if(emailid.endsWith("@codebois.com")){
        googlesigninornot = false;
      }
    }

    if(uid == "none"){
      uid = FirebaseAuth.instance.currentUser!.uid;
    }

    if (googlesigninornot == true && emailid != "none" && uid != "none") {
      print(accesstoken);
      print(emailid);
      print(uid);
      print(googlesigninornot);
      var queryParameters = {
        'api_key': 'GAURAV',
        'email_id': emailid,
        'tocken': accesstoken,
        'to': mailData['to'],
        'subject': mailData['subject'],
        'cc': mailData['cc'],
        'bcc': mailData['bcc'],
        'html': mailData['html'],
        'schedule': mailData['schedule'],
        'method': mailData['method'],
        'seconds': mailData['seconds'],
        'minutes': mailData['minutes'],
        'hours': mailData['hours'],
        'day': mailData['day'],
        'date': mailData['date'],
        'month': mailData['month'],
        'year': mailData['year'],
        'id': mailData['id']
      };

      var baseUrl = "stark-castle-06298.herokuapp.com";

      var uri = Uri.https(baseUrl, '/scheduleMail', queryParameters);
      print("PINGING:" + uri.toString());

      var response = await http.get(uri);
      Map<String, dynamic> responseJson = jsonDecode(response.body);

      if(responseJson['success'] == true){
        print("Mails scheduled");
        return true;
      }
      else {
        print(responseJson['message']);
        return false;
      }
    }
    else {
      return false;
    }

  } on Exception catch (e) {
    print(e);
    return false;
  }
}

Future<bool> cancelMail(id) async {
  try {
    if(emailid == "none"){
      emailid = FirebaseAuth.instance.currentUser!.email!;
      if(emailid.endsWith("@codebois.com")){
        googlesigninornot = false;
      }
    }

    if(uid == "none"){
      uid = FirebaseAuth.instance.currentUser!.uid;
    }

    if (googlesigninornot == true && emailid != "none" && uid != "none") {
      print(accesstoken);
      print(emailid);
      print(uid);
      print(googlesigninornot);
      var queryParameters = {
        'api_key': 'GAURAV',
        'id': id,
        'email_id': emailid
      };

      var baseUrl = "stark-castle-06298.herokuapp.com";

      var uri = Uri.https(baseUrl, '/stopMail', queryParameters);
      print("PINGING:" + uri.toString());

      var response = await http.get(uri);
      Map<String, dynamic> responseJson = jsonDecode(response.body);

      if(responseJson['success'] == true){
        print("Mails stopped");
        return true;
      }
      else {
        print(responseJson['message']);
        return false;
      }
    }
    else {
      return false;
    }

  } on Exception catch (e) {
    print(e);
    return false;
  }
}

//var url = Uri.parse("https://stark-castle-06298.herokuapp.com/getMails?api_key=GAURAV&email_id=gauravhviramgami@gmail.com");
//var url = https://stark-castle-06298.herokuapp.com/scheduleMail?api_key=GAURAV&email_id=reubendevanesan@gmail.com&tocken=ya29.a0ARrdaM-nBR-ZM7MYw6eBzPtXYTWD7fLJm8yHj2ha_iGsV6yGMnJFsosTG46omDp5-B9EE3WujLFhDyTEtHV7ZIsJPW_xYO7WSqiP1Tbs9KSVLnxDa7bdDIA_f7rO5GAjo4iSrr7xkuTAxRrk8uGfEhlEg-Ol&to=viramgami.g@iitgn.ac.in&cc=reuben.sd@iitgn.ac.in&from=reubendevanesan@gmail.com&subject=This is a test subject&html=<h1>Hello! This is test Mail</h1>