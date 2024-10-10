class SupportRequest {
  String id;
  String userId;
  String type;  // 'Request' or 'Offer'
  String description;

  SupportRequest({required this.id, required this.userId, required this.type, this.description = ''});
}
