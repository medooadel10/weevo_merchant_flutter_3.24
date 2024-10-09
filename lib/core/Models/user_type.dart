class UserTypeModel {
  String title;
  String description;
  String value;

  UserTypeModel(this.title, this.description, this.value);

  @override
  String toString() {
    return 'UserTypeModel{title: $title, description: $description, value: $value}';
  }
}
