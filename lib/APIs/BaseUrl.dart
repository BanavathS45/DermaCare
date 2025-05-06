// String serverUrl = 'http://alb-dev-sc-197990416.ap-south-1.elb.amazonaws.com/api';
const String wifiUrl = "192.168.0.104";
const String serverUrl = "http://${wifiUrl}:9090/api";
const String baseUrl = '$serverUrl/customers';
const String consultationUrl =
    "http://${wifiUrl}:8083/api/customer/getAllConsultations";
const String registerUrl = 'http://${wifiUrl}:8083/api/customer';
const String categoryUrl =
    'http://${wifiUrl}:8081/admin/getAllCategories'; //http://localhost:8081/admin/getAllCategories
//const String getAllServiceUrl =   'http://${wifiUrl}:8080/clinic-admin/subService/getAllSubServies'; //http://192.168.1.14:8080/clinic-admin/subService/getAllSubServies
const String getServiceByCategoriesID =
    'http://${wifiUrl}:8080/clinic-admin/category';
//http://192.168.1.14:8080/clinic-admin/category/681073fe4ab1fa262c716771

const String getCustomer =
    '$baseUrl/getCustomer'; //http://localhost:8083/api/customer/getBasicDetails/${mobileNumber}
const String BookingUrl = 'http://$wifiUrl:3000/bookings'; //
const String GetBookings = 'http://$wifiUrl:3000/bookings?mobileNumber';
