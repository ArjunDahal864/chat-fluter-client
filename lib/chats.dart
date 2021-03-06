class ChatsRequestResponse {
  String? type;
  String? id;
  String? data;
  int? recipientId;
  int? senderId;

  ChatsRequestResponse(
      {this.type, this.id, this.data, this.recipientId, this.senderId});

  ChatsRequestResponse.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    data = json['data'];
    recipientId = json['recipient_id'];
    senderId = json['sender_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['data'] = this.data;
    data['recipient_id'] = this.recipientId;
    data['sender_id'] = this.senderId;
    return data;
  }
}
