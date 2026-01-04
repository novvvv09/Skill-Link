import 'package:flutter/material.dart';

/// MAIN NAVIGATION MENU
class NavigationMenu extends StatelessWidget {
  final List<NavigationMenuItemData> items;

  const NavigationMenu({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: items.map((item) {
        return NavigationMenuItem(item: item);
      }).toList(),
    );
  }
}

/// SINGLE MENU ITEM WITH DROPDOWN
class NavigationMenuItem extends StatefulWidget {
  final NavigationMenuItemData item;

  const NavigationMenuItem({super.key, required this.item});

  @override
  State<NavigationMenuItem> createState() => _NavigationMenuItemState();
}

class _NavigationMenuItemState extends State<NavigationMenuItem> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleMenu() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    _overlayEntry = _createOverlay();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isOpen = false);
  }

  OverlayEntry _createOverlay() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 220,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(0, 40),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.item.children.map((child) {
                return ListTile(
                  dense: true,
                  title: Text(child.label),
                  leading: child.icon != null
                      ? Icon(child.icon, size: 18)
                      : null,
                  onTap: () {
                    _closeMenu();
                    child.onTap?.call();
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextButton(
        onPressed: _toggleMenu,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          children: [
            Text(widget.item.label),
            const SizedBox(width: 4),
            AnimatedRotation(
              turns: _isOpen ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.expand_more, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

/// DATA MODELS (Equivalent to TS props)
class NavigationMenuItemData {
  final String label;
  final List<NavigationMenuLinkData> children;

  NavigationMenuItemData({required this.label, required this.children});
}

class NavigationMenuLinkData {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  NavigationMenuLinkData({required this.label, this.icon, this.onTap});
}
