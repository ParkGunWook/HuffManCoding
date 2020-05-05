%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                      CopyRight to PARK, GUNWOOK                     %%%
%%%                                   2015113964                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

import BinaryTree
MAX_SIZE = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                            File input                               %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fileID = fopen('input1.txt', 'r');
X = fscanf(fileID, '%d %f', [2, MAX_SIZE]);
X = X';
fclose(fileID);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                         Validation Check                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
one1 = 1.0000000000001;
sum1 = sum(X,1);
if (sum1(1,2) > one1)
    fprintf('Wrong sum Probability\n')
    return
end
for i=1 : MAX_SIZE
    if(X(i,2)< 0)
        fprintf('Wrong element Probaility\n')
        return 
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                              Huffman Code                           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X = [X, nan(MAX_SIZE,1)];
Trees = BinaryTree.empty(MAX_SIZE*3,0);
Node_num = 1;
cnt = 0;
while(size(X,1) ~= 1)
    X = sortrows(X, 2, 'descend');
    % Two NaN in Last two
    if(isnan(X(size(X,1), 3)) && isnan(X(size(X,1)-1, 3))  )
        %Make one empty root
        Trees(Node_num,1) = BinaryTree(nan);
        Node_num = Node_num+1;
        %Make right Node
        Trees(Node_num,1) = BinaryTree(X(size(X,1), 1));
        X(size(X,1), 3) = Node_num-1;
        Trees(Node_num-1,1).right = Trees(Node_num,1);
        Node_num = Node_num+1;
        %Make left Node
        Trees(Node_num,1) = BinaryTree(X(size(X,1)-1, 1));
        Trees(Node_num-2,1).left = Trees(Node_num,1);
        X(size(X,1)-1, 3) = Node_num-2;
        Node_num = Node_num+1;
        %Delete and integrate Used Array row
        X(size(X,1)-1, 2) = X(size(X,1)-1, 2)+X(size(X,1), 2) ;
        X(size(X,1)-1, 1) = nan;
        X(size(X,1), :) = [];
    % One NaN in Last two
    elseif(isnan(X(size(X,1), 3)) || isnan(X(size(X,1)-1, 3)) )
        %Swap NaN position
        if(isnan(X(size(X,1)-1, 3)) )
            temp = X(size(X,1), :);
            X(size(X,1), :) = X(size(X,1)-1, :);
            X(size(X,1)-1, :) = temp;
        end
        %make one empty root
        Trees(Node_num,1) = BinaryTree(nan);
        Node_num = Node_num+1;
        %Add Right node
        Trees(Node_num-1,1).right = Trees(X(size(X,1)-1,3),1);
        Node_num = Node_num+1;
        %make Left Tree
        Trees(Node_num,1) = BinaryTree(X(size(X,1),1));
        Trees(Node_num-2,1).left = Trees(Node_num,1);
        Node_num = Node_num+1;
        %Delete and update Used Array
        X(size(X,1)-1,3) = Node_num-3;
        X(size(X,1)-1, 2) = X(size(X,1)-1, 2)+X(size(X,1), 2) ;
        X(size(X,1)-1, 1) = nan;
        X(size(X,1), :) = [];
    % No NaN in last two
    else
        %make empty root
        Trees(Node_num,1) = BinaryTree(nan);
        Node_num = Node_num+1;
        %Add Right Node
        Trees(Node_num-1,1).right = Trees(X(size(X,1)-1,3),1);
        %Add Left Node
        Trees(Node_num-1,1).left = Trees(X(size(X,1),3),1);
        %Delete Used Array
        X(size(X,1)-1,3) = Node_num-1;
        X(size(X,1)-1, 2) = X(size(X,1)-1, 2)+X(size(X,1), 2);
        X(size(X,1)-1, 1) = nan;
        X(size(X,1), :) = [];
    end
    cnt = cnt+1;
    if(cnt == 100)
        disp('100 Loop Exceed')
        break
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                             Print Tree                              %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Root_Node = Trees(X(1,3),1);
nodes = [];

huff_print(Root_Node, 0, nodes);
%Recursive Center-Right-Left Tree Traverse
function [lev, mat] = huff_print(bst,level, matrix)
    lev =0;
    mat = [];
    MaxLevel=0;
    if(isempty(bst))
        MaxLevel = level;
    else
        level = level+1;
        mat = [matrix 1];
        [lev, mat] = huff_print(bst.right,level, mat);
        if(lev > MaxLevel ) 
            MaxLevel = lev;
        end
        
        nprint = (3+1)*(level-1);
        for i1=0 : nprint
            fprintf(' ');
        end
        if(isnan(bst.Data))
            fprintf('NaN\n');
        else
            fprintf('--%d', bst.Data)
            disp(matrix)
        end
        mat = [matrix 0];
        [lev, mat] = huff_print(bst.left, level, mat);
        if(lev > MaxLevel) 
            MaxLevel = lev;
        end
    end
end