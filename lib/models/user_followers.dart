import 'dart:convert';

class UserFollowers {
  String login;
  int id;
  String nodeId;
  String avatarUrl;
  String gravatarId;
  String url;
  String htmlUrl;
  String followersUrl;
  String followingUrl;
  String gistsUrl;
  String starredUrl;
  String subscriptionsUrl;
  String organizationsUrl;
  String reposUrl;
  String eventsUrl;
  String receivedEventsUrl;
  String type;
  bool siteAdmin;
  UserFollowers({
    required this.login,
    required this.id,
    required this.nodeId,
    required this.avatarUrl,
    required this.gravatarId,
    required this.url,
    required this.htmlUrl,
    required this.followersUrl,
    required this.followingUrl,
    required this.gistsUrl,
    required this.starredUrl,
    required this.subscriptionsUrl,
    required this.organizationsUrl,
    required this.reposUrl,
    required this.eventsUrl,
    required this.receivedEventsUrl,
    required this.type,
    required this.siteAdmin,
  });

  UserFollowers copyWith({
    String? login,
    int? id,
    String? nodeId,
    String? avatarUrl,
    String? gravatarId,
    String? url,
    String? htmlUrl,
    String? followersUrl,
    String? followingUrl,
    String? gistsUrl,
    String? starredUrl,
    String? subscriptionsUrl,
    String? organizationsUrl,
    String? reposUrl,
    String? eventsUrl,
    String? receivedEventsUrl,
    String? type,
    bool? siteAdmin,
  }) {
    return UserFollowers(
      login: login ?? this.login,
      id: id ?? this.id,
      nodeId: nodeId ?? this.nodeId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      gravatarId: gravatarId ?? this.gravatarId,
      url: url ?? this.url,
      htmlUrl: htmlUrl ?? this.htmlUrl,
      followersUrl: followersUrl ?? this.followersUrl,
      followingUrl: followingUrl ?? this.followingUrl,
      gistsUrl: gistsUrl ?? this.gistsUrl,
      starredUrl: starredUrl ?? this.starredUrl,
      subscriptionsUrl: subscriptionsUrl ?? this.subscriptionsUrl,
      organizationsUrl: organizationsUrl ?? this.organizationsUrl,
      reposUrl: reposUrl ?? this.reposUrl,
      eventsUrl: eventsUrl ?? this.eventsUrl,
      receivedEventsUrl: receivedEventsUrl ?? this.receivedEventsUrl,
      type: type ?? this.type,
      siteAdmin: siteAdmin ?? this.siteAdmin,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'login': login});
    result.addAll({'id': id});
    result.addAll({'nodeId': nodeId});
    result.addAll({'avatarUrl': avatarUrl});
    result.addAll({'gravatarId': gravatarId});
    result.addAll({'url': url});
    result.addAll({'htmlUrl': htmlUrl});
    result.addAll({'followersUrl': followersUrl});
    result.addAll({'followingUrl': followingUrl});
    result.addAll({'gistsUrl': gistsUrl});
    result.addAll({'starredUrl': starredUrl});
    result.addAll({'subscriptionsUrl': subscriptionsUrl});
    result.addAll({'organizationsUrl': organizationsUrl});
    result.addAll({'reposUrl': reposUrl});
    result.addAll({'eventsUrl': eventsUrl});
    result.addAll({'receivedEventsUrl': receivedEventsUrl});
    result.addAll({'type': type});
    result.addAll({'siteAdmin': siteAdmin});

    return result;
  }

  factory UserFollowers.fromMap(Map<String, dynamic> map) {
    return UserFollowers(
      login: map['login'] ?? '',
      id: map['id']?.toInt() ?? 0,
      nodeId: map['nodeId'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      gravatarId: map['gravatarId'] ?? '',
      url: map['url'] ?? '',
      htmlUrl: map['htmlUrl'] ?? '',
      followersUrl: map['followersUrl'] ?? '',
      followingUrl: map['followingUrl'] ?? '',
      gistsUrl: map['gistsUrl'] ?? '',
      starredUrl: map['starredUrl'] ?? '',
      subscriptionsUrl: map['subscriptionsUrl'] ?? '',
      organizationsUrl: map['organizationsUrl'] ?? '',
      reposUrl: map['reposUrl'] ?? '',
      eventsUrl: map['eventsUrl'] ?? '',
      receivedEventsUrl: map['receivedEventsUrl'] ?? '',
      type: map['type'] ?? '',
      siteAdmin: map['siteAdmin'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserFollowers.fromJson(Map<String, dynamic> map) {
    return UserFollowers(
      login: map['login'] ?? '',
      id: map['id'] ?? 0,
      nodeId: map['node_id'] ?? '',
      avatarUrl: map['avatar_url'] ?? '',
      gravatarId: map['gravatar_id'] ?? '',
      url: map['url'] ?? '',
      htmlUrl: map['html_url'] ?? '',
      followersUrl: map['followers_url'] ?? '',
      followingUrl: map['following_url'] ?? '',
      gistsUrl: map['gists_url'] ?? '',
      starredUrl: map['starred_url'] ?? '',
      subscriptionsUrl: map['subscriptions_url'] ?? '',
      organizationsUrl: map['organizations_url'] ?? '',
      reposUrl: map['repos_url'] ?? '',
      eventsUrl: map['events_url'] ?? '',
      receivedEventsUrl: map['received_events_url'] ?? '',
      type: map['type'] ?? '',
      siteAdmin: map['site_admin'] ?? false,
    );
  }

  @override
  String toString() {
    return 'UserFollowers(login: $login, id: $id, nodeId: $nodeId, avatarUrl: $avatarUrl, gravatarId: $gravatarId, url: $url, htmlUrl: $htmlUrl, followersUrl: $followersUrl, followingUrl: $followingUrl, gistsUrl: $gistsUrl, starredUrl: $starredUrl, subscriptionsUrl: $subscriptionsUrl, organizationsUrl: $organizationsUrl, reposUrl: $reposUrl, eventsUrl: $eventsUrl, receivedEventsUrl: $receivedEventsUrl, type: $type, siteAdmin: $siteAdmin)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserFollowers &&
        other.login == login &&
        other.id == id &&
        other.nodeId == nodeId &&
        other.avatarUrl == avatarUrl &&
        other.gravatarId == gravatarId &&
        other.url == url &&
        other.htmlUrl == htmlUrl &&
        other.followersUrl == followersUrl &&
        other.followingUrl == followingUrl &&
        other.gistsUrl == gistsUrl &&
        other.starredUrl == starredUrl &&
        other.subscriptionsUrl == subscriptionsUrl &&
        other.organizationsUrl == organizationsUrl &&
        other.reposUrl == reposUrl &&
        other.eventsUrl == eventsUrl &&
        other.receivedEventsUrl == receivedEventsUrl &&
        other.type == type &&
        other.siteAdmin == siteAdmin;
  }

  @override
  int get hashCode {
    return login.hashCode ^
        id.hashCode ^
        nodeId.hashCode ^
        avatarUrl.hashCode ^
        gravatarId.hashCode ^
        url.hashCode ^
        htmlUrl.hashCode ^
        followersUrl.hashCode ^
        followingUrl.hashCode ^
        gistsUrl.hashCode ^
        starredUrl.hashCode ^
        subscriptionsUrl.hashCode ^
        organizationsUrl.hashCode ^
        reposUrl.hashCode ^
        eventsUrl.hashCode ^
        receivedEventsUrl.hashCode ^
        type.hashCode ^
        siteAdmin.hashCode;
  }
}
