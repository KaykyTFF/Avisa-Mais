import 'package:flutter/foundation.dart';

/// Base para ViewModels que protege contra chamadas a `notifyListeners()`
/// após o descarte (`dispose()`).
abstract class SafeChangeNotifier extends ChangeNotifier {
  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  @protected
  void safeNotifyListeners() {
    if (_isDisposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
