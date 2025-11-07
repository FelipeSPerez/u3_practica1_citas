import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:u3_practica1_citas/cita.dart';
import 'package:u3_practica1_citas/persona.dart';

class DB {
  static Future<Database> conectar() async {
    return openDatabase(
      join(await getDatabasesPath(), "practica1.db"),
      version: 1,
      onConfigure: (db) {
        return db.execute("PRAGMA foreign_keys = ON");
      },
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE persona"
          "("
          "   idpersona INTEGER PRIMARY KEY AUTOINCREMENT,"
          "   nombre TEXT,"
          "   telefono TEXT"
          ")",
        );
        await db.execute(
          "CREATE TABLE cita"
          "("
          "   idcita INTEGER PRIMARY KEY AUTOINCREMENT,"
          "   lugar TEXT,"
          "   fecha_hora TEXT," //Se me hizo más fácil guardarlo en la misma columna
          "   anotaciones TEXT,"
          "   idpersona INTEGER,"
          "   FOREIGN KEY (idpersona) REFERENCES persona(idpersona) ON DELETE CASCADE ON UPDATE CASCADE"
          ")",
        );
      },
    );
  }

  static Future<List<Cita>> getCitasDeHoy() async {
    Database db = await conectar();

    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = DateTime(today.year, today.month, today.day, 23, 59, 59);

    List<Map<String, dynamic>> citas = await db.rawQuery(
      '''
      SELECT
        C.idcita,
        C.lugar,
        C.fecha_hora,
        C.anotaciones,
        p.idpersona,
        p.nombre AS persona,
        p.telefono
      FROM cita AS C
      LEFT JOIN persona AS P ON P.idpersona = C.idpersona
      WHERE C.fecha_hora BETWEEN ? AND ?
      ORDER BY C.fecha_hora DESC
      ''',
      [todayStart.toIso8601String(), todayEnd.toIso8601String()],
    );

    return List.generate(citas.length, (contador) {
      return Cita(
        idcita: citas[contador]["idcita"],
        lugar: citas[contador]["lugar"],
        fecha_hora: DateTime.parse(citas[contador]["fecha_hora"]),
        anotaciones: citas[contador]["anotaciones"],
        idpersona: citas[contador]["idpersona"],
        persona: citas[contador]["persona"],
      );
    });
  }

  static Future<List<Cita>> getAllCitas() async {
    Database db = await conectar();

    List<Map<String, dynamic>> citas = await db.rawQuery('''
        SELECT 
          c.idcita,
          c.lugar,
          c.fecha_hora,
          c.anotaciones,
          p.idpersona,
          p.nombre AS persona,
          p.telefono
        FROM cita AS c
        LEFT JOIN persona AS p ON p.idpersona = c.idpersona
        ''', []);

    return List.generate(citas.length, (contador) {
      return Cita(
        idcita: citas[contador]["idcita"],
        lugar: citas[contador]["lugar"],
        fecha_hora: DateTime.parse(citas[contador]["fecha_hora"]),
        anotaciones: citas[contador]["anotaciones"],
        idpersona: citas[contador]["idpersona"],
        persona: citas[contador]["persona"],
        telefono: citas[contador]["telefono"],
      );
    });
  }

  static Future<List<Persona>> getAllPersonas() async {
    Database db = await conectar();

    List<Map<String, dynamic>> personas = await db.query(
      "persona",
      orderBy: "nombre DESC",
    );

    return List.generate(personas.length, (indice) {
      return Persona(
        idpersona: personas[indice]["idpersona"],
        nombre: personas[indice]["nombre"],
        telefono: personas[indice]["telefono"],
      );
    });
  }

  static Future<int> insertPersona(Persona p) async {
    Database db = await conectar();

    return db.insert(
      "persona",
      p.toJSON(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  static Future<int> insertCita(Cita c) async {
    Database db = await conectar();

    return db.insert(
      "cita",
      c.toJSON(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  static Future<int> updatePersona(Persona p) async {
    Database db = await conectar();

    return db.update(
      "persona",
      p.toJSON(),
      where: "idpersona = ?",
      whereArgs: [p.idpersona],
    );
  }

  static Future<int> updateCita(Cita c) async {
    Database db = await conectar();

    return db.update(
      "cita",
      c.toJSON(),
      where: "idcita = ?",
      whereArgs: [c.idcita],
    );
  }

  static Future<int> deletePersona(Persona p) async {
    Database db = await conectar();

    return db.delete(
      "persona",
      where: "idpersona = ?",
      whereArgs: [p.idpersona],
    );
  }

  static Future<int> deleteCita(Cita c) async {
    Database db = await conectar();

    return db.delete("cita", where: "idcita = ?", whereArgs: [c.idcita]);
  }
}
