class ApiData<T> {
  final bool success;
  final String msg;
  final T data;
  final dynamic extraData;

  const ApiData({
    required this.success,
    required this.msg,
    required this.data,
    this.extraData,
  });
}
