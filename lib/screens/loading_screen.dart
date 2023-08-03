import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_app/services/location.dart';

const String apiKey = '1f0fc0d6af6d7293c3637bff6968ee57';
class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late double latitude;
  late double longitude;



  void getLocation() async{
    Location location = Location();
    await location.getCurrentLocation();
    latitude = location.latitude;
    longitude = location.longitude;
    getData();


  }


  void getData() async{
    http.Response response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey'));
  if(response.statusCode == 200){
    String data = await response.body;
    var decodedData = jsonDecode(data);
    double longitude = decodedData['coord']['lon'];
    double latitude = decodedData['coord']['lat'];
    String weatherDescription = decodedData['weather'][0]['description'];
    double weatherTemperature = decodedData['main']['temp'];
    String country = decodedData['sys']['country'];
    String cityName = decodedData['name'];
    print(latitude);
    print(longitude);
    print(weatherDescription);
    print(weatherTemperature);
    print(country);
    print(cityName);

  }else{
    print(response.statusCode);
  }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
              //Get the current location
              getLocation();

          },
          child: Text('Get Location'),
        ),
      ),
    );
  }
}
