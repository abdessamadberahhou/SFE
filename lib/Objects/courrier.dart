

class Courier{
  String id;
  String typeCourier;
  String objet;
  String exporter;
  String dest;
  String date;
  String tags;
  int? isFavorised;
  int? isArchived;
  int? isUrgent;
  String? idUser;
  Courier(
      this.id,
      this.typeCourier,
      this.objet,
      this.exporter,
      this.dest,
      this.date,
      this.tags,
      this.isFavorised,
      this.isArchived,
      this.isUrgent,
      this.idUser);
}