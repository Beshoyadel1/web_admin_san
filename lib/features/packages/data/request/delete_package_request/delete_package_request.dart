class DeletePackageRequest {
  final int packageID;

  const DeletePackageRequest({
    required this.packageID,
  });

  Map<String, dynamic> toJson() {
    return {
      'packageID': packageID,
    };
  }
}