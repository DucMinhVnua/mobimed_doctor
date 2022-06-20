class HomeBookServiceDetail {
  String _id, name;
  bool isPack;
  DateTime servingTime;
  List<ServiceBookDetail> details;

  String get id => _id;

  HomeBookServiceDetail.fromJsonMap(Map<String, dynamic> map)
      : _id = map['_id'],
        name = map['name'],
        isPack = map['isPack'],
        details = map.containsKey('details') && map['details'] != null
            ? List<ServiceBookDetail>.from(map['details']
                .map((item) => ServiceBookDetail.fromJsonMap(item)))
            : null,
        servingTime =
            map.containsKey('servingTime') && map['servingTime'] != null
                ? DateTime.parse(map['servingTime'].toString())
                : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = _id;
    data['name'] = name;
    data['isPack'] = isPack;
    data['details'] = details.map((e) => e.toJson()).toList();
    data['servingTime'] = servingTime.toIso8601String();

    return data;
  }
}

class ServiceBookDetail {
  String _id, name, state, description, imageId;
  int price;
  DateTime servingTime;

  String get id => _id;

  ServiceBookDetail.fromJsonMap(Map<String, dynamic> map)
      : _id = map['_id'],
        name = map['name'],
        state = map['state'],
        description = map['description'],
        imageId = map['imageId'],
        price = map['price'],
        servingTime = DateTime.parse(map['servingTime'].toString());

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = _id;
    data['name'] = name;
    data['state'] = state;
    data['description'] = description;
    data['imageId'] = imageId;
    data['price'] = price;
    data['servingTime'] = servingTime.toIso8601String();

    return data;
  }
}

class HomeBookHistoryData {
  List<HomePatientBook> patientInfo;
  List<HomeBookServiceDetail> services;
  List<HomeBookServiceInfo> servicesInfo;
  List<MedicalTicket> tickets;
  String _id, note;
  DateTime servingTime;

  String get id => _id;

  HomeBookHistoryData.fromJsonMap(Map<String, dynamic> map)
      : _id = map['_id'],
        servingTime =
            map.containsKey('servingTime') && map['servingTime'] != null
                ? DateTime.parse(map['servingTime'].toString())
                : null,
        note = map['note'],
        patientInfo =
            map.containsKey('patientInfo') && map['patientInfo'] != null
                ? List<HomePatientBook>.from(map['patientInfo']
                    .map((item) => HomePatientBook.fromJsonMap(item)))
                : null,
        servicesInfo =
            map.containsKey('servicesInfo') && map['servicesInfo'] != null
                ? List<HomeBookServiceInfo>.from(map['servicesInfo']
                    .map((item) => HomeBookServiceInfo.fromJsonMap(item)))
                : null,
        tickets = map.containsKey('tickets') && map['tickets'] != null
            ? List<MedicalTicket>.from(
                map['tickets'].map((item) => MedicalTicket.fromJsonMap(item)))
            : null,
        services = map.containsKey('services') && map['services'] != null
            ? List<HomeBookServiceDetail>.from(map['services']
                .map((item) => HomeBookServiceDetail.fromJsonMap(item)))
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patientInfo'] = patientInfo.map((e) => e.toJson()).toList();
    data['services'] = services.map((e) => e.toJson()).toList();
    data['tickets'] = tickets.map((e) => e.toJson()).toList();
    data['servicesInfo'] = servicesInfo.map((e) => e.toJson()).toList();
    data['_id'] = _id;
    data['note'] = note;
    data['servingTime'] = servingTime.toIso8601String();

    return data;
  }
}

class TicketBookService {
  String _id, name, packDataId, doctorId, doctorName;
  int price;
  DateTime servingTime;

  TicketBookService();

  TicketBookService.fromJsonMap(Map<String, dynamic> map)
      : _id = map.containsKey('_id') && map['_id'] != null ? map['_id'] : null,
        name =
            map.containsKey('name') && map['name'] != null ? map['name'] : null,
        packDataId = map.containsKey('packDataId') && map['packDataId'] != null
            ? map['packDataId']
            : null,
        doctorId = map.containsKey('doctorId') && map['doctorId'] != null
            ? map['doctorId']
            : null,
        doctorName = map.containsKey('doctorName') && map['doctorName'] != null
            ? map['doctorName']
            : null,
        price = map.containsKey('price') && map['price'] != null
            ? map['price']
            : null,
        servingTime =
            map.containsKey('servingTime') && map['servingTime'] != null
                ? DateTime.parse(map['servingTime'].toString())
                : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = _id;
    data['name'] = name;
    data['packDataId'] = packDataId;
    data['doctorId'] = doctorId;
    data['doctorName'] = doctorName;
    data['price'] = price;
    data['servingTime'] = servingTime.toIso8601String();
    return data;
  }
}

class HomeBookServiceInfo {
  String _id, name, packDataId;
  int price;
  DateTime servingTime;
  get id => _id;
  HomeBookServiceInfo.fromJsonMap(Map<String, dynamic> map)
      : _id = map['_id'] ?? '',
        name = map['name'] ?? '',
        packDataId = map['packDataId'] ?? '',
        price = map['price'] ?? 0,
        servingTime =
            map.containsKey('servingTime') && map['servingTime'] != null
                ? DateTime.parse(map['servingTime'].toString())
                : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = _id;
    data['name'] = name;
    data['packDataId'] = packDataId;
    data['price'] = price;
    data['servingTime'] = servingTime.toIso8601String();
    return data;
  }
}

class MedicalTicket {
  String _id, note;
  HealthData healthData;
  HomePatientBook patientInfo;
  List<DoctorTicket> doctorInfos;
  List<IndicationTicket> indications;
  List<IndicationTicket> services;
  TicketBookService bookService;
  List<String> fileIds;
  int state;
  get id => _id;

  MedicalTicket.fromJsonMap(Map<String, dynamic> map)
      : _id = map['_id'] ?? '',
        note = map['note'] ?? '',
        state = map['state'] ?? 0,
        healthData = map.containsKey('healthData') && map['healthData'] != null
            ? HealthData.fromJsonMap(map['healthData'])
            : null,
        bookService =
            map.containsKey('bookService') && map['bookService'] != null
                ? TicketBookService.fromJsonMap(map['bookService'])
                : null,
        patientInfo =
            map.containsKey('patientInfo') && map['patientInfo'] != null
                ? HomePatientBook.fromJsonMap(map['patientInfo'])
                : null,
        doctorInfos =
            map.containsKey('doctorInfos') && map['doctorInfos'] != null
                ? List<DoctorTicket>.from(map['doctorInfos']
                    .map((item) => DoctorTicket.fromJsonMap(item)))
                : null,
        indications =
            map.containsKey('indications') && map['indications'] != null
                ? List<IndicationTicket>.from(map['indications']
                    .map((item) => IndicationTicket.fromJsonMap(item)))
                : null,
        fileIds = map.containsKey('fileIds') && map['fileIds'] != null
            ? List<String>.from(map['fileIds'].map((item) => item.toString()))
            : null,
        services = map.containsKey('services') && map['services'] != null
            ? List<IndicationTicket>.from(map['services']
                .map((item) => IndicationTicket.fromJsonMap(item)))
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = _id;
    data['note'] = note;
    data['state'] = state;
    data['healthData'] = healthData.toJson();
    data['bookService'] = bookService.toJson();
    data['patientInfo'] = patientInfo.toJson();
    data['doctorInfos'] = doctorInfos.map((e) => e.toJson()).toList();
    data['indications'] = indications.map((e) => e.toJson()).toList();
    data['services'] = services.map((e) => e.toJson()).toList();
    data['fileIds'] = fileIds.map((e) => e.toString());
    return data;
  }
}

class MedicalTicketPrice {
  String _id;
  List<IndicationTicket> indications;
  List<IndicationTicket> services;
  int totalPrice;
  get id => _id;

  MedicalTicketPrice.fromJsonMap(Map<String, dynamic> map)
      : _id = map['_id'] ?? '',
        totalPrice = map['totalPrice'] ?? 0,
        indications =
            map.containsKey('indications') && map['indications'] != null
                ? List<IndicationTicket>.from(map['indications']
                    .map((item) => IndicationTicket.fromJsonMap(item)))
                : null,
        services = map.containsKey('services') && map['services'] != null
            ? List<IndicationTicket>.from(map['services']
                .map((item) => IndicationTicket.fromJsonMap(item)))
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = _id;
    data['totalPrice'] = totalPrice;
    data['indications'] = indications.map((e) => e.toJson()).toList();
    data['services'] = services.map((e) => e.toJson()).toList();
    return data;
  }
}

// indication đã add vào ticket có result
class IndicationTicket {
  String _id, name, dataId, state, result;
  List<String> fileIds;
  int price;
  get id => _id;
  IndicationTicket();
  IndicationTicket.fromJsonMap(Map<String, dynamic> map)
      : _id = map['_id'] ?? '',
        name = map['name'] ?? '',
        dataId = map['dataId'] ?? '',
        state = map['state'] ?? '',
        result = map['result'] ?? '',
        price = map['price'] ?? '',
        fileIds = map.containsKey('fileIds') && map['fileIds'] != null
            ? List<String>.from(map['fileIds'].map((item) => item))
            : null;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = _id;
    data['name'] = name;
    data['dataId'] = dataId;
    data['state'] = state;
    data['result'] = result;
    data['price'] = price;
    data['fileIds'] = fileIds.toString();
    return data;
  }
}

class DoctorTicket {
  String _id, name;
  DoctorTicket();
  DoctorTicket.fromJsonMap(Map<String, dynamic> map)
      : _id = map['_id'] ?? '',
        name = map['name'] ?? '';
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = _id;
    data['name'] = name;
    return data;
  }
}

class HealthData {
  int height, weight, bodyTemperature, pulseRate, respirationRate;
  String bloodPressure;

  HealthData();

  HealthData.fromJsonMap(Map<String, dynamic> map)
      : height = map['height'] ?? 0,
        weight = map['weight'] ?? 0,
        bodyTemperature = map['bodyTemperature'] ?? 0,
        pulseRate = map['pulseRate'] ?? 0,
        respirationRate = map['respirationRate'] ?? 0,
        bloodPressure = map['bloodPressure'] ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['height'] = height;
    data['weight'] = weight;
    data['bodyTemperature'] = bodyTemperature;
    data['pulseRate'] = pulseRate;
    data['respirationRate'] = respirationRate;
    data['bloodPressure'] = bloodPressure;
    return data;
  }
}

class HomePatientBook {
  String _id, name, phone, address;

  void setID(String newID) {
    _id = newID;
  }

  get id => _id;

  HomePatientBook();

  HomePatientBook.fromJsonMap(Map<String, dynamic> map)
      : name = map['name'],
        phone = map['phone'],
        address = map['address'],
        _id = map['_id'];
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['address'] = address;
    data['_id'] = _id;
    return data;
  }
}

// item trong danh sách indication lấy từ his
class TicketIndication {
  String _id, name, code, unit, categoryCode;
  int hisId, isGroup, price;

  void setID(String newID) {
    _id = newID;
  }

  get id => _id;

  TicketIndication();

  TicketIndication.fromJsonMap(Map<String, dynamic> map)
      : _id = map['_id'],
        name = map['name'],
        code = map['code'],
        unit = map['unit'],
        categoryCode = map['categoryCode'],
        hisId = map['hisId'],
        isGroup = map['coisGroupde'],
        price = map['price'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = _id;
    data['name'] = name;
    data['code'] = code;
    data['unit'] = unit;
    data['categoryCode'] = categoryCode;
    data['hisId'] = hisId;
    data['isGroup'] = isGroup;
    data['price'] = price;
    return data;
  }
}

class HomeMedicalServiceData {
  String id, name, imageId, description, category;
  bool enable;
  int price;

  HomeMedicalServiceData.fromJsonMap(Map<String, dynamic> map)
      : id = map['_id'],
        name = map['name'],
        category = map['category'],
        imageId = map['imageId'],
        description = map['description'],
        enable = map['enable'],
        price = map['price'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['category'] = category;
    data['imageId'] = imageId;
    data['description'] = description;
    data['enable'] = enable;
    data['price'] = price;
    return data;
  }
}

class HomeMedicalPackData {
  String id, name, imageId, description;
  int price;
  bool enable;
  List<PackServiceData> details;

  HomeMedicalPackData();

  HomeMedicalPackData.fromJsonMap(Map<String, dynamic> map)
      : id = map['_id'],
        name = map['name'],
        imageId = map['imageId'],
        description = map['description'],
        price = map['price'],
        enable = map['enable'],
        details = map.containsKey('details') && map['details'] != null
            ? List<PackServiceData>.from(
                map['details'].map((item) => PackServiceData.fromJsonMap(item)))
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['imageId'] = imageId;
    data['description'] = description;
    data['price'] = price;
    data['enable'] = enable;
    data['details'] = details.map((e) => e.toJson()).toList();
    return data;
  }
}

class PackServiceData {
  String serviceId, serviceName;
  int servicePrice, implementDate;

  PackServiceData.fromJsonMap(Map<String, dynamic> map)
      : serviceId = map['serviceId'],
        serviceName = map['serviceName'],
        servicePrice = map['servicePrice'],
        implementDate = map['implementDate'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serviceId'] = serviceId;
    data['serviceName'] = serviceName;
    data['servicePrice'] = servicePrice;
    data['implementDate'] = implementDate;
    return data;
  }
}

class ServiceDataInput {
  String _id, servingTime;
  bool isPack;
  ServiceDataInput();
  setId(String newID) {
    _id = newID;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = _id;
    data['isPack'] = isPack;
    data['servingTime'] = servingTime;
    return data;
  }
}
