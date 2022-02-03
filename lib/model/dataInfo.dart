class dataInfo {

  int id;
  String image;
  String Label_Name;
  String email;
  double Latitude;
  double Longitude;
  String dateTime;

  dataInfo({
    this.id,
    this.image,
    this.Label_Name,
    this.email,
    this.Latitude,
    this.Longitude,
    this.dateTime,
  });

  factory dataInfo.fromMap(Map<String, dynamic> json) =>
      dataInfo(
        id: json["id"],
        image: json["image"],
        Label_Name: json["Label_Name"],
        email: json["email"],
        Latitude: json["Latitude"],
        Longitude: json["Longitude"],
        dateTime: json['dateTime'],
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "image": image,
    "Label_Name": Label_Name,
    "email": email,
    "Latitude": Latitude,
    "Longitude": Longitude,
    "dateTime" : dateTime,
  };
}
