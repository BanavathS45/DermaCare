import 'dart:convert';
import 'package:cutomer_app/APIs/BaseUrl.dart';
import 'package:cutomer_app/Modals/AddressModal.dart';
import 'package:cutomer_app/Modals/SaavedAddressModal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class AddAddressScreenself extends StatefulWidget {
  final String mobileNumber;
  final String username;
  final bool isLocation;

  const AddAddressScreenself({
    super.key,
    required this.mobileNumber,
    required this.username,
    required this.isLocation,
  });

  @override
  _AddAddressScreenselfState createState() => _AddAddressScreenselfState();
}

class _AddAddressScreenselfState extends State<AddAddressScreenself> {
  List<AddressModel> _filteredAddresses = [];
  List<AddressModel> _addresses = [];
  final _controller = TextEditingController();
  String? _error;
  bool _isLoading = true;
  String selectedAddress = '';
  final uuid = const Uuid();
  final bool isLocation = true;
  @override
  void initState() {
    super.initState();
    print("islocation${widget.isLocation}");
    _controller.addListener(() {
      _filterAddresses(_controller.text);
    });
    _fetchAddresses();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearSearch() {
    setState(() {
      _controller.clear();
      _filteredAddresses = _addresses;
    });
  }

  void _filterAddresses(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredAddresses = _addresses;
      });
    } else {
      setState(() {
        _filteredAddresses = _addresses.where((address) {
          return address.houseNo.toLowerCase().contains(query.toLowerCase()) ||
              address.apartment!.toLowerCase().contains(query.toLowerCase()) ||
              address.street.toLowerCase().contains(query.toLowerCase()) ||
              address.city.toLowerCase().contains(query.toLowerCase()) ||
              address.state.toLowerCase().contains(query.toLowerCase()) ||
              address.postalCode.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  Future<void> _fetchAddresses() async {
    try {
      final response = await http.get(
        Uri.parse(
            '${serverUrl}/admin/getCustomerAddresses/${widget.mobileNumber}'),
        //  Uri.parse('$baseUrl/${widget.mobileNumber}'),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        print("Addresdata ${data}");
        setState(() {
          _addresses = data.map((json) => AddressModel.fromJson(json)).toList();
          _filteredAddresses = _addresses;
          print("_filteredAddresses${_filteredAddresses}");
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load addresses');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _navigateBackWithAddress(AddressModel selectedAddress) {
    print("selectedAddress${selectedAddress}");
    Navigator.pop(
        context, selectedAddress); // Pass the SaavedAddressModal object back
  }

  _addNewAddress() {
    Navigator.pushNamed(
      context,
      "/addaddresself",
      arguments: [
        widget.mobileNumber,
        selectedAddress,
        widget.username,
        widget.isLocation
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Address  '),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Search by area, city...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      suffixIcon: _controller.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _clearSearch,
                            )
                          : const Icon(Icons.search),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.add, color: Colors.red),
                  title: const Text(
                    'Add new address',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: _addNewAddress,
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft, // Aligns text to the left
                    child: Text(
                      "Saved Address",
                      style: TextStyle(
                          fontSize: 16), // Customize text style as needed
                    ),
                  ),
                ),
                Expanded(
                  child: _error != null
                      ? Center(child: Text(_error!))
                      : _filteredAddresses.isEmpty
                          ? const Center(
                              child: Text('No saved addresses found'),
                            )
                          : ListView.builder(
                              itemCount: _filteredAddresses.length,
                              itemBuilder: (context, index) {
                                final address = _filteredAddresses[index];
                                return Card(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 12.0),
                                    title: Text(
                                      address.city ??
                                          'No Sublocality', // Sublocality at the top
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors
                                            .blue, // Color for sublocality
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                            height:
                                                4), // Space after sublocality

                                        // Address in the first line (up to postalCode)
                                        Text(
                                          '${address.houseNo}, ${address.apartment}, ${address.street}, ${address.city},',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87),
                                          overflow: TextOverflow
                                              .ellipsis, // Ensure it doesn't overflow if too long
                                        ),
                                        Text(
                                          '${address.state} - ${address.postalCode}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87),
                                          overflow: TextOverflow
                                              .ellipsis, // Ensure it doesn't overflow if too long
                                        ),

                                        // Optional fields (Direction and Road No.) in the second line
                                        if (address.direction != null &&
                                            address.direction!.isNotEmpty) ...[
                                          const SizedBox(
                                              height:
                                                  4), // Add space between lines
                                          Text(
                                            'Direction: ${address.direction}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                        ],

                                        if (address.houseNo != null &&
                                            address.direction!.isNotEmpty) ...[
                                          const SizedBox(
                                              height:
                                                  4), // Add space between lines
                                          Text(
                                            'Road No: ${address.houseNo}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ],
                                    ),
                                    trailing: Icon(
                                      Icons.location_on, // Icon for location
                                      color: Colors.blueAccent,
                                    ),
                                    onTap: () {
                                      // final selectedAddress =
                                      //     '${address.houseNo}, ${address.apartment}, ${address.street}, ${address.city}, ${address.state} - ${address.postalCode}';
                                      // _navigateBackWithAddress(selectedAddress);

                                      _navigateBackWithAddress(
                                          address); // Send the entire SaavedAddressModal object
                                    },
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
    );
  }
}
