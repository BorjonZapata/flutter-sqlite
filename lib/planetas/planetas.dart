//Plain Old Java Object
//Plain Old dart Object

class Planetas{
  int? id;
  String? nombre;
  double? distanciaSol;
  double? radio;
//alt+insert ocntructor
  Planetas(this.id, this.nombre, this.distanciaSol, this.radio);

  //
  Planetas.deMapa(Map<String, dynamic> mapa){
   id =  mapa["id"] ;
   nombre = mapa["nombre"];
   distanciaSol = mapa["distanciaSol"];
   radio = mapa["radio"];
    //{id:1,nombre:Venusjuro}
  }

  Map<String, dynamic> mapeador(){
    return{
      "id":id,
      "nombre":nombre,
      "distanciaSol":distanciaSol,
      "radio":radio
    };
  }
}