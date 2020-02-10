class Presence {
  final String username;
  final String signIn;
  final double latSignIn;
  final double longSignIn;
  final String signOut;
  final double latSignOut;
  final double longSignOut;

  Presence(
      {
      this.username,
      this.signIn,
      this.latSignIn,
      this.longSignIn,
      this.signOut,
      this.latSignOut,
      this.longSignOut,});

  static Presence fromJson(data) {
    return Presence(
        username: data['username'],
        signIn: data['signIn'],
        latSignIn: data['latSignIn'],
        longSignIn: data['longSignIn'],
        signOut: data['signOut'],
        latSignOut: data['latSignOut'],
        longSignOut: data['longSignOut']);
  }

  static List<Presence> fromJsonList(data) {
    List<Presence> presences = [];
    data.forEach((item) {
      presences.add(Presence.fromJson(item));
    });
    return presences;
  }
}
