class login {
  String? fullName;
  int? mobileNumber;

  login({this.fullName, this.mobileNumber});

  login.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    mobileNumber = json['mobileNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['mobileNumber'] = mobileNumber;
    return data;
  }
}