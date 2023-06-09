import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grúa App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LinkGeneratorScreen(),
      routes: {
        '/info': (context) => InfoScreen(),
      },
    );
  }
}

class LinkGeneratorScreen extends StatefulWidget {
  @override
  _LinkGeneratorScreenState createState() => _LinkGeneratorScreenState();
}

class _LinkGeneratorScreenState extends State<LinkGeneratorScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController carTypeController = TextEditingController();
  TextEditingController carBrandController = TextEditingController();
  TextEditingController carModelController = TextEditingController();
  TextEditingController carColorController = TextEditingController();
  TextEditingController carPlateController = TextEditingController();

  String location = '';

  void getLocation() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        location =
            'Latitud: ${position.latitude}\nLongitud: ${position.longitude}';
      });

      String link = 'Información de la grúa:\n\n' +
          'Nombre: ${nameController.text}\n' +
          'Teléfono: ${phoneController.text}\n' +
          'Tipo de carro: ${carTypeController.text}\n' +
          'Marca: ${carBrandController.text}\n' +
          'Modelo: ${carModelController.text}\n' +
          'Color: ${carColorController.text}\n' +
          'Placa: ${carPlateController.text}\n' +
          'Ubicación: $location';
      Navigator.pushNamed(context, '/info', arguments: {'link': link});
    } else if (status.isDenied) {
      // El usuario ha denegado el permiso de ubicación
      // Puedes mostrar un diálogo o mensaje para informar al usuario
      print('Permiso de ubicación denegado');
    } else if (status.isPermanentlyDenied) {
      // El usuario ha denegado permanentemente el permiso de ubicación
      // Puedes mostrar un diálogo o mensaje y guiar al usuario a la configuración de la aplicación
      print('Permiso de ubicación denegado permanentemente');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    carTypeController.dispose();
    carBrandController.dispose();
    carModelController.dispose();
    carColorController.dispose();
    carPlateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generador de Link'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Teléfono'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: carTypeController,
              decoration: InputDecoration(labelText: 'Tipo de carro'),
            ),
            TextField(
              controller: carBrandController,
              decoration: InputDecoration(labelText: 'Marca'),
            ),
            TextField(
              controller: carModelController,
              decoration: InputDecoration(labelText: 'Modelo'),
            ),
            TextField(
              controller: carColorController,
              decoration: InputDecoration(labelText: 'Color'),
            ),
            TextField(
              controller: carPlateController,
              decoration: InputDecoration(labelText: 'Placa'),
            ),
            ElevatedButton(
              onPressed: () {
                getLocation();
                String link = 'Información de la grúa:\n\n' +
                    'Nombre: ${nameController.text}\n' +
                    'Teléfono: ${phoneController.text}\n' +
                    'Tipo de carro: ${carTypeController.text}\n' +
                    'Marca: ${carBrandController.text}\n' +
                    'Modelo: ${carModelController.text}\n' +
                    'Color: ${carColorController.text}\n' +
                    'Placa: ${carPlateController.text}\n' +
                    'Ubicación: $location';
                Navigator.pushNamed(context, '/info',
                    arguments: {'link': link});
              },
              child: Text('Generar Link'),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String link = args?['link'] ?? '';

    LatLng location = LatLng(0, 0);

    Set<Marker> markers = Set<Marker>.from([
      Marker(
        markerId: MarkerId('locationMarker'),
        position: location,
      ),
    ]);

    return Scaffold(
      appBar: AppBar(
        title: Text('Información'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Datos obtenidos:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Link: $link',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: location,
                zoom: 15.0,
              ),
              markers: markers,
            ),
          ),
        ],
      ),
    );
  }
}
