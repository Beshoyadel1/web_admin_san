class DeleteBannerRequest {
  final int id;

  DeleteBannerRequest({
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
    };
  }
}