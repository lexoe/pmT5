import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Tugas 5'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   var _latitude = "";
   var _longitude = "";
   var _altitude = "";
   var _speed = "";
   var _address = "";

   Future<void> _updatePosition() async {
     Position pos = await _determinePosition();
     List pm = await placemarkFromCoordinates(pos.latitude, pos.longitude);
     setState(() {
       _latitude = pos.latitude.toString();
       _longitude = pos.longitude.toString();
       _altitude = pos.altitude.toString();
       _speed = pos.speed.toString();
       _address = pm[0].toString();
     });
   }

   Future<Position> _determinePosition() async{
     bool serviceEnable;
     LocationPermission permission;
     serviceEnable = await Geolocator.isLocationServiceEnabled();
     if (!serviceEnable) {
       return Future.error('Location Services are disable');
     }
     permission = await Geolocator.checkPermission();
     if (permission == LocationPermission.denied) {
       permission = await Geolocator.requestPermission();
       if (permission == LocationPermission.denied) {
         return Future.error('Location Permission are denied');
       }
     }
     if (permission == LocationPermission.deniedForever) {
       return Future.error('Location Permission are permanently denied, we cannot request permission');
     }
     return await Geolocator.getCurrentPosition();
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You last know location is:',
            ),
            Text(
              "Latitude " + _latitude,
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              "Longtitude " + _longitude,
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              "Altitude " + _altitude,
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              "Speed " + _speed,
              style: Theme.of(context).textTheme.headline4,
            ),
            const Text('Address: '),
            Text(_address),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updatePosition,
        tooltip: 'Get GPS position',
        child: const Icon(Icons.change_circle_outlined),
      ),
    );
  }
}
