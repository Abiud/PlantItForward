String getConversationID(String userID, String peerID) {
  return userID.hashCode <= peerID.hashCode
      ? userID + '_' + peerID
      : peerID + '_' + userID;
}
