enum ViewStatus { initial, loading, loaded, error }

class ViewState<T> {
  final ViewStatus status;
  final T? data;
  final String? errorMessage;

  const ViewState._({required this.status, this.data, this.errorMessage});

  const ViewState.initial() : this._(status: ViewStatus.initial);
  const ViewState.loading() : this._(status: ViewStatus.loading);
  const ViewState.loaded(T data) : this._(status: ViewStatus.loaded, data: data);
  const ViewState.error(String message)
      : this._(status: ViewStatus.error, errorMessage: message);

  bool get isLoading => status == ViewStatus.loading;
  bool get isError => status == ViewStatus.error;
  bool get isLoaded => status == ViewStatus.loaded;
}