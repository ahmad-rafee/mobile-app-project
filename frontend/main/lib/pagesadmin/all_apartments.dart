import 'package:flutter/material.dart';
import 'package:main/apiser.dart';

class AllApartmentsPage extends StatefulWidget {
  const AllApartmentsPage({super.key});

  @override
  State<AllApartmentsPage> createState() => _AllApartmentsPageState();
}

class _AllApartmentsPageState extends State<AllApartmentsPage> {
  List<dynamic> _apartments = [];
  List<dynamic> _filteredApartments = [];
  bool _isLoading = true;
  String _filterStatus = 'all';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadApartments();
  }

  Future<void> _loadApartments() async {
    try {
      final apartments = await ApiService.getAllApartments();
      setState(() {
        _apartments = apartments;
        _filteredApartments = apartments;
        _isLoading = false;
      });
      _applyFilters();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredApartments = _apartments.where((apt) {
        final matchesStatus = _filterStatus == 'all' || apt['status'] == _filterStatus;
        final matchesSearch = _searchQuery.isEmpty ||
            (apt['title'] ?? '').toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (apt['governorate'] ?? '').toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (apt['city'] ?? '').toLowerCase().contains(_searchQuery.toLowerCase());
        return matchesStatus && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Properties'),
        backgroundColor: const Color(0xFF5E35B1),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search and Filter
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by title or location...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) {
                    _searchQuery = value;
                    _applyFilters();
                  },
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _filterChip('All', 'all'),
                      _filterChip('Pending', 'pending'),
                      _filterChip('Approved', 'approved'),
                      _filterChip('Rejected', 'rejected'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Apartment List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredApartments.isEmpty
                    ? const Center(child: Text('No properties found', style: TextStyle(fontSize: 16, color: Colors.grey)))
                    : RefreshIndicator(
                        onRefresh: _loadApartments,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredApartments.length,
                          itemBuilder: (context, index) {
                            final apartment = _filteredApartments[index];
                            return _buildApartmentCard(apartment);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final isSelected = _filterStatus == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _filterStatus = value);
          _applyFilters();
        },
        selectedColor: const Color(0xFF5E35B1).withOpacity(0.2),
        checkmarkColor: const Color(0xFF5E35B1),
      ),
    );
  }

  Widget _buildApartmentCard(dynamic apartment) {
    final title = apartment['title'] ?? 'No Title';
    final governorate = apartment['governorate'] ?? '';
    final city = apartment['city'] ?? '';
    final price = apartment['price'] ?? 0;
    final area = apartment['area'] ?? 0;
    final rooms = apartment['rooms'] ?? 0;
    final status = apartment['status'] ?? 'pending';
    final owner = apartment['owner'];
    final ownerName = owner != null ? '${owner['first_name']} ${owner['last_name']}' : 'Unknown';
    final images = apartment['images'] as List? ?? [];

    final statusColor = status == 'approved' ? Colors.green : (status == 'pending' ? Colors.orange : Colors.red);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          if (images.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                '${ApiService.storageBaseUrl}${images[0]['image_path']}',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('$governorate, $city', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('Owner: $ownerName', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _infoChip(Icons.attach_money, '\$$price/mo', Colors.green),
                    const SizedBox(width: 8),
                    _infoChip(Icons.square_foot, '${area}m²', Colors.blue),
                    const SizedBox(width: 8),
                    _infoChip(Icons.bed, '$rooms rooms', Colors.orange),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 11)),
        ],
      ),
    );
  }
}
