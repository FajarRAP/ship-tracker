import 'package:flutter/material.dart';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
  }

  void _toggle() => setState(() => _open = !_open);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          _buildCloseFab(),
          _buildOpenFab(),
        ],
      ),
    );
  }

  Widget _buildCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOpenFab() {
    return IgnorePointer(
      child: AnimatedContainer(
        curve: const Interval(0, .5, curve: Curves.easeOut),
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.diagonal3Values(
          _open ? .7 : 1,
          _open ? .7 : 1,
          1,
        ),
        transformAlignment: Alignment.center,
        child: AnimatedOpacity(
          curve: const Interval(.25, 1, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 300),
          opacity: _open ? 0 : 1,
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.create),
          ),
        ),
      ),
    );
  }
}
