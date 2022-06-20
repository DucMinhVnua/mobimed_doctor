String queryGetAppConfig = r'''
query getAppConfig($platform: PlatformEnum = null){
  response: versionSetting(platform:$platform){
    code
    message
    data{
      versionReview
      registerable
      version
      description
      forceUpdate
      link
      privatePolicyUrl
      termsUrl
      appId
    }
  }
}
''';

String mutationRegisterDevice = r'''
mutation registerDevice($data: DeviceInput! ){
  response: registerDevice(data:$data){
    code
    message
    data{
     	_id
      platform
      userId
      appId
      tokenId
      uniqueId
      auth
    }
  }
}
''';

String queryGetDepartmentById = r'''
query queryGetDepartmentById($_id: String!){
  response: department(_id: $_id) {
    data {
      _id
      enableTimeFrame
      servingTimes {
        dayOfWeek
        maxProcess
        timeFrame
      }
      code
      name
      status
    }
    code
    message
  }
}
''';
String queryGetAccountInfo = r'''
query getAccountInfo {
  response: me {
    code
    message
    data {
      _id
      base{
        sub
        name
        fullName
        gender
        code
        avatar
        departmentName
        address
        phoneNumber
        email
        birthday
        work
      }
      role
    }
  }
}
''';

String queryGetNotifications = r'''
query getNotifications(
  $filtered: [FilteredInput]
  $sorted: [SortedInput]
  $page: Int
  $pageSize: Int
) {
  response: myAccountActions(
    filtered: $filtered
    sorted: $sorted
    page: $page
    pageSize: $pageSize
  ) {
    code
    message
    page
    pages
    records
    data {
      _id
      name
      description
      action
      data
      createdTime
    }
  }
}
''';

String queryGetNotification = r'''
query getNotificationSent($_id: String!) {
  response: myAccountAction(_id: $_id) {
    code
    message
    data {
       _id
      name
      description
      action
      data
      createdTime
    }
  }
}

''';
String queryGetServiceDemandOnlineGraph = r'''
query queryGetServiceDemandOnlineGraph{
  response:service_demand_online_graph
  {
    code
    message
    data{
      _id
      name
      fullName
      note
      departments {
        _id
        code
        name
      }
      children {
        _id
        name
        fullName
        note
        departments {
          _id
          code
          name
        }
        children {
          _id
          name
          fullName
          note
          departments {
            _id
            code
            name
          }
        }
      }
    }
  }
}
''';
String queryGetDepartments = r'''
query getDepartments {
  response: departments {
    code
    message
    page
    pages
    records
    data{
      _id
      code
      name
    }
  }
}
''';

String queryGetPatients = r'''
query getPatients(
  $filtered: [FilteredInput]
  $sorted: [SortedInput]
  $page: Int
  $pageSize: Int
) {
  response: patients(
    filtered: $filtered
    sorted: $sorted
    page: $page
    pageSize: $pageSize
  ) {
    code
    message
    page
    pages
    records
    data {
      _id
      fullName
      firstName
      middleName
      lastName
      patientCode
      gender
      avatar
      birthDay
      phoneNumber
      email
      insuranceCode
      nationIdentification
      work{
        code
        name
      }
      nationality {
        code
        name
      }
      nation {
        code
        name
      }
      province {
        code
        name
      }
      district {
        code
        name
      }
      ward {
        code
        name
      }
      street
      address
    }
  }
}
''';
String queryGetDetailPatient = r'''
query getDetailPatient($patientCode: String!) {
  response: patient(patientCode: $patientCode) {
    code
    data {
      _id
      fullName
      patientCode
      firstName
      middleName
      lastName
      gender
      avatar
      birthDay
      phoneNumber
      email
      insuranceCode
      nationIdentification
      work {
        code
        name
      }
      nationality {
        code
        name
      }
      nation {
        code
        name
      }
      province {
        code
        name
      }
      district {
        code
        name
      }
      ward {
        code
        name
      }
      street
      address
    }
    message
  }
}
''';
String queryCallVideoPatient = r'''
mutation queryCallVideoPatient($receiverId: String!, $callerToken: String!, $video: Boolean) {
  response: videocall_sent_noti(receiverId: $receiverId,callerToken:$callerToken,video:$video) {
    code
    message
    data
  }
}
''';
String queryStopCallVideo = r'''
mutation queryStopCallVideo($callId: String!, $token: String!, $accept: Boolean) {
  response: videocall_answer(callId: $callId,token:$token,accept:$accept) {
     code
    message
    data
  }
}
''';

String queryGetServiceParentId = r'''
query queryGetServiceParentId($parentId: String!){
  response: service_demand_by_parent(parentId: $parentId) {
    code
    message
    data {
      _id
      name
      parentId
      level
      note
      priority
      departmentIds
      departments {
        _id
        name
        code
      }
      haveChildren
    }
  }
}
''';

String querySearchHisPatients = r'''
query searchHisPatients(
  $data: PatientInfoInput 
) {
  response: search_his_patients(
    data: $data
  ) {
    code
    message
    page
    pages
    records
    data {
      _id
      fullName
      firstName
      middleName
      lastName
      patientCode
      gender
      avatar
      birthDay
      phoneNumber
      email
      insuranceCode
      nationIdentification
      work{
        code
        name
      }
      nationality {
        code
        name
      }
      nation {
        code
        name
      }
      province {
        code
        name
      }
      district {
        code
        name
      }
      ward {
        code
        name
      }
      street
      address
    }
  }
}
''';

String queryGetMedicalSessions = r'''
query getMedicalSessions(
  $page: Int!
  $pageSize: Int!
  $sorted: [SortedInput]
  $filtered: [FilteredInput]
) {
  response: medical_sessions(
    page: $page
    pageSize: $pageSize
    sorted: $sorted
    filtered: $filtered
  ) {
    code
    data {
      _id
      code
      reason
      insuranceCode
      process
      createdTime
      updatedTime
      doctor{
        code
        name
      }
      conclusions {
        code
        name
      }
      indications {
        _id
        name
        service {
          code
          name
        }
        doctor {
          _id
          code
          departmentId
          departmentName
          fullName
          work
        }
        department {
          name
          code
        }
        clinic {
          code
          name
        }
      }
      userAction {
        _id
        name
        action
        createdTime
        appointment {
          _id
          appointmentDate
          appointmentTime
          channel
          note
          code
          createdTime
          department {
            _id
            code
            name
          }
        }
      }
      appointment {
        _id
        appointmentDate
        appointmentTime
        channel
        note
        code
        createdTime
        department {
          _id
          code
          name
        }
      }
      patientInfo {
        _id
        patientCode
        fullName
        phoneNumber
        address
        birthDay
        avatar
      }
    }
    message
    page
    pages
  }
}
''';

String queryGetMedicalSessionsFollowingDoctor = r'''
query getMedicalSessionsFollowingDoctors(
  $page: Int!
  $pageSize: Int!
  $sorted: [SortedInput]
  $filtered: [FilteredInput]
) {
  response: medical_sessions_following_doctor(
    page: $page
    pageSize: $pageSize
    sorted: $sorted
    filtered: $filtered
  ) {
    code
    data {
      _id
      code
      insuranceCode
      process
      reason
      sequence
      terminateReason
      updatedTime
      createdTime
      creator {
        _id
        code
        departmentId
        departmentName
        fullName
        work
      }
      indications {
        _id
        name
        service {
          code
          name
        }
        doctor {
          _id
          code
          departmentId
          departmentName
          fullName
          work
        }
      }
      userAction {
        _id
        name
        action
        createdTime
        appointment {
          appointmentDate
          appointmentTime
        }
      }
      appointmentId
      patientInfo {
        _id
        patientCode
        fullName
        phoneNumber
        address
        birthDay
        avatar
      }
      appointment {
        _id
        appointmentDate
        appointmentTime
        channel
        note
        code
        createdTime
        department {
          _id
          code
          name
        }
      }
    }
    message
    page
    pages
  }
}
''';
String queryGetConclusions = r'''
query requestGetConclusions($_id: String!) {
  response: medical_session(_id: $_id) {
    code
    data {
      _id
      code
      createdTime
      doctor {
        code
        name
      }
      conclusions {
        name
        code
      }
      appointment {
        _id
        appointmentDate
        appointmentTime
        channel
        note
        code
        createdTime
        department {
          _id
          code
          name
        }
      }
      prescriptions {
        _id
        creator {
          _id
          code
          departmentId
          departmentName
          fullName
          work
        }
        drugs {
          _id
          name
          code
          instruction
          unit
          amount
        }
        images
        image_urls
      }
      files {
        _id
        name
      }
    }
    message
  }
}

''';

String queryGetMedicalSession = r'''
query getMedicalSession($_id: String!) {
  response: medical_session(_id: $_id) {
    code
    data {
      _id
      code
      createdTime
      doctor {
        code
        name
      }
      conclusions {
        code
        name
      }
      appointment {
        _id
        appointmentDate
        appointmentTime
        channel
        note
        code
        createdTime
        department {
          _id
          code
          name
        }
      }
      prescriptions {
        _id
        creator {
          _id
          code
          departmentId
          departmentName
          fullName
          work
        }
        drugs {
          _id
          name
          code
          instruction
          unit
          amount
        }
        images
        image_urls
      }
      files {
        _id
        name
      }
    }
    message
  }
}
''';

String queryGetIndications = r'''
query getIndications(
  $page: Int!
  $pageSize: Int!
  $sorted: [SortedInput]
  $filtered: [FilteredInput]
) {
  response: indications(
    page: $page
    pageSize: $pageSize
    sorted: $sorted
    filtered: $filtered
  ) {
    code
    data {
      _id
      code
      name
      result
      state
      note
      confirmedTime
      updatedTime
      createdTime
      sessionCode
      files {
        _id
        name
      }
      service{
        code
        name
      }
			doctor{
        _id
        code
        departmentId
        departmentName
        fullName
        work
      }
      patientInfo {
        _id
        patientCode
        fullName
        phoneNumber
        address
        birthDay
        avatar
      }
      department {
        name
        code
      }
      clinic {
        code
        name
      }
    }
    message
    page
    pages
  }
}
''';
String queryGetListIndications = r'''
query ($filtered: [FilteredInput], $sorted: [SortedInput], $page: Int, $pageSize: Int) {
  response: indications(page: $page, pageSize: $pageSize, filtered: $filtered, sorted: $sorted) {
    code
    message
    pages
    page
    records
    data {
      _id
      name
      result
      note
      createdTime
      code
      service_detail {
        priceOfInsurance
        priceOfSelfService
        price
      }
      service {
        code
        name
      }
      paid
      transaction {
        code
      }
      createdTime
      creator {
        code
        fullName
      }
      clinic {
        code
        name
      }
      doctor {
        code
        fullName
      }
      department {
        code
        name
      }
      state
      sessionCode
      files {
        _id
        name
      }
      patientInfo {
        work {
          name
        }
        fullName
        birthDay
        address
        phoneNumber
        gender
        ward {
          code
          name
        }
        province {
          code
          name
        }
        nation {
          code
          name
        }
        nationality {
          code
          name
        }
        street
        district {
          code
          name
        }
      }
    }
  }
}
''';
String queryGetAppointments = r'''
query getAppointments(
  $page: Int!
  $pageSize: Int!
  $sorted: [SortedInput]
  $filtered: [FilteredInput]
) {
  response: appointments(
    page: $page
    pageSize: $pageSize
    sorted: $sorted
    filtered: $filtered
  ) {
    code
    data {
      _id
      note
      code
      appointmentDate
      appointmentTime
      channel
      state
      updatedTime
      createdTime
      service {
        code
        name
      }
      patient {
        _id
        fullName
        patientCode
        firstName
        middleName
        lastName
        gender
        avatar
        birthDay
        phoneNumber
        email
        insuranceCode
        nationIdentification
        work {
          code
          name
        }
        nationality {
          code
          name
        }
        nation {
          code
          name
        }
        province {
          code
          name
        }
        district {
          code
          name
        }
        ward {
          code
          name
        }
        street
        address
      }
      inputPatient {
        _id
        fullName
        patientCode
        firstName
        middleName
        lastName
        gender
        avatar
        birthDay
        phoneNumber
        email
        insuranceCode
        nationIdentification
        work {
          code
          name
        }
        nationality {
          code
          name
        }
        nation {
          code
          name
        }
        province {
          code
          name
        }
        district {
          code
          name
        }
        ward {
          code
          name
        }
        street
        address
      }
      department {
        _id
        name
        code
      }
      doctor {
        _id
        sipPhone
        sipPhones
        base {
          sub
          name
          fullName
          code
          avatar
          departmentName
          address
          phoneNumber
          email
          birthday
          work
        }
      }
    }
    message
    page
    pages
  }
}
''';

String queryReportAppointmentIndex = r'''
query reportAppointmentIndex(
  $begin: DateTime,
  $end: DateTime,
  $departmentId: String,
) {
  response: reportAppointmentIndex(

    begin: $begin,
    end: $end,
    departmentId: $departmentId,
  ) {
    code
    message
    data
  }
}
''';

String queryGetUserActions = r'''
query getUserActions(
  $page: Int!
  $pageSize: Int!
  $sorted: [SortedInput]
  $filtered: [FilteredInput]
) {
  response: userActions(
    page: $page
    pageSize: $pageSize
    sorted: $sorted
    filtered: $filtered
  ) {
    code
    data {
      _id
      name
      action
      appointment {
        appointmentDate
        appointmentTime
      }
      data
      createdTime
    }
    message
    page
    pages
  }
}

''';

/* ===========================  TIN TỨC  ==================================== */
String queryGetHotNews = r'''
query  getHotNews{
  response:hotNews {
    code
    data {
       _id
      createdTime
      name
      shortDesc
      title
      thumbUrl
      updatedTime
    }
    message
    page
    pages
  }
}
''';
String queryGetNewsArticles = r'''
query  getArticles($page: Int!, $pageSize: Int!, $sorted: [SortedInput], $filtered: [FilteredInput]) {
  response:articles(page: $page, pageSize: $pageSize, sorted: $sorted, filtered: $filtered) {
    code
    data {
       _id
      createdTime
      name
      shortDesc
      title
      is_read
      updatedTime
      thumbUrl
    }
    message
    page
    pages
  }
}
''';
String queryGetNewsArticleDetail = r'''
query getArticleDetail($_id: String!) {
  response:article(_id: $_id) {
    code
    data {
      _id
      createdTime
      name
      shortDesc
      title
      updatedTime
      
      content
    }
    message
  }
}
''';

String queryGetPrescriptions = r'''
query getPrescriptionss(
  $filtered: [FilteredInput]
  $sorted: [SortedInput]
  $page: Int
  $pageSize: Int
) {
  response: prescriptions(
    filtered: $filtered
    sorted: $sorted
    page: $page
    pageSize: $pageSize
  ) {
    code
    message
    page
    pages
    records
    data {
      _id
      createdTime
      creator {
        _id
        code
        departmentId
        departmentName
        fullName
      }
      drugs {
        _id
        name
        code
        instruction
        unit
        amount
      }
      images
      image_urls
      appointment {
        _id
        appointmentDate
        appointmentTime
        channel
        note
        code
        createdTime
        department {
          _id
          code
          name
        }
      }
      patientInfo {
        _id
        patientCode
        fullName
        phoneNumber
        address
        birthDay
        avatar
      }
      medical_session {
        _id
        code
        createdTime
        doctor {
          code
          name
        }
        conclusions {
          _id
          group {
            code
            name
          }
          name
          note
          main
        }
        indications {
          _id
          name
          service {
            code
            name
          }
          doctor {
            _id
            code
            departmentId
            departmentName
            fullName
            work
          }
          department {
            name
            code
          }
          clinic {
            code
            name
          }
        }
        userAction {
          _id
          name
          action
          createdTime
          appointment {
            _id
            appointmentDate
            appointmentTime
            channel
            note
            code
            createdTime
            department {
              _id
              code
              name
            }
          }
        }
        appointment {
          _id
          appointmentDate
          appointmentTime
          channel
          note
          code
          createdTime
          department {
            _id
            code
            name
          }
        }
        patientInfo {
          _id
          patientCode
          fullName
          phoneNumber
          address
          birthDay
          avatar
        }
      }
    }
  }
}

''';

String queryGetWorks = r'''
query  getWorks {
  response:works {
    code
    data {
       _id
			name
      code
    }
    message
    page
    pages
  }
}
''';

String queryGetDepartmentWorktimes = r'''
query getDepartmentWorkTimes($_id: String!, $date:DateTime){
  response:department(_id: $_id)
  {
    code
    message
    data{
      _id
      name
      code
      servtime_on_date(date: $date)
    }
  }
}
''';

String queryMedicalServices = r'''
query ($page: Int, $pageSize: Int, $filtered: [FilteredInput], $sorted: [SortedInput]) {
  response: medicalServices(page: $page, pageSize: $pageSize, filtered: $filtered, sorted: $sorted) {
    code
    message
    data {
      code
      name
      _id
      categoryCode
      viewCode
      unit
      info
    }
  }
}
''';

String queryIndicationBySession = r'''
query ($code: String!) {
    response: indication_by_session(code: $code) {
      code
      message
      data {
        _id
      code
      name
      result
      state
      note
      confirmedTime
      updatedTime
      createdTime
      sessionCode
      files {
        _id
        name
      }
      service{
        code
        name
      }
			doctor{
        _id
        code
        departmentId
        departmentName
        fullName
        work
      }
      patientInfo {
        _id
        patientCode
        fullName
        phoneNumber
        address
        birthDay
        avatar
      }
      department {
        name
        code
      }
      clinic {
        code
        name
      }
      }
    }
  }
''';
