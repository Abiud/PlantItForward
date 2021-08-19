String cutString(String a, int length) {
  if (length > a.length) return a;
  return a.substring(0, length) + "...";
}

String getGroupChatId(String userA, String userB) {
  int result = userA.compareTo(userB);
  if (result <= 0) {
    print(userA + '_' + userB);
    return userA + '_' + userB;
  } else {
    print(userB + '_' + userA);
    return userB + '_' + userA;
  }
}

// Web
// admin 35593674
// neftali 449449615

// android & iphone
// neftali 275793502
// admin 981334232

