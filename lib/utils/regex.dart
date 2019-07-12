// 获取第一个正则匹配内容
Match matchOne(String regex, String content) {
  RegExp exp = RegExp(regex);
  return exp.firstMatch(content);
}

// 获取所有正则匹配内容
Iterable<Match> matchAll(String regex, String content) {
  RegExp exp = RegExp(regex);
  return exp.allMatches(content);
}
