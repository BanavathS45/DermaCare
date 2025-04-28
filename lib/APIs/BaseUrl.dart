// String serverUrl =
//     'http://alb-dev-sc-197990416.ap-south-1.elb.amazonaws.com/api';
const String wifiUrl = "192.168.1.14";
const String consultationUrl =
    "http://${wifiUrl}:8083/api/customer/getAllConsultations";
const String serverUrl = "http://${wifiUrl}:9090/api";
String baseUrl = '$serverUrl/customers';
String registerUrl = 'http://${wifiUrl}:8083/api/customer';
String categoryUrl = '$serverUrl/category/getCategories';
String getAllServiceUrl = '$serverUrl/services/getServices';
String getCustomer = '$baseUrl/getCustomer';
