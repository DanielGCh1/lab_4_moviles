import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:uni_links/uni_links.dart' as uni_links;
import 'package:share/share.dart';

String? _generatedLink;

class SolicitudGruaPage extends StatefulWidget {
  const SolicitudGruaPage({Key? key}) : super(key: key);

  @override
  _SolicitudGruaPageState createState() => _SolicitudGruaPageState();
}

class _SolicitudGruaPageState extends State<SolicitudGruaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _tipoCarroController = TextEditingController();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _colorController = TextEditingController();
  final _placaController = TextEditingController();
  String _ubicacionActual = '';
  Uri? _currentUri = null;
  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _tipoCarroController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _colorController.dispose();
    _placaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initUniLinks();
  }

  void _initUniLinks() async {
    if (!kIsWeb) {
      try {
        final initialUri = await uni_links.getInitialUri();
        _handleIncomingLink(initialUri);
      } on PlatformException {}

      uni_links.uriLinkStream.listen((Uri? uri) {
        _handleIncomingLink(uri);
      }, onError: (Object error) {});
    }
  }

  void _handleIncomingLink(Uri? uri) {
    // Lógica para manejar el enlace entrante, si es necesario
    if (uri != null) {
      setState(() {
        _currentUri = uri;
      });
      // Realiza las acciones necesarias con el enlace recibido
      // por ejemplo, extraer los parámetros de la query
      // y realizar alguna acción basada en ellos
      final queryParams = uri.queryParameters;
      final nombre = queryParams['nombre'];
      final telefono = queryParams['telefono'];
      final tipoCarro = queryParams['tipoCarro'];
      final marca = queryParams['marca'];
      final modelo = queryParams['modelo'];
      final color = queryParams['color'];
      final placa = queryParams['placa'];
      final ubicacion = queryParams['ubicacion'];

      // Realiza la lógica necesaria con los datos recibidos
      // por ejemplo, mostrar una notificación, llenar los campos
      // del formulario, etc.
      print('Enlace entrante:');
      print('Nombre: $nombre');
      print('Teléfono: $telefono');
      print('Tipo de carro: $tipoCarro');
      print('Marca: $marca');
      print('Modelo: $modelo');
      print('Color: $color');
      print('Placa: $placa');
      print('Ubicación: $ubicacion');
    }
  }

  Future<void> _obtenerUbicacionActual() async {
    final location = Location();
    bool serviceEnabled;
    PermissionStatus permissionStatus;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        SystemNavigator.pop();
        _showLocationServiceDisabledDialog();
        // El usuario denegó los permisos de ubicación, maneja este caso según tus necesidades
        return;
      }
    }

    final currentLocation = await location.getLocation();
    setState(() {
      _ubicacionActual =
          'Latitud: ${currentLocation.latitude}, Longitud: ${currentLocation.longitude}';
    });
  }

  void _showLocationServiceDisabledDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Servicio de ubicación desactivado'),
          content: const Text(
            'Para utilizar esta función, debes activar el servicio de ubicación en tu dispositivo.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Configuración'),
              onPressed: () {
                Navigator.of(context).pop();
                // Abrir la configuración de la aplicación
                Location().requestService();
              },
            ),
          ],
        );
      },
    );
  }

  void _shareLink(String link) {
    Share.share(link);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Generar el enlace con los datos del formulario
      final link = Uri(
        scheme: 'https',
        host: 'gruapp.help',
        queryParameters: {
          'nombre': _nombreController.text,
          'telefono': _telefonoController.text,
          'tipoCarro': _tipoCarroController.text,
          'marca': _marcaController.text,
          'modelo': _modeloController.text,
          'color': _colorController.text,
          'placa': _placaController.text,
          'ubicacion': _ubicacionActual,
        },
      );
      // Reiniciar los campos del formulario
      _nombreController.clear();
      _telefonoController.clear();
      _tipoCarroController.clear();
      _marcaController.clear();
      _modeloController.clear();
      _colorController.clear();
      _placaController.clear();
      setState(() {
        _ubicacionActual = '';
      });

      // Comparte el link
      _shareLink(link.toString());
      // Actualizar la variable _generatedLink
      setState(() {
        _generatedLink = link.toString();
      });
    }
  }

  Widget buildForm(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitud de Grúa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa tu nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefonoController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa tu número de teléfono';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tipoCarroController,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Carro',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa el tipo de carro';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _marcaController,
                decoration: const InputDecoration(
                  labelText: 'Marca',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa la marca del carro';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _modeloController,
                decoration: const InputDecoration(
                  labelText: 'Modelo',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa el modelo del carro';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(
                  labelText: 'Color',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa el color del carro';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _placaController,
                decoration: const InputDecoration(
                  labelText: 'Placa',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa la placa del carro';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _obtenerUbicacionActual,
                child: const Text('Obtener Ubicación Actual'),
              ),
              const SizedBox(height: 8),
              Text(
                'Ubicación Actual: $_ubicacionActual',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Enviar Solicitud de Grúa'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLink(BuildContext context) {
    final queryParams = _currentUri!.queryParameters.entries.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos de Link Grua'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: queryParams.length,
          itemBuilder: (BuildContext context, int index) {
            final parameter = queryParams[index];
            return ListTile(
              title: Text(parameter.key),
              subtitle: Text(parameter.value),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUri != null) {
      return buildLink(context);
    } else {
      return buildForm(context);
    }
  }
}
