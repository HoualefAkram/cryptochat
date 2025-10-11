enum MessageType {
  text,
  audio,
  connect,
  requestCall,
  cancelRequestCall,
  ringing,
  refuseCall,
  acceptCall,
  endCall,
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
      case "requestCall":
        return MessageType.requestCall;
      case "ringing":
        return MessageType.ringing;
      case "refuseCall":
        return MessageType.refuseCall;
      case "acceptCall":
        return MessageType.acceptCall;
      case "cancelRequestCall":
        return MessageType.cancelRequestCall;
      case "endCall":
        return MessageType.endCall;
      default:
        return MessageType.unknown;
    }
  }
}
