
String uiDateFormat(DateTime time, {String defaultString = ""}){
  return time == null ?
      defaultString :
      time.toString();
}