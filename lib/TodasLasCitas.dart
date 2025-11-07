import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:u3_practica1_citas/EditarCita.dart';
import 'package:u3_practica1_citas/cita.dart';
import 'package:u3_practica1_citas/database.dart';

class TodasLasCitas extends StatefulWidget {
  const TodasLasCitas({super.key});

  @override
  State<TodasLasCitas> createState() => _TodasLasCitasState();
}

class _TodasLasCitasState extends State<TodasLasCitas> {
  List<Cita> citas = [];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    actualizarLista();

    if (isLoading) {
      return Center(child: CircularProgressIndicator(color: Colors.orange));
    }

    if (citas.isEmpty) {
      return Center(
        child: Text("No hay citas registradas", style: TextStyle(fontSize: 20)),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: citas.length,
      itemBuilder: (context, indice) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              title: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 5,
                    children: [
                      Icon(Icons.location_on),
                      Text(citas[indice].lugar),
                    ],
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Icon(Icons.alarm),
                      Flexible(
                        child: Text(
                          DateFormat(
                            "EEEE dd 'de' MMMM 'de' yyyy 'a las' HH:mm",
                            'es_MX',
                          ).format(citas[indice].fecha_hora),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 5,
                    children: [Icon(Icons.person), Text(citas[indice].persona)],
                  ),
                  SizedBox(height: 5),
                ],
              ),
              subtitle: Text("Notas: ${citas[indice].anotaciones}"),
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 30),
                onSelected: (value) {
                  if (value == 'editar') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (b) => EditarCita(cita: citas[indice]),
                      ),
                    );
                  } else if (value == 'eliminar') {
                    showDialog(
                      context: context,
                      builder: (val) {
                        return AlertDialog(
                          title: Text(
                            "Atención",
                            style: TextStyle(color: Colors.red),
                          ),
                          content: Text(
                            "¿Estás seguro que deseas borrar la cita?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Cancelar",
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            ),
                            FilledButton(
                              onPressed: () {
                                //
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.cyan,
                              ),
                              child: Text("Aceptar"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'editar',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'eliminar',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Eliminar'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void actualizarLista() {
    DB
        .getAllCitas()
        .then((respuesta) {
          setState(() {
            citas = respuesta;
          });
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Hubo un error consultando los registros:\n${error.toString()}",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        })
        .whenComplete(() {
          setState(() {
            isLoading = false;
          });
        });
  }
}
