class SubCategoriaModel {
  int? id;
  String? nombre;
  String? tag;
  String? foto;
  Map<String, dynamic>? categoria;
  String? estado;
  String? createdAt;
  String? updatedAt;
  // Constructor
  SubCategoriaModel({
    this.id,
    this.nombre,
    this.tag,
    this.foto,
    this.categoria,
    this.estado,
    this.createdAt,
    this.updatedAt,
  });

  factory SubCategoriaModel.fromJson(Map<String, dynamic> json) {
    return SubCategoriaModel(
      id: json['id'] as int?,
      nombre: json['nombre'] as String?,
      tag: json['tag'] as String?,
      foto: json['foto'] as String?,
      categoria: json['categoria'] as Map<String, dynamic>?,
      estado: json['estado'] as String?,
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
      'foto': foto,
      'categoria': categoria,
      'estado': estado,
    };
  }
}
