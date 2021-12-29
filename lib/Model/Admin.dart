class Admin {
  int? admin_id;
  String? admin_name;
  String? email;
  String? password;

  Admin( this.admin_name, this.email, this.password);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'admin_name': admin_name,
      'email': email,
      'password': password
    };
    return map;
  }

  Admin.fromMap(Map<String, dynamic> map) {
    admin_id = (map['admin_id']) as int;
    admin_name = map['admin_name'];
    email = map['email'];
    password = map['password'];
  }
}