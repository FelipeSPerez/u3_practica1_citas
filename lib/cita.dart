class Cita {
  int? idcita;
  String lugar;
  DateTime fecha_hora;
  String anotaciones;
  int idpersona;
  String persona;
  String telefono;

  Cita({
    this.idcita,
    required this.lugar,
    required this.fecha_hora,
    required this.anotaciones,
    required this.idpersona,
    this.persona = "",
    this.telefono = ""
  });

  Map<String, dynamic> toJSON() {
    return {
      "idcita" : idcita,
      "lugar" : lugar,
      "fecha_hora" : fecha_hora.toIso8601String(),
      "anotaciones" : anotaciones,
      "idpersona" : idpersona,
    };
  }
}