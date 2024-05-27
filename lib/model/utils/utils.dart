import 'dart:math';

class ConnectionSimulator<T> {
  static const int delay = int.fromEnvironment("MOCK_CONNECTION_DELAY");
  static const int errorRate = int.fromEnvironment("MOCK_CONNECTION_ERROR_RATE");

  Future<T> connect(Function() func) {
    return Future<T>.delayed(
        const Duration(milliseconds: delay),
            () {
          if (Random().nextInt(100) < errorRate) {
            throw Exception("Ошибка соединения");
          }
          return func();
        }
    );
  }
}