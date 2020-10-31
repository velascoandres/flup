class ProductoModel {
    ProductoModel({
        this.id,
        this.titulo = '',
        this.precio = 0.0,
        this.disponible = true,
        this.fotoUrl,
    });

    String id;
    String titulo;
    double precio;
    bool disponible;
    String fotoUrl;

    factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        id: json["id"],
        titulo: json["titulo"],
        precio: json["precio"].toDouble(),
        disponible: json["disponible"],
        fotoUrl: json["fotoUrl"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "titulo": titulo,
        "precio": precio,
        "disponible": disponible,
        "fotoUrl": fotoUrl,
    };
}
