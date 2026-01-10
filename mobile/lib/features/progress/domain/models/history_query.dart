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
}

