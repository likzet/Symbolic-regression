function [subTree, newTree] = selectSubTree(tree, rootNode)
  %selectSubTree selects subtree in model tree with root is in the k-th rootNode
  %
  % [subTree, newTree] = selSubTree(tree, rootNode)
  %
  % output variables:
  % subTree - nodes from model in subtree
  % newTree - new tree from this subtree
  %
  % input variables:
  % tree - initial tree
  % rootNode - root of new tree

  subTree = rootNode;
  newTree = 0;
  j = 1;
  while j < (size(subTree, 2) + 1)
    subTree = [subTree, find(tree == subTree(j))];  
    newTree = [newTree, j * ones(1, size(find(tree == subTree(j)), 2))];
    j = j + 1;
  end 

end

