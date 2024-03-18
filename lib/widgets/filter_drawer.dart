import 'package:flutter/material.dart';

class FilterDrawer extends StatefulWidget {
  const FilterDrawer({Key? key}) : super(key: key);

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  Map<String, dynamic> filters = {
    'Category': null,
    'Price Range': null,
    'Color': null,
    'Brand': null,
  };

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 57),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton.tonal(
                onPressed: filters.isEmpty
                    ? null
                    : () {
                        setState(() {
                          filters.clear();
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: filters.isEmpty
                      ? Colors.grey
                      : Theme.of(context).primaryColor,
                ),
                child: Text(
                  'Reset All',
                  style: TextStyle(
                    color: filters.isEmpty ? Colors.grey : Colors.white,
                  ),
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

  List<Widget> _buildFilterSections(Map<String, dynamic> filters) {
    return [
      _buildCategoryFilter(filters),
      Divider(),
      SizedBox(height: 8),
      _buildPriceRangeFilter(filters),
      Divider(),
      SizedBox(height: 8),
      _buildColorFilter(filters),
      Divider(),
      SizedBox(height: 8),
      _buildBrandFilter(filters),
      Divider(),
    ];
  }

  // --- Filter Section Widgets ---
  Widget _buildCategoryFilter(Map<String, dynamic> filters) {
    List<String> categories = ['Shoes', 'Shirts', 'Pants', 'Hats'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category'),
        SizedBox(height: 8),
        for (var category in categories)
          RadioListTile(
            title: Text(category),
            value: category,
            groupValue: filters['Category'],
            onChanged: (value) {
              setState(() {
                filters['Category'] = value;
              });
            },
          ),
      ],
    );
  }

  Widget _buildPriceRangeFilter(Map<String, dynamic> filters) {
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

  Widget _buildColorFilter(Map<String, dynamic> filters) {
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

  Widget _buildBrandFilter(Map<String, dynamic> filters) {
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
