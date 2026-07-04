import 'opsi_entity.dart';

/// Satu grup opsi kustomisasi (mis. grup "Level Pedas" atau grup "Topping").
///
/// Mengikuti `backend/app/schemas/menu.py::MenuOptionGroup` persis:
/// - [multiple] cuma `true` untuk grup topping — artinya checkbox, boleh
///   pilih lebih dari satu opsi sekaligus dalam grup yang sama. Grup lain
///   (level pedas, ukuran, dll) single-select alias radio.
/// - [required] menandakan grup ini wajib punya minimal 1 opsi terpilih
///   sebelum item boleh ditambahkan ke keranjang.
class OpsiGroupEntity {
  final String grupOpsi;
  final String tipeOpsi;
  final bool required;
  final bool multiple;
  final List<OpsiEntity> options;

  const OpsiGroupEntity({
    required this.grupOpsi,
    required this.tipeOpsi,
    required this.required,
    required this.multiple,
    required this.options,
  });

  factory OpsiGroupEntity.fromJson(Map<String, dynamic> json) {
    return OpsiGroupEntity(
      grupOpsi: json['grup_opsi'] as String,
      tipeOpsi: json['tipe_opsi'] as String,
      required: json['required'] as bool,
      multiple: json['multiple'] as bool,
      options: (json['options'] as List<dynamic>)
          .map((item) => OpsiEntity.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}