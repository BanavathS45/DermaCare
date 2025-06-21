// String serverUrl = 'http://alb-dev-sc-197990416.ap-south-1.elb.amazonaws.com/api';
const String wifiUrl = "43.204.22.89:9090";
// const String serverUrl = "http://${wifiUrl}:9090/api";
const String serverUrl = "http://${wifiUrl}/api";
// http://localhost:8083/api/customer/registerOrLogin
const String clinicUrl = "http://${wifiUrl}/clinic-admin";
const String baseUrl = '$serverUrl/customers';
const String consultationUrl =
    "http://${wifiUrl}/api/customer/getAllConsultations";
const String registerUrl = 'http://${wifiUrl}/api/customer';
const String categoryUrl = 'http://${wifiUrl}/admin/getCategories';
// const String categoryUrl =
//     'http://${wifiUrl}:8800/api/v1/category/getCategories';

const String getServiceByCategoriesID =
    'http://${wifiUrl}/admin/getServiceById';

const String getSubServiceByServiceID =
    'http://${wifiUrl}/admin/getSubServicesByServiceId';
const String getSubServiceByServiceIDHospitalID =
    'http://${wifiUrl}/clinic-admin/getSubService';

const String getCustomer =
    '$baseUrl/getCustomer'; //http://localhost:8083/api/customer/getBasicDetails/${mobileNumber}
// const String BookingUrl = 'http://$wifiUrl:3000/bookings';
const String BookingUrl = '${registerUrl}/bookService';
// http://localhost:8083/api/customer/bookService
// const String GetBookings = 'http://$wifiUrl:3000/bookings?mobileNumber';
