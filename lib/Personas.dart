import 'package:flutter/material.dart';
import 'package:u3_practica1_citas/EditarPersona.dart';
import 'package:u3_practica1_citas/database.dart';
import 'package:u3_practica1_citas/persona.dart';

class Personas extends StatefulWidget {
  const Personas({super.key});

  @override
  State<Personas> createState() => _PersonasState();
}

class _PersonasState extends State<Personas> {
  List<Persona> personas = [];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    actualizarLista();

    if (isLoading) {
      return Center(child: CircularProgressIndicator(color: Colors.orange));
    }

    if (personas.isEmpty) {
      return Center(
        child: Text(
          "No hay personas registradas",
          style: TextStyle(fontSize: 20),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: personas.length,
      itemBuilder: (context, indice) {
        return Card(
          child: ListTile(
            title: Text(personas[indice].nombre),
            subtitle: Text(personas[indice].telefono),
            leading: Icon(Icons.face),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 30),
              onSelected: (value) {
                if (value == 'editar') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (b) => EditarPersona(persona: personas[indice]),
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
                          "¿Estás seguro que deseas borrar la persona?",
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
                              DB
                                  .deletePersona(personas[indice])
                                  .then((resultado) {
                                    if (resultado > 0) {
                                      Navigator.pop(context);

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Se eliminó correctamente",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.greenAccent,
                                        ),
                                      );
                                      actualizarLista();
                                    }
                                  })
                                  .catchError((err) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Hubo un error al eliminar:\n ${err.toString()}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  });
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
        );
      },
    );
  }

  void actualizarLista() {
    DB
        .getAllPersonas()
        .then((respuesta) {
          setState(() {
            personas = respuesta;
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
