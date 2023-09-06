import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiKey = 'f9e175f692b88f0a0995ca0fcdfdd0a8';


// List with all the job offers that result from the search query
// Also has all the information for each specific job offer
Future<List<dynamic>> searchJobsIT(String query) async{

  List <dynamic> jobsFromQuery = [];

  final response = await http.get(
    Uri.parse('https://api.itjobs.pt/job/search.json?api_key=$apiKey&q=$query'),
  );

  if(response.statusCode == 200){
    dynamic json = jsonDecode(response.body);
    
    for (var i in json["results"]){
      jobsFromQuery.add(i);
    }
    return jobsFromQuery;
  }
  else{
    throw Exception('Request failed with status: ${response.statusCode}');
  }
}

// Returns a job offer based on an ID
Future <dynamic> getJobsIT(int id) async{

  final response = await http.get(
    Uri.parse('https://api.itjobs.pt/job/get.json?api_key=$apiKey&id=$id'),
  );

  if(response.statusCode == 200){
    dynamic json = jsonDecode(response.body);
    
    return json;
  }
  else{
    throw Exception('Request failed with status: ${response.statusCode}');
  }
}
