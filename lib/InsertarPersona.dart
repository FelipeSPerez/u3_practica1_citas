import 'package:flutter/material.dart';
import 'package:u3_practica1_citas/database.dart';
import 'package:u3_practica1_citas/persona.dart';

class InsertarPersona extends StatefulWidget {
  const InsertarPersona({super.key});

  @override
  State<InsertarPersona> createState() => _InsertarPersonaState();
}

class _InsertarPersonaState extends State<InsertarPersona> {
  final nombre = TextEditingController();
  final telefono = TextEditingController();
  String errorNombre = "";
  String errorTelefono = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Insertar una nueva persona"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(30),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nombre,
                    decoration: InputDecoration(
                      labelText: "Nombre",
                      prefixIcon: Icon(Icons.abc),
                    ),
                  ),
                  if (errorNombre.isNotEmpty)
                    Text(
                      errorNombre,
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  SizedBox(height: 20),
                  TextField(
                    controller: telefono,
                    decoration: InputDecoration(
                      hintText: 'Teléfono',
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                  if (errorTelefono.isNotEmpty)
                    Text(
                      errorTelefono,
                      style: TextStyle(color: Colors.redAccent),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          MaterialButton(
            onPressed: () {
              clearErrors();

              String trimmedNombre = nombre.text.trim();
              String trimmedTelefono = telefono.text.trim();

              if (trimmedNombre.isEmpty) {
                setState(() {
                  errorNombre = "El nombre no puede estar vacío";
                });
                return;
              }

              if (trimmedNombre.length < 3) {
                setState(() {
                  errorNombre = "El nombre no puede ser tan corto";
                });
                return;
              }

              RegExp regexTelefono = RegExp(
                r'^[0-9]{10}$',
              ); //Teléfono de 10 dígitos

              if (!regexTelefono.hasMatch(trimmedTelefono)) {
                setState(() {
                  errorTelefono =
                      "El teléfono debe ser un número de 10 dígitos";
                });
                return;
              }

              Persona nuevaPersona = Persona(
                nombre: trimmedNombre,
                telefono: trimmedTelefono,
              );

              DB
                  .insertPersona(nuevaPersona)
                  .then((resultado) {
                    if (resultado > 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Se insertó correctamente",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.greenAccent,
                        ),
                      );
                      setState(() {
                        nombre.clear();
                        telefono.clear();
                      });
                    }
                  })
                  .catchError((err) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Hubo un error al insertar:\n ${err.toString()}",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  });
            },
            color: Colors.blueAccent,
            textColor: Colors.white,
            child: Text("Insertar"),
          ),
        ],
      ),
    );
  }

  void clearErrors() {
    setState(() {
      errorNombre = "";
      errorTelefono = "";
    });
  }
}
