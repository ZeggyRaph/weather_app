import 'package:flutter/material.dart';
import 'package:weather_app/utilities/constants.dart';
import 'package:weather_app/services/weather.dart';
import 'package:weather_app/screens/city_screen.dart';

class LocationScreen extends StatefulWidget {
  final locationWeather;
  LocationScreen({this.locationWeather});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  CityScreen cityScreen = CityScreen();


  WeatherModel weatherModel = WeatherModel();
  late String weatherMessage;
  late String weatherIcon;
late int temperature;
late String cityName;
late double lat;
late double lon;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(weatherData){
setState(() {
  if(weatherData == null){
    temperature = 0;
    weatherIcon = 'Error';
    weatherMessage = 'Unable to get weather data';
    cityName = 'the location entered';
    lat = 0;
    lon = 0;

    return;
  }
  double weatherTemperature = weatherData['main']['temp'];
  temperature = weatherTemperature.toInt();
  var condition = weatherData['weather'][0]['id'];
  weatherIcon = weatherModel.getWeatherIcon(condition);
  weatherMessage = weatherModel.getMessage(temperature);
  cityName = weatherData['name'];
  lat = weatherData['coord']['lat'];
  lon = weatherData['coord']['lon'];
});


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(style: kElevatedButtonStyle,
                      onPressed: () async{
                       var weatherData = await weatherModel.getLocationWeather();
                       updateUI(weatherData);
                      },
                      child: Icon(
                        Icons.near_me,
                        size: 50.0,

                      ),
                    ),
                    ElevatedButton(
                      style: kElevatedButtonStyle,
                      onPressed: () async{
                        var typedName = await Navigator.push(context, MaterialPageRoute(builder: (context){
                          return CityScreen();
                        }),);
                        if(typedName != null){
                          var weatherData = await weatherModel.getCityWeather(typedName);
                          updateUI(weatherData);
                        }
                      },
                      child: Icon(
                        Icons.location_city,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        '$lat,',
                        style: kTempTextStyle,
                      ),
                      Text(
                        '$lon',
                        style: kTempTextStyle,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '$temperature°',
                        style: kTempTextStyle,
                      ),
                      Text(
                        weatherIcon,
                        style: kConditionTextStyle,
                      ),
                    ],
                  ),
                ),
                 Padding(
                   padding: EdgeInsets.only(right: 15.0),
                   child: Text(
                     '$weatherMessage in $cityName',
                     textAlign: TextAlign.right,
                     style: kMessageTextStyle,
                   ),
                 ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
