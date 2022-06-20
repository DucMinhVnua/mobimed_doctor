class StatisticAppointmentByIndex {
  int _id;
  int total;
  int crms;
  int apps;
  int webs;
  int fbchats;
  int zalochats;
  List<StatisticByDepartment> departments;
  int waitings;
  int cancels;
  int approves;
  int serves;
  int hospitals;
  int onlines;
  // ignore: non_constant_identifier_names
  int online_approves;
  // ignore: non_constant_identifier_names
  int online_serves;

  StatisticAppointmentByIndex.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"],
        total = map["total"],
        crms = map["crms"],
        apps = map["apps"],
        webs = map["webs"],
        fbchats = map["fbchats"],
        zalochats = map["zalochats"],
        departments =
            map.containsKey("departments") && map["departments"] != null
                ? List<StatisticByDepartment>.from(map["departments"]
                    .map((it) => StatisticByDepartment.fromJsonMap(it)))
                : null,
        waitings = map["waitings"],
        cancels = map["cancels"],
        approves = map["approves"],
        serves = map["serves"],
        hospitals = map["hospitals"],
        onlines = map["onlines"],
        online_approves = map["online_approves"],
        online_serves = map["online_serves"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['total'] = total;
    data['crms'] = crms;
    data['apps'] = apps;
    data['webs'] = webs;
    data['fbchats'] = fbchats;
    data['zalochats'] = zalochats;
    data['departments'] = departments != null
        ? this.departments.map((v) => v.toJson()).toList()
        : null;
    data['waitings'] = waitings;
    data['cancels'] = cancels;
    data['approves'] = approves;
    data['serves'] = serves;
    data['hospitals'] = serves;
    data['onlines'] = serves;
    data['online_approves'] = serves;
    data['online_serves'] = serves;
    return data;
  }
}

class StatisticByDepartment {
  String _id;
  String name;
  int total;
  int crms;
  int apps;
  int webs;
  int fbchats;
  int zalochats;
  int waitings;
  int cancels;
  int approves;
  int serves;

  StatisticByDepartment.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"],
        name = map["name"],
        total = map["total"],
        crms = map["crms"],
        apps = map["apps"],
        webs = map["webs"],
        fbchats = map["fbchats"],
        zalochats = map["zalochats"],
        waitings = map["waitings"],
        cancels = map["cancels"],
        approves = map["approves"],
        serves = map["serves"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['name'] = name;
    data['total'] = total;
    data['crms'] = crms;
    data['apps'] = apps;
    data['webs'] = webs;
    data['fbchats'] = fbchats;
    data['zalochats'] = zalochats;
    data['waitings'] = waitings;
    data['cancels'] = cancels;
    data['approves'] = approves;
    data['serves'] = serves;
    return data;
  }
}
