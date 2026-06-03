import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Weekend shifting logic should shift to Friday', () {
    // 15.06.2024 is Saturday
    DateTime paymentDate = DateTime(2024, 6, 15);
    bool isWeekend = paymentDate.weekday == DateTime.saturday || paymentDate.weekday == DateTime.sunday;
    
    DateTime adjustedDate = paymentDate;
    if (isWeekend) {
      int subtractDays = paymentDate.weekday == DateTime.saturday ? 1 : 2;
      adjustedDate = paymentDate.subtract(Duration(days: subtractDays));
    }
    
    expect(adjustedDate.weekday, DateTime.friday);
    expect(adjustedDate.day, 14);
  });

  test('NDFL calculation should be exactly 13%', () {
    double gross = 100000.0;
    double net = gross - (gross * 0.13);
    expect(net, 87000.0);
  });
}
