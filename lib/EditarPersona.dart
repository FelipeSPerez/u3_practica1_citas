import 'package:flutter/material.dart';
import 'package:u3_practica1_citas/database.dart';
import 'package:u3_practica1_citas/persona.dart';

class EditarPersona extends StatefulWidget {
  final Persona persona;

  const EditarPersona({super.key, required this.persona});

  @override
  State<EditarPersona> createState() => _EditarPersonaState();
}

class _EditarPersonaState extends State<EditarPersona> {
  final nombre = TextEditingController();
  final telefono = TextEditingController();
  String errorNombre = "";
  String errorTelefono = "";

  @override
  void initState() {
    super.initState();
    nombre.text = widget.persona.nombre;
    telefono.text = widget.persona.telefono;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar persona"),
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
                idpersona: this.widget.persona.idpersona,
                nombre: trimmedNombre,
                telefono: trimmedTelefono,
              );

              DB
                  .updatePersona(nuevaPersona)
                  .then((resultado) {
                    if (resultado > 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Se actualizó correctamente",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.greenAccent,
                        ),
                      );
                    }
                  })
                  .catchError((err) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Hubo un error al actualizar:\n ${err.toString()}",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  });
            },
            color: Colors.blueAccent,
            textColor: Colors.white,
            child: Text("Actualizar"),
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
