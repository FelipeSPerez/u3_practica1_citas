import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:u3_practica1_citas/cita.dart';
import 'package:u3_practica1_citas/database.dart';
import 'package:u3_practica1_citas/persona.dart';

class InsertarCita extends StatefulWidget {
  const InsertarCita({super.key});

  @override
  State<InsertarCita> createState() => _InsertarCitaState();
}

class _InsertarCitaState extends State<InsertarCita> {
  final lugar = TextEditingController();
  final fecha_hora = TextEditingController();
  final anotaciones = TextEditingController();
  int? idpersona;
  TimeOfDay? hora;
  DateTime? fecha;
  List<Persona> personas = [];

  String errorLugar = "";
  String errorHora = "";
  String errorFecha = "";
  String errorPersona = "";

  @override
  void initState() {
    super.initState();
    actualizarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Insertar una nueva cita"),
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
                    controller: lugar,
                    decoration: InputDecoration(
                      labelText: "Lugar",
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  if (errorLugar.isNotEmpty)
                    Text(errorLugar, style: TextStyle(color: Colors.redAccent)),
                  SizedBox(height: 20),
                  Row(
                    spacing: 10,
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          DateTime initialDate = DateTime.now();

                          TimeOfDay? selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(initialDate),
                          );

                          if (selectedTime != null) {
                            setState(() {
                              hora = selectedTime;
                            });
                          }
                        },
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        child: Text("Hora"),
                      ),
                      Flexible(
                        child: Text(
                          "Hora: ${hora != null ? '${hora!.hour.toString().padLeft(2, '0')}:${hora!.minute.toString().padLeft(2, '0')}' : "No se ha seleccionado"}",
                        ),
                      ),
                    ],
                  ),
                  if (errorHora.isNotEmpty)
                    Text(errorHora, style: TextStyle(color: Colors.redAccent)),
                  SizedBox(height: 20),
                  Row(
                    spacing: 10,
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          DateTime initialDate = DateTime.now();
                          DateTime firstDate = initialDate.subtract(
                            const Duration(days: 365 * 100),
                          );
                          DateTime lastDate = firstDate.add(
                            const Duration(days: 365 * 200),
                          );

                          final DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate: firstDate,
                            lastDate: lastDate,
                          );

                          if (selectedDate != null) {
                            setState(() {
                              fecha = selectedDate;
                            });
                          }
                        },
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        child: Text("Fecha"),
                      ),
                      Flexible(
                        child: Text(
                          "Fecha: ${fecha != null ? DateFormat("EEEE dd 'de' MMMM 'de' yyyy", 'es_MX').format(fecha!) : "No se ha seleccionado"}",
                        ),
                      ),
                    ],
                  ),
                  if (errorFecha.isNotEmpty)
                    Text(errorFecha, style: TextStyle(color: Colors.redAccent)),
                  SizedBox(height: 20),
                  TextField(
                    controller: anotaciones,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Anotaciones',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.note),
                    ),
                  ),
                  SizedBox(height: 20),
                  personas.isEmpty
                      ? TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: "No hay personas registradas",
                          ),
                        )
                      : DropdownButtonFormField(
                          hint: Text("Seleccione una persona"),
                          items: personas.map((p) {
                            return DropdownMenuItem(
                              value: p.idpersona,
                              child: Text(p.nombre),
                            );
                          }).toList(),
                          initialValue: idpersona,
                          onChanged: (val) {
                            idpersona = val;
                          },
                        ),
                  if (errorPersona.isNotEmpty)
                    Text(
                      errorPersona,
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

              String trimmedLugar = lugar.text.trim();
              String trimmedAnotaciones = anotaciones.text.trim();

              if (trimmedLugar.isEmpty) {
                setState(() {
                  errorLugar = "El lugar no puede estar vacío";
                });
                return;
              }

              if (hora == null) {
                setState(() {
                  errorHora = "La hora no puede estar vacía";
                });
                return;
              }

              if (fecha == null) {
                setState(() {
                  errorFecha = "La fecha no puede estar vacía";
                });
                return;
              }

              if (idpersona == null) {
                if (personas.isEmpty) {
                  setState(() {
                    errorPersona = "Primero registre una persona";
                  });
                } else {
                  setState(() {
                    errorPersona = "Es necesario seleccionar una persona";
                  });
                }
              }

              Cita nuevaCita = Cita(
                lugar: trimmedLugar,
                fecha_hora: DateTime(
                  fecha!.year,
                  fecha!.month,
                  fecha!.day,
                  hora!.hour,
                  hora!.minute,
                ),
                anotaciones: trimmedAnotaciones,
                idpersona: idpersona!,
              );

              DB
                  .insertCita(nuevaCita)
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
                        lugar.clear();
                        hora = null;
                        fecha = null;
                        anotaciones.clear();
                        idpersona = null;
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

  void actualizarLista() {
    DB.getAllPersonas().then((resultado) {
      setState(() {
        personas = resultado;
      });
    });
  }

  void clearErrors() {
    setState(() {
      errorLugar = "";
      errorFecha = "";
      errorHora = "";
      errorPersona = "";
    });
  }
}
