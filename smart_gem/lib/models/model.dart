class Message {
  String messageID;
  String chatID;
  Role role;
  StringBuffer message;
  List<String> imageUrls;
  DateTime timeSent;

  //Contstructor
  Message(
      {required this.messageID,
      required this.chatID,
      required this.role,
      required this.message,
      required this.imageUrls,
      required this.timeSent});

 //to map the data from the database
  Map<String, dynamic> toMap() {
    return {
      'messageID': messageID,
      'chatID': chatID,
      'role': role.index,
      'message': message.toString(),
      'imageUrls': imageUrls,
      'timeSent':  timeSent.toIso8601String(),
    };
  }

  //toMap
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageID: map['messageID'],
      chatID: map['chatID'],
      role: Role.values[map['role']],
      message: StringBuffer(map['message']),
      imageUrls: List<String>.from(map['imageUrls']),
      timeSent:  DateTime.parse(map['timeSent']),
    );
  }

  //for map
  factory Message.fromSnapshot(Map<String, dynamic> map) {
    return Message(
      messageID: map['messageID'],
      chatID: map['chatID'],
      role: Role.values[map['role']],
      message: StringBuffer(map['message']),
      imageUrls: List<String>.from(map['imageUrls']),
      timeSent: map['timeSent'].toDate(),
    );
  }

  //copyWith
  Message copyWith({
    String? messageID,
    String? chatID,
    Role? role,
    StringBuffer? message,
    List<String>? imageUrls,
    DateTime? timeSent,
  }) {
    return Message(
      messageID: messageID ?? this.messageID,
      chatID: chatID ?? this.chatID,
      role: role ?? this.role,
      message: message ?? this.message,
      imageUrls: imageUrls ?? this.imageUrls,
      timeSent: timeSent ?? this.timeSent,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.messageID == messageID;     
  }
}

enum Role { user, assistant }
