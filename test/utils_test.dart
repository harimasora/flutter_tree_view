import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_tree_view/src/internal.dart';

void main() {
  late TreeNode rootNode;
  late TreeNode node1;
  late TreeNode node11;
  late TreeNode node111;
  late TreeNode node12;
  late TreeNode node121;
  late TreeNode node122;
  late TreeNode node2;

  late List<TreeNode> rootSubtree;
  late List<TreeNode> node1Subtree;
  late List<TreeNode> node11Subtree;
  late List<TreeNode> node12Subtree;

  setUp(() {
    rootNode = TreeNode();
    node1 = TreeNode();
    node11 = TreeNode();
    node111 = TreeNode();
    node12 = TreeNode();
    node121 = TreeNode();
    node122 = TreeNode();
    node2 = TreeNode();

    node11.addChild(node111);
    node12.addChildren([node121, node122]);
    node1.addChildren([node11, node12]);
    rootNode.addChildren([node1, node2]);

    rootSubtree = [node1, node11, node111, node12, node121, node122, node2];
    node1Subtree = [node11, node111, node12, node121, node122];
    node11Subtree = [node111];
    node12Subtree = [node121, node122];
  });

  group('Tests for subtreeGenerator -', () {
    test(
      'Should return a list of length 7 that match rootSubtree when called with rootNode.',
      () {
        final result = subtreeGenerator(rootNode);
        expect(result, hasLength(7));
        expect(result, equals(rootSubtree));
      },
    );

    test(
      'Should return a list of length 5 that match node1Subtree when called with node1.',
      () {
        final result = subtreeGenerator(node1);
        expect(result, hasLength(5));
        expect(result, equals(node1Subtree));
      },
    );

    test(
      'Should return a list of length 1 that match node11Subtree when called with node11.',
      () {
        final result = subtreeGenerator(node11);
        expect(result, hasLength(1));
        expect(result, equals(node11Subtree));
      },
    );

    test(
      'Should return a list of length 2 that match node12Subtree when called with node12.',
      () {
        final result = subtreeGenerator(node12);
        expect(result, hasLength(2));
        expect(result, equals(node12Subtree));
      },
    );

    test(
      'Should return an empty list each when called with: node111, node121, node122, node2.',
      () {
        expect(subtreeGenerator(node111), isEmpty);

        expect(subtreeGenerator(node121), isEmpty);

        expect(subtreeGenerator(node122), isEmpty);

        expect(subtreeGenerator(node2), isEmpty);
      },
    );

    group('@param filter -', () {
      late List<TreeNode> expandedNodes;
      late List<TreeNode> collapsedNodes;
      setUp(() {
        node1.expand();
        node11.expand();
        node121.expand();
        expandedNodes = [node1, node11, node121];
        collapsedNodes = [node111, node12, node122, node2];
      });

      test(
        'Should return only expanded nodes when filter is testing for expanded nodes.',
        () {
          expect(subtreeGenerator(rootNode), equals(rootSubtree));

          final result = subtreeGenerator(rootNode, (n) => n.isExpanded);
          expect(result, isNotEmpty);
          expect(result, equals(expandedNodes));
        },
      );

      test(
        'Should return only collapsed nodes when filter is testing for collapsed nodes.',
        () {
          expect(subtreeGenerator(rootNode), equals(rootSubtree));

          final result = subtreeGenerator(rootNode, (n) => !n.isExpanded);
          expect(result, isNotEmpty);
          expect(result, equals(collapsedNodes));
        },
      );
    });
  });
}