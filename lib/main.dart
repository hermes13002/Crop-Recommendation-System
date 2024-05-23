import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather/weather.dart';



void main() {
  runApp(const MaterialApp(
    home: CropRecommendationPage(),
    debugShowCheckedModeBanner: false,
  ));
}


class CropRecommendationPage extends StatefulWidget {
  const CropRecommendationPage({super.key});

  @override
  _CropRecommendationPageState createState() => _CropRecommendationPageState();
}

class _CropRecommendationPageState extends State<CropRecommendationPage> {
  
  TextEditingController locationController = TextEditingController();
  TextEditingController nitrogenController = TextEditingController();
  TextEditingController phosphorusController = TextEditingController();
  TextEditingController potassiumController = TextEditingController();
  TextEditingController tempController = TextEditingController();
  TextEditingController humidityController = TextEditingController();
  TextEditingController pHController = TextEditingController();
  TextEditingController rainfallController = TextEditingController();


  String predictedCrop = '';

  Future<void> predictCrop() async {
    var url = Uri.parse('http://10.0.2.2:5000/predict');
    
    var data = {
      'N': nitrogenController.text,
      'P': phosphorusController.text,
      'K': potassiumController.text,
      'temperature': tempController.text,
      'humidity': humidityController.text,
      'ph': pHController.text,
      'rainfall': rainfallController.text
    };

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    print(data);

    if (response.statusCode == 200) {
      setState(() {
        predictedCrop = jsonDecode(response.body)['predicted_crop'];
        print(predictedCrop);
      });
    } else if (response.statusCode == 500){
      predictedCrop = 'Internal Server Error, please contact developer';
    }
    else if (response.statusCode == 400){
      predictedCrop = 'Bad Request, please contact developer or check your input values again';
    }
    else if (response.statusCode == 405){
      predictedCrop = 'Method Not Allowed, please contact developer';
    }
    else {
      predictedCrop = 'Failed to get prediction';
    }

    showDialog(  
      context: context,  
      builder: (BuildContext context) {  
        return AlertDialog(
          title: Text('Result', style: TextStyle(fontSize: 16, color: Colors.deepPurple.shade300)),
          content: Text('Recommended Crop: $predictedCrop', style: TextStyle(fontSize: 18, color: Colors.deepPurple.shade300, fontWeight: FontWeight.bold),),
          actions: <Widget>[  
            ElevatedButton(  
              child: const Text('OK'),  
              onPressed: () {  
                Navigator.of(context).pop();  
              },  
            ), 
          ],
          backgroundColor: const Color.fromARGB(255, 149, 255, 153),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        );
      }
    );

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Recommendation System'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Please connect to a stable network to get location and results \nOR \nInput values for all fields.', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.deepPurple[400])),
              const SizedBox(height: 20,),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: locationController,
                      decoration: InputDecoration(
                        labelText: 'Your Location',
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple.shade300),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),

                  SizedBox(
                    width: 150,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 149, 255, 153), minimumSize: const Size(120, 50)),
                      onPressed: () {
                        String location = locationController.text;
                        _fetchWeatherData(location);
                      },
                      child: const Text(
                        "Get Location",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.deepPurple, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (_errorMessage.isNotEmpty) Text(_errorMessage),
              Text("Temperature: $_temperature °C", style: const TextStyle(color: Colors.black, fontSize: 16),),
              Text("Humidity: $_humidity %", style: const TextStyle(color: Colors.black, fontSize: 16),),
              // Text(_rainfall, style: const TextStyle(color: Colors.black, fontSize: 16),),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: tempController,
                      decoration: InputDecoration(
                        labelText: 'Temperature',
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple.shade300),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: TextFormField(
                      controller: humidityController,
                      decoration: InputDecoration(
                        labelText: 'Humidity',
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple.shade300),
                        ),
                      ),
                    ),
                  ),    
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: pHController,
                      decoration: InputDecoration(
                        labelText: 'PH Level',
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple.shade300),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: TextFormField(
                      controller: rainfallController,
                      decoration: InputDecoration(
                        labelText: 'Rainfall Level',
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple.shade300),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: nitrogenController,
                      decoration: InputDecoration(
                        labelText: 'Nitrogen Level',
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple.shade300),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: TextFormField(
                      controller: phosphorusController,
                      decoration: InputDecoration(
                        labelText: 'Phosphorus Level',
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple.shade300),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: potassiumController,
                decoration: InputDecoration(
                  labelText: 'Potassium Level',
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              OutlinedButton(
                style: OutlinedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 149, 255, 153), minimumSize: const Size(120, 50)),
                onPressed: predictCrop,
                child: const Text(
                  "Recommend Crop",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.deepPurple, fontSize: 17),
                ),
              ),
              const SizedBox(height: 20),

              // Text(
              //   'Recommended Crop: $predictedCrop',
              //   style: const TextStyle(fontSize: 16),
              // ),
            ],
          ),
        ),
      ),
    );
  }


  final WeatherFactory _wf = WeatherFactory("5bc1c678a5662a0ad445d915b6a4532f");

  Weather? _weather;

  String _temperature = '';
  String _humidity = '';
  // String _rainfall = '';
  String _errorMessage = '';

  _fetchWeatherData(String location) {
    _wf.currentWeatherByCityName(location).then((w) {
      setState(() {
        _weather = w;
      });
    });

    setState(() {
      _temperature = "${_weather?.temperature?.celsius?.toStringAsFixed(3)}";
      _humidity = "${_weather?.humidity?.toStringAsFixed(3)}";
      // _rainfall = "Rainfall: ${_weather?.rainLast3Hours?.toStringAsFixed(3)} mm";
      _errorMessage = '';
    });

    tempController.text = _temperature;
    humidityController.text = _humidity;
  }

}


