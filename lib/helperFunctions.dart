String getConversationID(String userID, String peerID) {
  return userID.hashCode <= peerID.hashCode
      ? userID + '_' + peerID
      : peerID + '_' + userID;
}

String cutString(String a, int length) {
  if (length > a.length) return a;
  return a.substring(0, length) + "...";
}

String getGroupChatId(String userA, String userB) {
  if (userA.hashCode <= userB.hashCode) {
    return userA + '_' + userB;
  } else {
    return userB + '_' + userA;
  }
}
