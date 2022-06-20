String mutationUpdatePatient = r'''
mutation updatePatient($data: UserInput!) {
  response: update_patient(data: $data) {
    code
    message
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
String mutationCreateAppointmentOffline = r'''
mutation createAppointmentOffline(
  $patientCode: String!
  $reason: String = null
) {
  response: create_appointment_offline(
    patientCode: $patientCode
    reason: $reason
  ) {
    code
    message
    data {
      patientCode
      note
      state
      channel
      followByDoctor
      appointmentDate
      appointmentTime
      service {
        code
        name
      }
      doctorId
      departmentId
      department {
        _id
        name
        code
        description
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
      approver {
        _id
        fullName
        code
      }
    }
  }
}
''';

String mutationRegister = r'''
mutation register($userName: String!, $fullName: String!, $phoneNumber: String!,
  $password: String!, $gender: String!, $birthday: String!, $email: String!) {
  response: register(userName: $userName, fullName: $fullName, phoneNumber: $phoneNumber
  , password: $password, gender: $gender, birthday: $birthday, email: $email) {
    code
    message
    data 
  }
}
''';

String mutationUdateProfile = r'''
mutation updateProfile($account: RootAccountInput!) {
  response: updateProfile(account: $account) {
    code
    message
    data {
      _id
      fullName
      code
      avatar
      address
      phoneNumber
      email
      birthday
      work
      role
      department{
        _id
        name
      }
    }
  }
}
''';

String mutationUploadFile = r'''
  mutation uploadFile($file: FileUploadInput !) {
  response: uploadFile(file: $file) {
    code
    message
    data 
  }
}
''';
String mutationUpFile = r'''
  mutation upFile($file:FileUploadInput){
  response:uploadFile(file:$file){
    code
    message
  	data
  }
}
''';

String mutationChangePassword = r'''
mutation changePassword ($old_password: String!, $new_password: String!) {
  response:change_password (old_password: $old_password, new_password:$new_password) {
    code
    message
    data 
  }
}
''';

String mutationCreateAppointment = r'''
mutation createAppointment($data: AppointmentDataInput!) {
  response: createAppointment(data: $data) {
    code
    message
    data {
      _id
      note
      appointmentDate
      appointmentTime
      patientCode
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
        patientCode
        fullName
        phoneNumber
        address
        birthDay
        avatar
      }
      inputPatient {
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
  }
}
''';

String mutationChangeAppointmentState = r'''
mutation changeAppointmentState ($_id: String!, $terminateReason: String = null, $state: AppointmentState  = null) {
  response:changeAppointmentState (_id: $_id, terminateReason:$terminateReason,  state:$state) {
    code
    message
    data 
  }
}
''';

String mutationCreateConclusion = r'''
mutation ($sessionId: String!, $data: CodeBaseInput) {
  response: update_medical_session_conclusion(sessionId: $sessionId, data: $data) {
    code
    message
    data {
      code
      name
    }
  }
}
''';
String mutationImageConclusion = r'''
mutation ($sessionId: String!, $fileIds: [String]) {
  response: update_medical_session_conclusion(sessionId: $sessionId, fileIds: $fileIds) {
    code
    message
    data {
      code
      name
    }
  }
}
''';
String mutationDeleteConclusion = r'''
mutation ($sessionId: String!, $code: String!) {
  response: remove_medical_conclusion(sessionId: $sessionId, code: $code) {
    code
    message
  }
}
''';
String mutationUpdateConclusion = r'''
mutation ($sessionId: String!, $data: CodeBaseInput) {
  response: update_medical_session_conclusion(sessionId: $sessionId, data: $data) {
    code
    message
    data {
      code
      name
    }
  }
}
''';
String mutationCreateIndication = r'''
mutation create_indication($data: IndicationInput) {
    response: create_indication(data: $data) {
      code
      message
    }
  }
''';

String mutationTerminateIndication = r'''
mutation terminate_indication($_id: String!, $reason: String) {
    response: terminate_indication(_id: $_id, reason: $reason) {
      code
      message
    }
  }
''';

String mutationConfirmIndication = r'''
mutation($_id: String!){
    response: confirm_indication(_id: $_id){
      code
      message
    }
  }
''';

String mutationUploadFileImage = r'''
mutation($file:FileUploadInput){
  response:uploadFile(file:$file){
    code
    message
  	data
  }
}
''';
String mutationUpdateIndicationResult = r'''
mutation ($_id: String!, $result: String!, $fileIds: [String]) {
  response: update_indication_result(_id: $_id, result: $result, fileIds: $fileIds) {
    code
    message
  }
}
''';
String mutationUpdateMedicalSessionWaiting = r'''
mutation($code: String!){
    response: update_medical_session_waiting(code: $code){
      code
      message
    }
  }
''';
String mutationUpdateMedicalSessionConclusion = r'''
mutation($data: MedicalConclusionInput){
    response: update_medical_session_conclusion(data: $data){
      code
      message
      data{
        name
        note
        main
        _id
        sessionCode
        createdTime
        updatedTime
      }
    }
  }
''';
