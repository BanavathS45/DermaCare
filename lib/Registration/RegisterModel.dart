class RegisterModel {
  String? fullName;
  String? mobileNumber;
  String? gender;
  String? bloodGroup;
  int? age;
  String? emailId;

  RegisterModel(
      {this.fullName,
      this.mobileNumber,
      this.gender,
      this.bloodGroup,
      this.age,
      this.emailId});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    mobileNumber = json['mobileNumber'];
    gender = json['gender'];
    bloodGroup = json['bloodGroup'];
    age = json['age'];
    emailId = json['emailId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] =  fullName;
    data['mobileNumber'] = mobileNumber;
    data['gender'] =  gender;
    data['bloodGroup'] =  bloodGroup;
    data['age'] =  age;
    data['emailId'] =  emailId;
    return data;
  }
}