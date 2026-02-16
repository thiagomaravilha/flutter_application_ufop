import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatActivityTime(DateTime start, DateTime end) {
    final startDate = '${start.day}/${start.month}';
    final startTime = '${start.hour}:${start.minute.toString().padLeft(2, '0')}';
    final endTime = '${end.hour}:${end.minute.toString().padLeft(2, '0')}';

    // Se termina no mesmo dia
    if (start.day == end.day && start.month == end.month && start.year == end.year) {
      return '$startDate $startTime - $endTime';
    } else {
      // Se termina em outro dia, mostra data completa
      final endDate = '${end.day}/${end.month}';
      return '$startDate $startTime - $endDate $endTime';
    }
  }

  static String formatDateTimeRange(DateTime start, DateTime end) {
    final startDate = DateFormat('dd/MM/yyyy').format(start);
    final startTime = DateFormat('HH:mm').format(start);
    final endDate = DateFormat('dd/MM/yyyy').format(end);
    final endTime = DateFormat('HH:mm').format(end);

    if (startDate == endDate) {
      return 'Início: $startDate às $startTime\nFim: $startDate às $endTime';
    } else {
      return 'Início: $startDate às $startTime\nFim: $endDate às $endTime';
    }
  }
}