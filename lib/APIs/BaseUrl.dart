// String serverUrl = 'http://alb-dev-sc-197990416.ap-south-1.elb.amazonaws.com/api';
const String wifiUrl = "192.168.1.27";
const String serverUrl = "http://${wifiUrl}:9090/api";
const String baseUrl = '$serverUrl/customers';
const String consultationUrl =
    "http://${wifiUrl}:8083/api/customer/getAllConsultations";
const String registerUrl = 'http://${wifiUrl}:8083/api/customer';
const String categoryUrl = 'http://${wifiUrl}:8081/admin/getCategories';
// const String categoryUrl =
//     'http://${wifiUrl}:8800/api/v1/category/getCategories';

const String getServiceByCategoriesID =
    'http://${wifiUrl}:8800/api/v1/services/getServices';

    const String getSubServiceByServiceID =
    'http://${wifiUrl}:8800/api/v1/subServices/getSubServicesByServiceId';

const String getCustomer =
    '$baseUrl/getCustomer'; //http://localhost:8083/api/customer/getBasicDetails/${mobileNumber}
const String BookingUrl = 'http://$wifiUrl:3000/bookings'; //
const String GetBookings = 'http://$wifiUrl:3000/bookings?mobileNumber';
