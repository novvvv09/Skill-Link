import 'package:flutter/material.dart';

/// Accordion Widget - A collapsible/expandable panel component
class AccordionWidget extends StatelessWidget {
  final List<AccordionItem> items;
  final bool allowMultipleExpanded;
  final List<int>? initiallyExpandedIndexes;

  const AccordionWidget({
    Key? key,
    required this.items,
    this.allowMultipleExpanded = false,
    this.initiallyExpandedIndexes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (allowMultipleExpanded) {
      return _MultiAccordion(
        items: items,
        initiallyExpandedIndexes: initiallyExpandedIndexes,
      );
    } else {
      return _SingleAccordion(
        items: items,
        initiallyExpandedIndex: initiallyExpandedIndexes?.first,
      );
    }
  }
}

/// Single Accordion - Only one item can be expanded at a time
class _SingleAccordion extends StatefulWidget {
  final List<AccordionItem> items;
  final int? initiallyExpandedIndex;

  const _SingleAccordion({required this.items, this.initiallyExpandedIndex});

  @override
  State<_SingleAccordion> createState() => _SingleAccordionState();
}

class _SingleAccordionState extends State<_SingleAccordion> {
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _expandedIndex = widget.initiallyExpandedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.items.length, (index) {
        final item = widget.items[index];
        final isExpanded = _expandedIndex == index;
        final isLast = index == widget.items.length - 1;

        return AccordionItemWidget(
          title: item.title,
          content: item.content,
          isExpanded: isExpanded,
          isLast: isLast,
          onToggle: () {
            setState(() {
              _expandedIndex = isExpanded ? null : index;
            });
          },
        );
      }),
    );
  }
}

/// Multi Accordion - Multiple items can be expanded simultaneously
class _MultiAccordion extends StatefulWidget {
  final List<AccordionItem> items;
  final List<int>? initiallyExpandedIndexes;

  const _MultiAccordion({required this.items, this.initiallyExpandedIndexes});

  @override
  State<_MultiAccordion> createState() => _MultiAccordionState();
}

class _MultiAccordionState extends State<_MultiAccordion> {
  late Set<int> _expandedIndexes;

  @override
  void initState() {
    super.initState();
    _expandedIndexes = widget.initiallyExpandedIndexes?.toSet() ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.items.length, (index) {
        final item = widget.items[index];
        final isExpanded = _expandedIndexes.contains(index);
        final isLast = index == widget.items.length - 1;

        return AccordionItemWidget(
          title: item.title,
          content: item.content,
          isExpanded: isExpanded,
          isLast: isLast,
          onToggle: () {
            setState(() {
              if (isExpanded) {
                _expandedIndexes.remove(index);
              } else {
                _expandedIndexes.add(index);
              }
            });
          },
        );
      }),
    );
  }
}

/// Individual Accordion Item Widget
class AccordionItemWidget extends StatelessWidget {
  final Widget title;
  final Widget content;
  final bool isExpanded;
  final bool isLast;
  final VoidCallback onToggle;

  const AccordionItemWidget({
    Key? key,
    required this.title,
    required this.content,
    required this.isExpanded,
    required this.isLast,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isLast ? Colors.transparent : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trigger/Header
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF111827),
                      ),
                      child: title,
                    ),
                  ),
                  const SizedBox(width: 16),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
                child: content,
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}

/// Accordion Item Model
class AccordionItem {
  final Widget title;
  final Widget content;

  const AccordionItem({required this.title, required this.content});
}

// Example Usage
class AccordionExample extends StatelessWidget {
  const AccordionExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accordion Example')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Single Accordion Example
            const Text(
              'Single Accordion (Only one open at a time)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AccordionWidget(
              allowMultipleExpanded: false,
              initiallyExpandedIndexes: [0],
              items: [
                AccordionItem(
                  title: const Text('What is Flutter?'),
                  content: const Text(
                    'Flutter is an open-source UI software development kit created by Google. '
                    'It is used to develop cross-platform applications for Android, iOS, Linux, macOS, Windows, Google Fuchsia, and the web from a single codebase.',
                  ),
                ),
                AccordionItem(
                  title: const Text('What is Dart?'),
                  content: const Text(
                    'Dart is a client-optimized programming language for fast apps on any platform. '
                    'It is developed by Google and is used to build mobile, desktop, server, and web applications.',
                  ),
                ),
                AccordionItem(
                  title: const Text('What is a Widget?'),
                  content: const Text(
                    'Widgets are the basic building blocks of a Flutter app\'s user interface. '
                    'Each widget is an immutable declaration of part of the user interface. '
                    'Widgets form a hierarchy based on composition.',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Multi Accordion Example
            const Text(
              'Multi Accordion (Multiple can be open)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AccordionWidget(
              allowMultipleExpanded: true,
              items: [
                AccordionItem(
                  title: Row(
                    children: [
                      const Icon(
                        Icons.school,
                        size: 20,
                        color: Color(0xFF3B82F6),
                      ),
                      const SizedBox(width: 8),
                      const Text('Events'),
                    ],
                  ),
                  content: const Text(
                    'Browse and register for upcoming tech events, workshops, and seminars.',
                  ),
                ),
                AccordionItem(
                  title: Row(
                    children: [
                      const Icon(
                        Icons.code,
                        size: 20,
                        color: Color(0xFF9333EA),
                      ),
                      const SizedBox(width: 8),
                      const Text('Projects'),
                    ],
                  ),
                  content: const Text(
                    'Showcase your projects and discover amazing work from other students.',
                  ),
                ),
                AccordionItem(
                  title: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 20,
                        color: Color(0xFF10B981),
                      ),
                      const SizedBox(width: 8),
                      const Text('Profile'),
                    ],
                  ),
                  content: const Text(
                    'Manage your account, view your achievements, and customize your preferences.',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
