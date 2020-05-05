classdef BinaryTree < handle
    properties
        Data
        left = BinaryTree.empty
        right = BinaryTree.empty
    end
    methods 
        function node = BinaryTree(value)
            if(nargin>0)
                node.Data = value;
            end
        end
    end
end


