class Reports {
  final int id;
  final int idLaluan;
  final String namaLaluan;
  final int idKenderaan;
  final String noKenderaan;
  final int idTaman;
  final String namaTaman;
  final int idJalan;
  final String namaJalan;
  final int idJenisHalangan;
  final String jenisHalangan;
  final int idStatus;
  final String status;
  final String lampiran;
  final String catatan;
  final int idStatusPenyelia;
  final String statusPenyelia;
  final String maklumbalasPenyelia;
  final int idStatusBA;
  final String statusBA;
  final String maklumbalasBA;

  const Reports(
      {required this.id,
      required this.idLaluan,
      required this.namaLaluan,
      required this.idKenderaan,
      required this.noKenderaan,
      required this.idTaman,
      required this.namaTaman,
      required this.idJalan,
      required this.namaJalan,
      required this.idJenisHalangan,
      required this.jenisHalangan,
      required this.idStatus,
      required this.status,
      required this.lampiran,
      required this.catatan,
      required this.idStatusPenyelia,
      required this.statusPenyelia,
      required this.maklumbalasPenyelia,
      required this.idStatusBA,
      required this.statusBA,
      required this.maklumbalasBA});

  static Reports fromJson(json) => Reports(
      id: json['id'] ?? 0,
      idLaluan: json['idLaluan'] ?? 0,
      namaLaluan: json['namaLaluan'] ?? "",
      idKenderaan: json['idKenderaan'] ?? 0,
      noKenderaan: json['noKenderaan'] ?? "",
      idTaman: json['idTaman'] ?? 0,
      namaTaman: json['namaTaman'] ?? "",
      idJalan: json['idJalan'] ?? 0,
      namaJalan: json['namaJalan'] ?? "",
      idJenisHalangan: json['idJenisHalangan'] ?? 0,
      jenisHalangan: json['jenisHalangan'] ?? "",
      idStatus: json['idStatus'] ?? 0,
      status: json['status'] ?? "",
      lampiran: json['lampiran'] ?? "",
      catatan: json['catatan'] ?? "",
      idStatusPenyelia: json['idStatusPenyelia'] ?? 0,
      statusPenyelia: json['statusPenyelia'] ?? "",
      maklumbalasPenyelia: json['maklumbalasPenyelia'] ?? "",
      idStatusBA: json['idStatusBA'] ?? 0,
      statusBA: json['statusBA'] ?? "",
      maklumbalasBA: json['maklumbalasBA'] ?? "");
}
