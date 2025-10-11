enum MessageType {
  text,
  audio,
  connect,
  ringingForUser,
  incomingCall,
  refuseCall,
  acceptCall,
  unknown,
}

extension MessageTypeParser on MessageType {
  static MessageType fromString(String str) {
    switch (str) {
      case "text":
        return MessageType.text;
      case "audio":
        return MessageType.audio;
      case "connect":
        return MessageType.connect;
      case "ringingForUser":
        return MessageType.ringingForUser;
      case "incomingCall":
        return MessageType.incomingCall;
      case "refuseCall":
        return MessageType.refuseCall;
      case "acceptCall":
        return MessageType.acceptCall;
      default:
        return MessageType.unknown;
    }
  }
}
