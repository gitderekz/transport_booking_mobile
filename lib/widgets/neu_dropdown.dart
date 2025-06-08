// lib/widgets/neu_dropdown.dart
import 'package:flutter/material.dart';
import 'package:transport_booking/models/stop.dart';
import 'package:transport_booking/widgets/glass_card.dart';

class NeuDropdown<T> extends StatelessWidget {
  final T? value;
  final String? hint;
  final List<DropdownMenuItem<T>>? items;
  final ValueChanged<T?>? onChanged;
  final IconData? icon;
  final double borderRadius;

  const NeuDropdown({
    super.key,
    this.value,
    this.hint,
    this.items,
    this.onChanged,
    this.icon,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonFormField<T>(
          value: value,
          hint: hint != null
              ? Text(
            hint!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          )
              : null,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: icon != null
                ? Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            )
                : null,
          ),
          style: Theme.of(context).textTheme.bodyLarge,
          dropdownColor: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(borderRadius),
          icon: Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}





class SearchableDropdown<T> extends StatefulWidget {
  final T? value;
  final String? hint;
  final List<DropdownMenuItem<T>>? items;
  final ValueChanged<T?>? onChanged;
  final IconData? icon;
  final double borderRadius;
  final bool isSearchable;

  const SearchableDropdown({
    super.key,
    this.value,
    this.hint,
    this.items,
    this.onChanged,
    this.icon,
    this.borderRadius = 12,
    this.isSearchable = true,
  });

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();
  List<DropdownMenuItem<T>> _filteredItems = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items ?? [];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items ?? [];
      } else {
        _filteredItems = (widget.items ?? []).where((item) {
          final child = item.child;
          if (child is Text) {
            return child.data?.toLowerCase().contains(query.toLowerCase()) ?? false;
          }
          return false;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonFormField<T>(
          value: widget.value,
          hint: widget.hint != null
              ? Text(
            widget.hint!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          )
              : null,
          items: _filteredItems,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: widget.icon != null
                ? Icon(
              widget.icon,
              color: Theme.of(context).colorScheme.primary,
            )
                : null,
            suffixIcon: widget.isSearchable
                ? IconButton(
              icon: Icon(
                _isSearching ? Icons.close : Icons.search,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    _filteredItems = widget.items ?? [];
                  }
                });
              },
            )
                : null,
          ),
          style: Theme.of(context).textTheme.bodyLarge,
          dropdownColor: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          icon: Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).colorScheme.primary,
          ),
          selectedItemBuilder: (context) {
            if (_isSearching) {
              return [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                  ),
                  onChanged: _onSearchChanged,
                  autofocus: true,
                ),
              ];
            }
            return (widget.items ?? []).map((item) {
              return Align(
                alignment: Alignment.centerLeft,
                child: item.child,
              );
            }).toList();
          },
        ),
      ),
    );
  }
}




// // Create a new widget for searchable stop selection
// class StopAutocompleteField extends StatelessWidget {
//   final String hint;
//   final Stop? selectedStop;
//   final List<Stop> stops;
//   final ValueChanged<Stop?> onSelected;
//   final IconData? icon;
//   final bool enabled;
//
//   const StopAutocompleteField({
//     super.key,
//     required this.hint,
//     required this.selectedStop,
//     required this.stops,
//     required this.onSelected,
//     this.icon,
//     this.enabled = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GlassCard(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       borderRadius: 12,
//       child: Row(
//         children: [
//           if (icon != null) ...[
//             Icon(
//               icon,
//               color: Theme.of(context).colorScheme.primary,
//             ),
//             const SizedBox(width: 12),
//           ],
//           Expanded(
//             child: Autocomplete<Stop>(
//               displayStringForOption: (option) => option.stationName,
//               optionsBuilder: (TextEditingValue textEditingValue) {
//                 if (textEditingValue.text.isEmpty) {
//                   return stops;
//                 }
//                 return stops.where((stop) => stop.stationName
//                     .toLowerCase()
//                     .contains(textEditingValue.text.toLowerCase()));
//               },
//               onSelected: onSelected,
//               fieldViewBuilder: (
//                   BuildContext context,
//                   TextEditingController textEditingController,
//                   FocusNode focusNode,
//                   VoidCallback onFieldSubmitted,
//                   ) {
//                 // Initialize the text if we have a selected stop
//                 if (selectedStop != null) {
//                   textEditingController.text = selectedStop!.stationName;
//                 }
//                 return TextField(
//                   controller: textEditingController,
//                   focusNode: focusNode,
//                   decoration: InputDecoration(
//                     hintText: hint,
//                     border: InputBorder.none,
//                   ),
//                   enabled: enabled,
//                 );
//               },
//               optionsViewBuilder: (
//                   BuildContext context,
//                   AutocompleteOnSelected<Stop> onSelected,
//                   Iterable<Stop> options,
//                   ) {
//                 return Align(
//                   alignment: Alignment.topLeft,
//                   child: Material(
//                     elevation: 4.0,
//                     child: Container(
//                       constraints: const BoxConstraints(maxHeight: 200),
//                       child: ListView.builder(
//                         padding: EdgeInsets.zero,
//                         itemCount: options.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           final option = options.elementAt(index);
//                           return ListTile(
//                             title: Text(option.stationName),
//                             onTap: () {
//                               onSelected(option);
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class StopAutocompleteField extends StatefulWidget {
  final String hint;
  final Stop? selectedStop;
  final List<Stop> stops;
  final ValueChanged<Stop?> onSelected;
  final IconData? icon;
  final bool enabled;

  const StopAutocompleteField({
    super.key,
    required this.hint,
    required this.selectedStop,
    required this.stops,
    required this.onSelected,
    this.icon,
    this.enabled = true,
  });

  @override
  State<StopAutocompleteField> createState() => _StopAutocompleteFieldState();
}

class _StopAutocompleteFieldState extends State<StopAutocompleteField> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _removeOverlay();
      }
    });
    if (widget.selectedStop != null) {
      _controller.text = widget.selectedStop!.stationName;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay(Iterable<Stop> options) {
    _removeOverlay();

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 8),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.surface,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: [
                    if (options.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'No matching stations found',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      )
                    else
                      ...options.map((stop) => _buildOptionItem(stop)).toList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildOptionItem(Stop stop) {
    return InkWell(
      onTap: () {
        widget.onSelected(stop);
        _controller.text = stop.stationName;
        _focusNode.unfocus();
        _removeOverlay();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                stop.stationName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        borderRadius: 12,
        child: Row(
          children: [
            if (widget.icon != null) ...[
              Icon(
                widget.icon,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Autocomplete<Stop>(
                displayStringForOption: (option) => option.stationName,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return widget.stops;
                  }
                  return widget.stops.where((stop) => stop.stationName
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()));
                },
                onSelected: (stop) {
                  widget.onSelected(stop);
                  _controller.text = stop.stationName;
                  _focusNode.unfocus();
                  _removeOverlay();
                },
                fieldViewBuilder: (
                    BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted,
                    ) {
                  return TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      border: InputBorder.none,
                      hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                    enabled: widget.enabled,
                    onChanged: (value) {
                      if (_focusNode.hasFocus && value.isNotEmpty) {
                        final filtered = widget.stops.where((stop) => stop.stationName
                            .toLowerCase()
                            .contains(value.toLowerCase()));
                        _showOverlay(filtered);
                      } else {
                        _removeOverlay();
                      }
                    },
                    onTap: () {
                      if (_controller.text.isEmpty) {
                        _showOverlay(widget.stops);
                      }
                    },
                  );
                },
                optionsViewBuilder: (
                    BuildContext context,
                    AutocompleteOnSelected<Stop> onSelected,
                    Iterable<Stop> options,
                    ) {
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}