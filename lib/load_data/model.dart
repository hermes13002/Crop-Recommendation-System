// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   final String baseUrl;

//   ApiService({required this.baseUrl});

//   Future<Map<String, dynamic>> predict(List<double> features) async {
//     final url = Uri.parse('$baseUrl/predict');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'features': features}),
//     );


//     if (response.statusCode == 200) {
//       // return jsonDecode(response.body);
//       final Map<String, dynamic> data = json.decode(response.body);
//       return data['prediction'];
//     } else {
//       throw Exception('Failed to get prediction');
//     }
//   }
// }

// // http://10.0.132.16:5000
// // http://192.168.137.1:5000




// // import 'package:http/http.dart' as http;
// // import 'dart:convert';

// // class ApiService {
// //   final String baseUrl;

// //   ApiService({required this.baseUrl});

// //   Future<String> predict(Map<String, dynamic> features) async {
// //     final url = Uri.parse('$baseUrl/predict');
// //     final response = await http.post(
// //       url,
// //       headers: {'Content-Type': 'application/json'},
// //       body: json.encode({'features': features}),
// //     );

// //     if (response.statusCode == 200) {
// //       final Map<String, dynamic> data = json.decode(response.body);
// //       return data['prediction'];
// //     } else {
// //       throw Exception('Failed to get prediction');
// //     }
// //   }
// // }

// // void main() async {
// //   final apiService = ApiService(baseUrl: 'http://192.168.0.0:5000');
// //   final features = {
// //     'N': 90,
// //     'P': 42,
// //     'K': 43,
// //     'temperature': 20.5,
// //     'humidity': 80.0,
// //     'ph': 6.5,
// //     'rainfall': 200.0,
// //   };

// //   try {
// //     final prediction = await apiService.predict(features);
// //     print('Predicted crop: $prediction');
// //   } catch (e) {
// //     print('Error: $e');
// //   }
// // }

