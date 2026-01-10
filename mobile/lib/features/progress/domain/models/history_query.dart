import 'history_item.dart';

class HistoryQuery {
  final int page;
  final DateTime? startDate;
  final DateTime? endDate;
  final HistoryItemType? type;

  HistoryQuery({
    required this.page,
    this.startDate,
    this.endDate,
    this.type,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryQuery &&
          runtimeType == other.runtimeType &&
          page == other.page &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          type == other.type;

  @override
  int get hashCode =>
      page.hashCode ^ startDate.hashCode ^ endDate.hashCode ^ type.hashCode;
}

