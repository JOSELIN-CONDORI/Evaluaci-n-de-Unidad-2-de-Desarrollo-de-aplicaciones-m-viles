class CategoriaModel {
  int? id;
  String? nombre;
  String? tag;
  String? estado;
  String? foto;
  String? createdAt;
  String? updatedAt;
  // Constructor
  CategoriaModel(
    {
    this.id,
    this.nombre,
    this.tag,
    this.estado,
    this.foto,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor para crear una instancia desde un JSON
  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
      id: json['id'] as int?,
      nombre: json['nombre'] as String?,
      tag: json['tag'] as String?,
      estado: json['estado'] as String?,
      foto: json['foto'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  // Convertir la instancia a un JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'tag': tag,
      'estado': estado,
      'foto': foto,
    };
  }
}
