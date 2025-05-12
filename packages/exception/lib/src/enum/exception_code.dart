enum ExceptionCode {
  // Common
  general(code: "GEN"),
  decodeFailed(code: "DF"),

  // Local Storage & File System
  localStorageCorruption(code: "LCR"),
  localStorageAlreadyOpened(code: "LAO"),
  localStorageClosed(code: "LCD"),
  readOnlyFileSystem(code: "ROF"),
  storageFull(code: "SF"),

  // Network
  noInternetConnection(code: "NIC"),
  requestTimeOut(code: "RTO"),
  pollingTimeOut(code: "PTO"),
  retryExceeded(code: "RE"),

  // Server
  apiError(code: "AE"),
  undefinedErrorResponse(code: "UER"),

  // Media
  streamUploadFailed(code: "SUF"),
  uploadInProgress(code: "UIP"),

  // Limit
  maximumLimit(code: "MAL"),
  minimumPayment(code: "MIP"),
  maximumPayment(code: "MAP"),

  // Liveness
  liveness(code: "LVN"),

  // Permission
  permissionDenied(code: "PMD");

  const ExceptionCode({required this.code});

  final String code;
}
