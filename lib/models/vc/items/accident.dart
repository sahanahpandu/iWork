class Accident {
  Accident({
    required this.terlibatKemalangan,
    required this.noKenderaanPartiKetiga,
    required this.remarks,
  });

  int terlibatKemalangan;
  int noKenderaanPartiKetiga;
  String remarks;

  static Accident fromJson(json) => Accident(
        terlibatKemalangan: json["terlibatKemalangan"],
        noKenderaanPartiKetiga: json["noKenderaanPartiKetiga"],
        remarks: json["remarks"],
      );

  Map<String, dynamic> toJson() => {
        "terlibatKemalangan": terlibatKemalangan,
        "noKenderaanPartiKetiga": noKenderaanPartiKetiga,
        "remarks": remarks,
      };
}
