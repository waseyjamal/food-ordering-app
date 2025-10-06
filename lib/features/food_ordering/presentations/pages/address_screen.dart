import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_ordering_app/core/utils/responsive_utils.dart';
import 'package:food_ordering_app/app/routes.dart';
import '../blocs/address_bloc/address_bloc.dart';
import '../blocs/address_bloc/address_event.dart';
import '../blocs/address_bloc/address_state.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _houseController = TextEditingController();
  final _areaController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  String _selectedType = 'home';

  @override
  void initState() {
    super.initState();
    // 🎯 DISPATCH EVENT: Load addresses when screen starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressBloc>().add(LoadAddressesEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Delivery Address'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<AddressBloc, AddressState>(
        // 👂 LISTENER: Handle address added success
        listener: (context, state) {
          if (state is AddressAdded) {
            // ✅ Address added successfully - navigate to payment
            Navigator.pushNamed(context, AppRoutes.payment);
          }
        },
        // 👀 BUILDER: Build UI based on state
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(
              ResponsiveUtils.getResponsivePadding(context),
            ),
            child: _buildContent(context, state),
          );
        },
      ),
    );
  }

  // 🎯 METHOD: Build different UI based on state
  Widget _buildContent(BuildContext context, AddressState state) {
    if (state is AddressInitial || state is AddressLoading) {
      return _buildLoadingState();
    } else if (state is AddressLoaded) {
      return _buildAddressForm(context, state);
    } else if (state is AddressError) {
      return _buildErrorState(context, state);
    }
    return const SizedBox();
  }

  // ⏳ UI STATE 1: Loading
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading addresses...'),
        ],
      ),
    );
  }

  // ✅ UI STATE 2: Address Form (Main UI)
  Widget _buildAddressForm(BuildContext context, AddressLoaded state) {
    return ListView(
      children: [
        // 🏠 Header
        _buildHeader(),
        const SizedBox(height: 24),

        // 📍 Saved Addresses (if any)
        if (state.addresses.isNotEmpty) ...[
          _buildSavedAddresses(context, state),
          const SizedBox(height: 24),
        ],

        // ➕ Add New Address Form
        _buildAddAddressForm(context),
      ],
    );
  }

  // 🏠 WIDGET: Header
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Where should we deliver?',
          style: TextStyle(
            fontSize: ResponsiveUtils.isMobile(context) ? 20 : 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose a saved address or add a new one',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  // 📍 WIDGET: Saved Addresses List
  Widget _buildSavedAddresses(BuildContext context, AddressLoaded state) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saved Addresses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...state.addresses.map(
              (address) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(
                    _getAddressTypeIcon(address.type),
                    color: Colors.deepPurple,
                  ),
                  title: Text(
                    address.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(address.fullAddress),
                  trailing: address.isDefault
                      ? const Chip(
                          label: Text('Default'),
                          backgroundColor: Colors.deepPurple,
                          labelStyle: TextStyle(color: Colors.white),
                        )
                      : null,
                  onTap: () {
                    // 🎯 DISPATCH EVENT: Set as default address
                    context.read<AddressBloc>().add(
                      SetDefaultAddressEvent(address.id),
                    );
                    // Navigate to payment with selected address
                    Navigator.pushNamed(context, AppRoutes.payment);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ➕ WIDGET: Add New Address Form
  Widget _buildAddAddressForm(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // 👤 Personal Details
              _buildPersonalDetailsSection(),
              const SizedBox(height: 16),

              // 🏠 Address Details
              _buildAddressDetailsSection(),
              const SizedBox(height: 16),

              // 📍 Address Type
              _buildAddressTypeSection(),
              const SizedBox(height: 24),

              // ✅ Save Address Button
              _buildSaveAddressButton(),
            ],
          ),
        ),
      ),
    );
  }

  // 👤 WIDGET: Personal Details Section
  // 👤 WIDGET: Personal Details Section - FIXED RESPONSIVE
  Widget _buildPersonalDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),

        // Name Field
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ), // ✅ FIXED
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),

        // Phone Field
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ), // ✅ FIXED
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.length != 10) {
              return 'Please enter a valid 10-digit number';
            }
            return null;
          },
        ),
      ],
    );
  }

  // 🏠 WIDGET: Address Details Section
  // 🏠 WIDGET: Address Details Section - FIXED RESPONSIVE
  Widget _buildAddressDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),

        // House Field
        TextFormField(
          controller: _houseController,
          decoration: const InputDecoration(
            labelText: 'House/Flat No., Building',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.home),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ), // ✅ FIXED
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter house details';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),

        // Area Field
        TextFormField(
          controller: _areaController,
          decoration: const InputDecoration(
            labelText: 'Area, Street, Sector',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.place),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ), // ✅ FIXED
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter area details';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),

        // Landmark Field
        TextFormField(
          controller: _landmarkController,
          decoration: const InputDecoration(
            labelText: 'Landmark (Optional)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.flag),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ), // ✅ FIXED
          ),
        ),
        const SizedBox(height: 12),

        // City and Pincode - RESPONSIVE ROW
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = ResponsiveUtils.isMobile(context);

            if (isMobile) {
              // 📱 MOBILE: Stack vertically
              return Column(
                children: [
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_city),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter city';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _pincodeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Pincode',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter pincode';
                      }
                      if (value.length != 6) {
                        return 'Please enter valid pincode';
                      }
                      return null;
                    },
                  ),
                ],
              );
            } else {
              // 💻 TABLET/DESKTOP: Side by side
              return Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_city),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter city';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _pincodeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Pincode',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.numbers),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter pincode';
                        }
                        if (value.length != 6) {
                          return 'Please enter valid pincode';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  // 📍 WIDGET: Address Type Section
  // 📍 WIDGET: Address Type Section - FIXED RESPONSIVE
  Widget _buildAddressTypeSection() {
    final addressTypes = [
      {'type': 'home', 'label': 'Home', 'icon': Icons.home},
      {'type': 'work', 'label': 'Work', 'icon': Icons.work},
      {'type': 'other', 'label': 'Other', 'icon': Icons.place},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),

        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = ResponsiveUtils.isMobile(context);

            if (isMobile) {
              // 📱 MOBILE: Wrap chips
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: addressTypes.map((addressType) {
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(addressType['icon'] as IconData, size: 16),
                        const SizedBox(width: 4),
                        Text(addressType['label'] as String),
                      ],
                    ),
                    selected: _selectedType == addressType['type'],
                    onSelected: (selected) {
                      setState(() {
                        _selectedType = addressType['type'] as String;
                      });
                    },
                  );
                }).toList(),
              );
            } else {
              // 💻 TABLET/DESKTOP: Row layout
              return Row(
                children: addressTypes.map((addressType) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(addressType['icon'] as IconData, size: 16),
                            const SizedBox(width: 4),
                            Text(addressType['label'] as String),
                          ],
                        ),
                        selected: _selectedType == addressType['type'],
                        onSelected: (selected) {
                          setState(() {
                            _selectedType = addressType['type'] as String;
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ],
    );
  }

  // ✅ WIDGET: Save Address Button
  Widget _buildSaveAddressButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // 🎯 DISPATCH EVENT: Add new address
            context.read<AddressBloc>().add(
              AddAddressEvent(
                name: _nameController.text,
                phone: _phoneController.text,
                house: _houseController.text,
                area: _areaController.text,
                landmark: _landmarkController.text,
                city: _cityController.text,
                pincode: _pincodeController.text,
                type: _selectedType,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Save Address & Continue',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // 🏠 HELPER: Get icon for address type
  IconData _getAddressTypeIcon(String type) {
    switch (type) {
      case 'home':
        return Icons.home;
      case 'work':
        return Icons.work;
      case 'other':
        return Icons.place;
      default:
        return Icons.home;
    }
  }

  // ❌ UI STATE 3: Error
  Widget _buildErrorState(BuildContext context, AddressError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Address Error',
            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            state.message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // 🎯 DISPATCH EVENT: Retry loading
              context.read<AddressBloc>().add(LoadAddressesEvent());
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _houseController.dispose();
    _areaController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }
}
