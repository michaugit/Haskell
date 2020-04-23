import Data.List



------------------------  sum  ------------------------
my_sum :: ( Num a) => [a] -> a 
my_sum xs = foldl(\acc x -> acc + x) 0 xs

my_sum2 ::(Num a) => [a] -> a
my_sum2 = foldl (+) 0

----------------------- product  ----------------------

my_product ::(Num a) => [a] -> a
my_product = foldl (*) 1


----------------------  reverse  ----------------------
my_reverse :: [a] -> [a]
my_reverse xs = foldl (\acc x -> x : acc) [] xs

my_reverse2 :: [a] -> [a]
my_reverse2 = foldl (\acc x -> x : acc) [] 


------------------------  and  ------------------------
my_and :: [Bool] -> Bool
my_and = foldl(\acc x -> acc && x ) True 


-----------------------  false  -----------------------
my_false :: [Bool] -> Bool
my_false = foldl(\acc x -> acc || x ) False 


----------------------- head  -------------------------
my_head :: [a] -> a  
my_head = foldr1 (\x y -> x)  


----------------------- last  -------------------------
my_last :: [a] -> a  
my_last = foldl1 (\y x -> x)