class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final int passes;
  final String avatarUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.passes,
    required this.avatarUrl,
  });
}
