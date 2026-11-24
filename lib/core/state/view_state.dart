import '../errors/app_exception.dart';

/// Estados padronizados para operações assíncronas nos ViewModels.
enum ViewStatus { initial, loading, success, error }

/// Snapshot imutável de estado exposto pelos ViewModels para as Views.
class ViewState<T> {
  final ViewStatus status;
  final T? data;
  final AppException? error;

  const ViewState._({
    required this.status,
    this.data,
    this.error,
  });

  const ViewState.initial({T? data})
      : this._(status: ViewStatus.initial, data: data);

  const ViewState.loading({T? data})
      : this._(status: ViewStatus.loading, data: data);

  const ViewState.success(T data)
      : this._(status: ViewStatus.success, data: data);

  const ViewState.error(AppException error, {T? data})
      : this._(status: ViewStatus.error, data: data, error: error);

  bool get isInitial => status == ViewStatus.initial;
  bool get isLoading => status == ViewStatus.loading;
  bool get isSuccess => status == ViewStatus.success;
  bool get hasError => status == ViewStatus.error && error != null;

  String? get errorMessage => error?.userMessage;
}
