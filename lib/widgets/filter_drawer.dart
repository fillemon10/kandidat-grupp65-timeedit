import 'package:flutter/material.dart';

class FilterDrawer extends StatefulWidget {
  const FilterDrawer({Key? key}) : super(key: key);

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  Map<String, dynamic> initialFilters = {
    'Building': <String>{'All Buildings'},
    'Price Range': RangeValues(20, 100),
    'Color': <Color>{},
    'Brand': null,
  };
  Map<String, dynamic> filters = {
    'Building': <String>{'All Buildings'},
    'Price Range': RangeValues(20, 100),
    'Color': <Color>{},
    'Brand': null,
  };

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 45),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton.tonal(
                onPressed: filters.values.any((value) => value != null)
                    ? () {
                        setState(() {
                          filters = _deepCopyFilters(initialFilters);
                        });
                      }
                    : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Important for centering
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 5), // Small spacing
                    Text(
                      'Reset All',
                      style: TextStyle(),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          ..._buildFilterSections(filters),
        ],
      ),
    );
  }

  Map<String, dynamic> _deepCopyFilters(Map<String, dynamic> filters) {
    final copy = Map<String, dynamic>.from(filters);
    copy.forEach((key, value) {
      if (value is Set) {
        copy[key] = Set.from(value);
      } else if (value is RangeValues) {
        copy[key] = RangeValues(value.start, value.end);
      }
    });
    return copy;
  }

  List<Widget> _buildFilterSections(Map<String, dynamic> filters) {
    return [
      _buildBuildingFilter(filters),
      Divider(),
      SizedBox(height: 8),
      _buildAnemitiesFilter(filters),
      Divider(),
      SizedBox(height: 8),
      _buildSeatsFilter(filters),
      Divider(),
      SizedBox(height: 8),
      _buildSharedFilter(filters),
      Divider(),
    ];
  }

  // --- Filter Section Widgets ---
  Widget _buildBuildingFilter(Map<String, dynamic> filters) {
    List<String> buildings = [
      'Bibliteket',
      'Maskin',
      'Edit',
      'Vasa',
      'Fysik',
      'Jupiter',
      'SB 1',
      'SB 2',
      'Kemi',
      'Kuggen',
      'Kårhuset',
    ];

    //make filterChips
    List<Widget> filterChips = [];
    for (var building in buildings) {
      filterChips.add(
        FilterChip(
          label: Text(building),
          selected: filters['Building'] != null &&
              filters['Building'].contains(building),
          onSelected: (value) {
            setState(() {
              if (value) {
                if (filters['Building'] == null) {
                  filters['Building'] = <String>{};
                }
                filters['Building'].add(building);
              } else {
                filters['Building'].remove(building);
              }
            });
          },
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          tilePadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10), // Remove default padding

          shape: Border.all(color: Colors.transparent),
          initiallyExpanded: true,
          title: Row(
            children: [
              Icon(Icons.apartment),
              SizedBox(width: 8),
              const Text(
                'Buildings',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          children: [
            Wrap(
              // align with start from left to right
              alignment: WrapAlignment.start,
              spacing: 6,
              children: [
                ...buildings
                    .map((building) => FilterChip(
                          // Non-"All Buildings" chips
                          label: Text(building),
                          selected: filters['Building'] != null &&
                              filters['Building'].contains(building),
                          onSelected: (value) {
                            setState(() {
                              if (value) {
                                filters['Building'].add(building);
                                if (filters['Building']
                                    .contains('All Buildings')) {
                                  filters['Building'].remove('All Buildings');
                                }
                              } else {
                                filters['Building'].remove(building);
                              }
                            });
                          },
                        ))
                    .toList(),
                FilterChip(
                  // "All Buildings" chip
                  label: Text('All Buildings'),
                  selected: filters['Building'] != null &&
                      filters['Building'].contains('All Buildings'),
                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        filters['Building'] = <String>{
                          'All Buildings'
                        }; // Clear other selections
                      } else {
                        filters['Building'].remove('All Buildings');
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnemitiesFilter(Map<String, dynamic> filters) {
    RangeValues _currentRange = RangeValues(20, 100); // Default

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Price Range'),
        SizedBox(height: 8),
        RangeSlider(
          values: _currentRange,
          min: 0,
          max: 500,
          onChanged: (newRange) {
            setState(() {
              _currentRange = newRange;
              filters['Price Range'] = _currentRange;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSeatsFilter(Map<String, dynamic> filters) {
    List<Color> colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color'),
        SizedBox(height: 8),
        Wrap(
          children: [
            for (var color in colors)
              FilterChip(
                selectedColor: color,
                label: Container(), // Empty label, color is the indicator
                selected: filters['Color'] != null &&
                    filters['Color'].contains(color),
                onSelected: (value) {
                  setState(() {
                    if (value) {
                      filters['Color'].add(color);
                    } else {
                      filters['Color'].remove(color);
                    }
                  });
                },
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSharedFilter(Map<String, dynamic> filters) {
    List<String> brands = ['Nike', 'Adidas', 'Puma', 'Reebok'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Brand'),
        SizedBox(height: 8),
        for (var brand in brands)
          RadioListTile(
            title: Text(brand),
            value: brand,
            groupValue: filters['Brand'],
            onChanged: (value) {
              setState(() {
                filters['Brand'] = value;
              });
            },
          ),
      ],
    );
  }
}
