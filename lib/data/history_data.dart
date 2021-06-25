import 'dart:convert';
import 'package:http/http.dart' as http;

//var url = Uri.parse("https://stark-castle-06298.herokuapp.com/getMails?api_key=GAURAV&email_id=gauravhviramgami@gmail.com");
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