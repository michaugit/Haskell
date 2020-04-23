import qualified  Data.Map
data Tree a = ET | Node a (Tree a, Tree a) deriving (Show, Read, Eq)
-- create single node
treeNode :: a -> Tree a
treeNode item = Node item (ET, ET)




-- ############################## treeInsert #################################
treeInsert :: (Ord a) => a -> Tree a -> Tree a
treeInsert newItem ET = treeNode newItem
treeInsert newItem (Node item (left, right)) =
    if newItem < item
        then Node item (treeInsert newItem left, right)
        else Node item (left, treeInsert newItem right)


-- ############################### empty #####################################
treeEmpty :: (Ord a) => Tree a -> Bool
treeEmpty  tree =
    if tree == ET
        then True
        else False


-- ############################### isBinary ##################################
treeIsBinary :: (Ord a) => Tree a -> Bool 
treeIsBinary ET = True
treeIsBinary (Node item (left, right)) = fun (item >) left && fun (item <=) right && treeIsBinary left && treeIsBinary right
    where
        fun _ ET = True
        fun x (Node i (l, r)) = x i && fun x l && fun x r


-- ################################ search ###################################
treeSearch :: (Ord a) => a -> Tree a -> Bool
treeSearch targetItem ET = False
treeSearch targetItem (Node item (left, right))
    | targetItem < item = treeSearch targetItem left
    | targetItem > item = treeSearch targetItem right
    | otherwise = True


-- ############################### isBalanaced ###############################
treeHeight :: Tree a -> Int
treeHeight ET = 0
treeHeight (Node item (left, right)) = 1 + max (treeHeight left) (treeHeight right)

treeIsBalanced :: (Ord a) => Tree a -> Bool 
treeIsBalanced ET = True
treeIsBalanced (Node item (left, right)) = (treeHeight left == treeHeight right || 
                                           (treeHeight left) + 1 == treeHeight right ||
                                           treeHeight left == (treeHeight right) + 1)
                                           && treeIsBalanced left && treeIsBalanced right


-- ############################### traverse ##################################
treeInOrder :: (Ord a) => Tree a -> [a]
treeInOrder ET = []
treeInOrder (Node item (left, right))= treeInOrder left ++ [item] ++ treeInOrder right

treePreOrder :: (Ord a) => Tree a -> [a]
treePreOrder ET = []
treePreOrder (Node item (left, right))= [item] ++ treePreOrder left ++ treePreOrder right

treePostOrder :: (Ord a) => Tree a -> [a]
treePostOrder ET = []
treePostOrder (Node item (left, right))=  treePostOrder left ++ treePostOrder right ++ [item]

treeOrder_VRL :: (Ord a) => Tree a -> [a]
treeOrder_VRL ET = []
treeOrder_VRL (Node item (left, right))= [item] ++ treeOrder_VRL right ++ treeOrder_VRL left 

treeOrder_RVL :: (Ord a) => Tree a -> [a]
treeOrder_RVL ET = []
treeOrder_RVL (Node item (left, right))= treeOrder_RVL right ++ [item]  ++ treeOrder_RVL left 

treeOrder_RLV :: (Ord a) => Tree a -> [a]
treeOrder_RLV ET = []
treeOrder_RLV (Node item (left, right))= treeOrder_RLV right ++ treeOrder_RLV left  ++ [item]
 

-- ################################ toString ###################################
toString:: (Ord a) => [a] -> Tree a
toString = treeFromList 


-- ################################# leaves ####################################
treeLeaves:: (Ord a) => Tree a -> [a]
treeLeaves tree = case tree of
    (Node item (ET, ET))            -> item : []
    (Node ite (left, ET))           -> treeLeaves left
    (Node it (ET, right))           -> treeLeaves right
    (Node i (l, r))                 -> (treeLeaves l) ++ (treeLeaves r)
    ET                              -> []


-- ################################ nnodes #####################################
treenNodes :: Tree a -> Int
treenNodes ET = 0
treenNodes (Node item (left, right)) = 1 + (treenNodes left) + (treenNodes right)


-- ################################# nsum #####################################
treeNodeSum :: Num a => Tree a -> a
treeNodeSum ET = 0
treeNodeSum (Node item (left, right)) = item  + (treeNodeSum left) + (treeNodeSum right)


-- ################################ treemap ###################################
-- treeMap :: (Ord a) => a -> Tree a -> Tree a -- tu coś jest nie tak
treeMap x tree = treeFromList(map (x) (treeToList tree)) 


-- ################################ remove ####################################
treeMin :: (Eq a) => Tree a -> a
treeMin (Node item (left, _)) =
    if left /= ET
        then treeMin left
        else item

treeMax :: (Eq a) => Tree a -> a
treeMax (Node item (_, right)) =
    if right /= ET
        then treeMax right
        else item

treeRemove :: (Ord a) => a -> Tree a -> Tree a
treeRemove targetItem ET = ET
treeRemove targetItem (Node item (left, right))
    | targetItem < item = Node item (treeRemove targetItem left, right)
    | targetItem > item = Node item (left, treeRemove targetItem right)
    | left == ET = right
    | right == ET = left
    | otherwise = Node newItem (newLeft, right)
    where newItem = treeMax left
          newLeft = treeRemove newItem left


-- ################################ merge ###################################
treeMerge :: (Ord a) => Tree a -> Tree a -> Tree a
treeMerge tree1 tree2 = treeFromList (treeToList tree1 ++ treeToList tree2)

treeMerge2 :: (Ord a) => Tree a -> Tree a -> Tree a
treeMerge2 tree1 tree2= foldl (treeInsertReverse) tree1 (treeToList tree2) 







-------------------------------- covert from/to list ------------------------------------
treeFromList :: (Ord a) => [a] -> Tree a
treeFromList = foldl treeInsertReverse ET

treeInsertReverse :: (Ord a) => Tree a -> a -> Tree a
treeInsertReverse x y = treeInsert y x

treeToList :: Tree a -> [a]
treeToList ET = []
treeToList (Node item (left, right)) = (treeToList left) ++ [item] ++ (treeToList right)
-----------------------------------------------------------------------------------------





