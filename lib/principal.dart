import 'package:flutter/material.dart';
import 'package:u3_practica1_citas/Hoy.dart';
import 'package:u3_practica1_citas/InsertarCita.dart';
import 'package:u3_practica1_citas/InsertarPersona.dart';
import 'package:u3_practica1_citas/Personas.dart';
import 'package:u3_practica1_citas/TodasLasCitas.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  int paginaActual = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Practica 1 Agenda"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: contenido(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaActual,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Hoy"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Citas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Personas",
          ),
        ],
        onTap: (x) {
          setState(() {
            paginaActual = x;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blueAccent,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          paginaActual == 0 || paginaActual == 1
              ? Navigator.push(
                  context,
                  MaterialPageRoute(builder: (b) => InsertarCita()),
                )
              : Navigator.push(
                  context,
                  MaterialPageRoute(builder: (b) => InsertarPersona()),
                );
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.orange,
        tooltip: paginaActual == 0 || paginaActual == 1
            ? "Añadir una nueva cita"
            : "Añadir una nueva persona",
        child: paginaActual == 0 || paginaActual == 1
            ? Icon(Icons.note_add)
            : Icon(Icons.person_add),
      ),
    );
  }

  Widget contenido() {
    switch (paginaActual) {
      case 0:
        return Hoy();
      case 1:
        return TodasLasCitas();
      default:
        return Personas();
    }
  }
}
