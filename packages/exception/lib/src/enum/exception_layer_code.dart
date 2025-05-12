enum ExceptionLayerCode {
  viewModel(code: "VM"),
  useCase(code: "UC"),
  repository(code: "R"),
  utility(code: "UT"),
  methodChannel(code: "MC");

  const ExceptionLayerCode({required this.code});

  final String code;
}
