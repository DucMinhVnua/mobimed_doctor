
String queryGetNationalitys = r'''
query  getNationalitys($page: Int!, $sorted: [SortedInput], $filtered: [FilteredInput]) {
  response:nationalitys(page: $page, sorted: $sorted, filtered: $filtered) {
    code
    data {
       _id
			name
      code
      __typename
    }
    message
    page
    pages
  }
}
''';

String queryGetProvinces = r'''
query  getProvinces($page: Int!, $sorted: [SortedInput], $filtered: [FilteredInput]) {
  response:provinces(page: $page, sorted: $sorted, filtered: $filtered) {
    code
    data {
       _id
			name
      code
      __typename
    }
    message
    page
    pages
  }
}
''';
String queryGetDistricts = r'''
query  getDistricts($page: Int!, $sorted: [SortedInput], $filtered: [FilteredInput]) {
  response:districts(page: $page, sorted: $sorted, filtered: $filtered) {
    code
    data {
       _id
			name
      code
      __typename
      provinceCode
      province{
        _id
        name
        code
      }
    }
    message
    page
    pages
  }
}
''';
String queryGetWards = r'''
query  getWards($page: Int!, $sorted: [SortedInput], $filtered: [FilteredInput]) {
  response:wards(page: $page, sorted: $sorted, filtered: $filtered) {
    code
    data {
       _id
			name
      code
      __typename
      districtCode
      provinceCode
      district{
        _id
        name
        provinceCode
      }
      province{
        _id
        name
        code
      }
    }
    message
    page
    pages
  }
}
''';
String queryGetNations = r'''
query  getNations($page: Int!, $sorted: [SortedInput], $filtered: [FilteredInput]) {
  response:nations(page: $page, sorted: $sorted, filtered: $filtered) {
    code
    data {
       _id
			name
      code
      __typename
    }
    message
    page
    pages
  }
}
''';
