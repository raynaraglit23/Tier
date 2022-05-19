import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tier/models/pet_model.dart';

class ModelUsers {
  String idUser;
  final String? descricaoUsuario;
  final String? fotoUsuario;
  final String? nomeUsuario;
  final List enderecoUsuario;//mudar de string p matriz
  final int pontos;

  ModelUsers({
    this.idUser = '',
    required this.descricaoUsuario,
    required this.fotoUsuario,
    required this.nomeUsuario,
    required this.enderecoUsuario,
    required this.pontos,
  });

  Map<String, dynamic> toJson() => {
    'idUsuario' : idUser,
    'descricaoUsuario' : descricaoUsuario,
    'fotoUsuario': fotoUsuario,
    'nomeUsuario' : nomeUsuario,
    'enderecoUsuario' : enderecoUsuario,
    'pontos': pontos,
  };

  static ModelUsers fromJson(Map<String, dynamic> json) => ModelUsers(
      idUser: json['idUsuario'],
      descricaoUsuario: json['descricaoUsuario'],
      fotoUsuario: json['fotoUsuario'],
      nomeUsuario: json['nomeUsuario'],
      enderecoUsuario: json['enderecoUsuario'],
      pontos: json['pontos'],
  );
}
class ModelFavoritosLojas {
  final String idFav;
  final String idLoja;

  ModelFavoritosLojas({this.idFav = '', required this.idLoja});

  Map<String, dynamic> toJason() => {
    'idFav': idFav,
    'idLoja': idLoja,
  };
  static ModelFavoritosLojas fromJson(Map<String, dynamic> json) => ModelFavoritosLojas(
    idFav: json['idDono'],
    idLoja: json['idLoja'],
  );
}

class ModelFavoritosAnimais {
  final String idFav;
  final String idDono;
  final String idPet;

  ModelFavoritosAnimais({this.idFav = '', required this.idDono, required this.idPet,});

  Map<String, dynamic> toJason() => {
    'idFav': idFav,
    'idDono': idDono,
    'idPet': idPet,
  };
  static ModelFavoritosAnimais fromJson(Map<String, dynamic> json) => ModelFavoritosAnimais(
      idDono: json['idDono'],
      idPet: json['idPet'],
      idFav: json['idFav'],
  );
}

//ler usuario
Future<ModelUsers?> readUser(String idUser) async{
  final docUser = FirebaseFirestore.instance.collection('usuarios').doc(idUser);
  final snapshot = await docUser.get();
  if (snapshot.exists){
    return ModelUsers.fromJson(snapshot.data()!);
  }
}
//ler lista de favoritos lojas
Stream<List<ModelFavoritosLojas>> readFavoritosLojas(String id) => FirebaseFirestore.instance
    .collection('usuarios').doc(id).collection('favoritosLojas')
    .snapshots()
    .map((snapshot) =>
    snapshot.docs.map((doc) => ModelFavoritosLojas.fromJson(doc.data())).toList());

//ler lista de favoritos Animais
Stream<List<ModelFavoritosAnimais>> readFavoritosAnimais(String id) => FirebaseFirestore.instance
    .collection('usuarios').doc(id).collection('favoritosPets')
    .snapshots()
    .map((snapshot) =>
    snapshot.docs.map((doc) => ModelFavoritosAnimais.fromJson(doc.data())).toList());
//ler pet especifico
Future<ModelPet?> readPet(String idDono, String idPet) async{
  final docUser = FirebaseFirestore.instance.collection('usuarios').doc(idDono).collection('pets').doc(idPet);
  final snapshot = await docUser.get();
  if (snapshot.exists){
    return ModelPet.fromJson(snapshot.data()!);
  }
}
//Criar favorito
Future favoritarAnimal({
  required String idFav,
  required String idDono,
  required String idPet,
  required String idUsuario,//usuario atual
}) async {
  final docUser = FirebaseFirestore.instance.collection('usuarios').doc(idUsuario).collection('favoritosPets').doc();
  final fav = ModelFavoritosAnimais(
    idFav: docUser.id,
    idDono: idDono,
    idPet: idPet,
  );
  final json = fav.toJason();
  await docUser.set(json);
}