import 'package:flutter/material.dart';
import '../data/railway_data.dart';

// Special "Other" office
final RailwayOffice otherOffice = RailwayOffice(
  designation: 'Other',
  office: '',
  zone: 'OTH',
  searchKey: 'other custom manual',
);

class SearchableOfficeDropdown extends StatefulWidget {
  final RailwayOffice? selected;
  final String? customOfficeText;
  final Function(RailwayOffice, String?) onSelected;

  const SearchableOfficeDropdown({
    super.key,
    required this.selected,
    required this.onSelected,
    this.customOfficeText,
  });

  @override
  State<SearchableOfficeDropdown> createState() => _SearchableOfficeDropdownState();
}

class _SearchableOfficeDropdownState extends State<SearchableOfficeDropdown> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customController = TextEditingController();
  List<RailwayOffice> _filtered = [...railwayOffices, otherOffice];
  bool _isOpen = false;
  bool _showCustom = false;

  @override
  void initState() {
    super.initState();
    if (widget.customOfficeText != null) {
      _customController.text = widget.customOfficeText!;
      _showCustom = true;
    }
  }

  void _filter(String query) {
    final q = query.toLowerCase();
    setState(() {
      _filtered = [...railwayOffices, otherOffice]
          .where((o) => o.searchKey.contains(q) || o.office.toLowerCase().contains(q) || o.designation.toLowerCase().contains(q))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected display
        GestureDetector(
          onTap: () => setState(() => _isOpen = !_isOpen),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: widget.selected == null
                      ? Text('Select Office / Zone', style: TextStyle(color: Colors.grey.shade500))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '[${widget.selected!.zone}] ${widget.selected!.designation}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            if (widget.selected!.zone != 'OTH')
                              Text(
                                widget.selected!.office.replaceAll('\n', ', '),
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                              ),
                          ],
                        ),
                ),
                Icon(_isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              ],
            ),
          ),
        ),

        // Dropdown panel
        if (_isOpen)
          Container(
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search by zone, city, NCR, NR...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    ),
                    onChanged: _filter,
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (ctx, i) {
                      final office = _filtered[i];
                      final isOther = office.zone == 'OTH';
                      final isSelected = widget.selected == office;
                      return ListTile(
                        dense: true,
                        selected: isSelected,
                        selectedTileColor: Colors.blue.shade50,
                        leading: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isOther ? Colors.orange.shade100 : Colors.indigo.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            office.zone,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isOther ? Colors.orange.shade800 : Colors.indigo,
                            ),
                          ),
                        ),
                        title: Text(
                          isOther ? 'Other (Type manually)' : office.designation,
                          style: TextStyle(
                            fontSize: 11,
                            color: isOther ? Colors.orange.shade800 : Colors.black,
                          ),
                        ),
                        subtitle: isOther
                            ? null
                            : Text(office.office.replaceAll('\n', ', '), style: const TextStyle(fontSize: 10)),
                        onTap: () {
                          widget.onSelected(office, null);
                          _searchController.clear();
                          _filter('');
                          setState(() {
                            _isOpen = false;
                            _showCustom = isOther;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

        // Custom text box for "Other"
        if (_showCustom && widget.selected?.zone == 'OTH')
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextField(
              controller: _customController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Enter full address',
                hintText: 'Designation\nOffice Name\nCity',
                filled: true,
                fillColor: Colors.orange.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.all(12),
              ),
              onChanged: (val) {
                widget.onSelected(otherOffice, val);
              },
            ),
          ),
      ],
    );
  }
}
