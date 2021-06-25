import 'dart:convert';
import 'package:http/http.dart' as http;

//var url = Uri.parse("https://stark-castle-06298.herokuapp.com/getMails?api_key=GAURAV&email_id=gauravhviramgami@gmail.com");
//var url = https://stark-castle-06298.herokuapp.com/scheduleMail?api_key=GAURAV&email_id=reubendevanesan@gmail.com&tocken=ya29.a0ARrdaM-nBR-ZM7MYw6eBzPtXYTWD7fLJm8yHj2ha_iGsV6yGMnJFsosTG46omDp5-B9EE3WujLFhDyTEtHV7ZIsJPW_xYO7WSqiP1Tbs9KSVLnxDa7bdDIA_f7rO5GAjo4iSrr7xkuTAxRrk8uGfEhlEg-Ol&to=viramgami.g@iitgn.ac.in&cc=reuben.sd@iitgn.ac.in&from=reubendevanesan@gmail.com&subject=This is a test subject&html=<h1>Hello! This is test Mail</h1>

List<dynamic> results = [];
var mailData = {};
List<dynamic> historyData = [];
List<dynamic> homeData = [];

Future<bool> getMails() async {
  try {
    var queryParameters = {
      'api_key': 'GAURAV',
      'email_id': 'gauravhviramgami@gmail.com',
    };
    
    var baseUrl = "stark-castle-06298.herokuapp.com";
    
    var uri = Uri.https(baseUrl, '/getMails', queryParameters);
    print("PINGING:" + uri.toString());
    
    var response = await http.get(uri);
    Map<String, dynamic> responseJson = jsonDecode(response.body);
     
    if(responseJson['success'] == true){
      results = responseJson['results'] as List<dynamic>;
      mailData = results[0];
      historyData = mailData["sent_mails"] as List<dynamic>;
      homeData = mailData["future_mails"] as List<dynamic>;
      
      return true;
    } else {
      print(responseJson['message']);
      return false;
    }
  } on Exception catch (e) {
    print(e);
    return false;
  }
}