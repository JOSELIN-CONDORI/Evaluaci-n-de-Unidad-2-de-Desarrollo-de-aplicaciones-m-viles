class ProductoModel {
  int? id;
  String? nombre;
  String? descrip;
  String? precio;
  String? stock;
  String? foto;
  Map<String, dynamic>? subCategoria;
  String? estado;
  String? createdAt;
  String? updatedAt;
  // Constructor
  ProductoModel(
    {
    this.id,
    this.nombre,
    this.descrip,
    this.precio,
    this.stock,
    this.foto,
    this.subCategoria,
    this.estado,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor para crear una instancia desde un JSON
  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: json['id'] as int?,
      nombre: json['nombre'] as String?,
      descrip: json['descrip'] as String?,
      precio: json['precio'] as String?,
      stock: json['stock'] as String?,
      foto: json['foto'] as String?,
      subCategoria: json['subCategoria'] as Map<String, dynamic>?,
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
      'descrip': descrip,
      'precio': precio,
      'stock': stock,
      'foto': foto,
      'subCategoria': subCategoria, 
      'estado': estado,
    };
  }
}
