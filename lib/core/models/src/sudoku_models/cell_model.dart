class CellModel {
  final int row;      // 0-8
  final int col;      // 0-8
  final int box;      // 0-8 (જાણવા માટે કે કયા box માં છે)
  final int? value;   // null = ખાલી સેલ
  final bool isFixed; // true = puzzle માં predefined value

  CellModel({
    required this.row,
    required this.col,
    required this.box,
    this.value,
    this.isFixed = false,
  });

  CellModel copyWith({int? value, bool? isFixed}) {
    return CellModel(
      row: row,
      col: col,
      box: box,
      value: value ?? this.value,
      isFixed: isFixed ?? this.isFixed,
    );
  }
}
int getBoxIndex(int row, int col) {
  return (row ~/ 3) * 3 + (col ~/ 3);
}

