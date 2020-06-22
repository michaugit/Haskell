module AUTOMAT where

import Data.Char(chr, ord, toUpper)
import Data.List((\\), sortBy, stripPrefix)
import Data.Ord(comparing)

getChange l total = findTotal (sortBy (flip $ comparing amount) l) [] total
findTotal [] _ total = Nothing
findTotal (x:xs) acc total =
  if (amount x) > total then findTotal (dropWhile (==x) xs) acc total
  else if (amount x) == total then Just (x:acc)
  else case findTotal xs (x:acc) (total- amount x) of
         Nothing -> findTotal (dropWhile (==x) xs) acc total
         Just a -> Just a

slotname :: Int -> String
slotname slot = slotnamR (slot+1)
  where slotnamR slot = if slot <= 26 then chr(64+slot):""
                        else if rem == 0 then (slotnamR (quo-1)) ++ "Z"
                        else (slotnamR quo) ++ chr(64+rem):""
                        where rem = slot `mod` 26
                              quo = slot `div` 26

slotnumber :: String -> Int
slotnumber s = slotnR 0 0 s
               where slotnR _ t [] = t
                     slotnR 0 0 (x:xs) = slotnR 1 (ord(x)-65) xs
                     slotnR l t (x:xs) = slotnR (l+1) (26*(t+1)+ord(x)-65) xs

cmds :: String -> [String]
cmds s = let isSpace = (`elem` [' ', ',']) in
         case dropWhile isSpace s of
              "" -> []
              s' -> c : cmds s''
                    where (c, s'') = break isSpace s'

data Currency = M50GR | M1PLN | M2PLN | M5PLN
     deriving (Eq, Show)

amount :: Currency -> Int
amount M50GR     = 50
amount M1PLN     = 100
amount M2PLN     = 200
amount M5PLN     = 500

name :: Currency -> String
name x = map toUpper $ show x


data MachineState = MachineState{coinbox :: [Currency],
                                 deposits :: [Currency],
                                 itemCounts :: [(Int, Int)]}


machine :: MachineState -> [String] -> [String] -> (MachineState, [String])
machine t [] os = (t, os)
machine t@(MachineState coinbox deposits itemCounts) (c:cs) os =
  case stripPrefix "KUP-" c of
    Just a -> let slotnum = slotnumber a in
              if slotnum < length itemCounts then vend slotnum t cs os
              else machine t cs (os ++ ["ZLY KOD PRODUKTU"])
    Nothing -> case c of
               "M50GR" -> machine t {deposits = M50GR : deposits} cs os
               "M1PLN" -> machine t {deposits = M1PLN : deposits} cs os
               "M2PLN" -> machine t {deposits = M2PLN : deposits} cs os
               "M5PLN" -> machine t {deposits = M5PLN : deposits} cs os
               "ZWROC" -> machine t {deposits=[]} cs (os ++
                                           map name deposits)
               "SERWIS" -> service t cs os
               _ -> machine t cs (os ++ ["BLEDNE POLECENIE " ++ c])


vend :: Int -> MachineState -> [String] -> [String] -> (MachineState, [String])
vend slot t@(MachineState coinbox deposits itemCounts) cs os =
  let unspent = sum $ map amount deposits
      newinv = if count==0 then Left ("BLAD - BRAK PRODUKTU: " ++ (slotname slot))
               else Right ((take slot itemCounts) ++ [(count - 1, price)] ++
                           (drop (slot+1) itemCounts))
      (count, price) = itemCounts !! slot
  in case newinv of
    Left a -> machine t cs (os ++ [a])
    Right a -> if unspent < price then
                  machine t cs (os ++ ["BLAD - BRAK FUNDUSZY"])
               else if unspent == price then
                  machine t {coinbox = coinbox ++ deposits, deposits=[],
                             itemCounts=a} cs (os ++ [slotname slot])
               else
                  let change = getChange (coinbox++deposits) (unspent-price)
                  in case (change) of
                    Nothing -> machine t cs (os++["BLAD - AUTOMAT NIE JEST WSTANIE WYDAC RESZTY"])
                    Just c -> machine t {coinbox = ((coinbox++deposits) \\ c),
                                         deposits=[], itemCounts=a} cs 
                                         (os++(slotname slot):(map name c)) 


service :: MachineState -> [String] -> [String] -> (MachineState, [String])
service t [] os = (t, os)
service t@(MachineState coinbox deposits itemCounts) (c:cs) os =
  case c of
    "STAN" -> service t cs (os ++ ["Zawartosc kasetki automatu: " ++ show coinbox, "Depozyt: " ++
                            show deposits, "Inwentarz: " ++ show itemCounts])
    "OPROZNIJ" -> service t {coinbox=[]} cs os
    "UZUPELNIJ" -> case cs of
                 [] -> service t cs (os++["BRAK PASUJACYCH ARGUMENTOW"])
                 (c:cs) -> let num=(read c) in
                           if (length cs) < num*2 then
                             service t cs (os ++ ["''UZUPELNIJ'' ZADEKLAROWALO "
                                           ++ (show num) ++
                                           " PRODUKTOW, WYMAGA WPROWADZENIA " ++
                                           (show (num*2))
                                           ++ " ARGUMENTOW ( w postaci ''liczba_uzupelnien ilosc_produktu koszt_produktu''), PODCZAS GDY PODANO" ++
                                           show (length cs) ++ " ARGUMENTOW"])
                           else
                             service t {itemCounts=(tupleize num [] $
                               map read (take (num*2) cs))} (drop (num*2) cs) os
                               where tupleize 0 o _ = o
                                     tupleize n o (qty:price:cs) =
                                       tupleize (n-1) (o++[(qty, price)]) cs

    _ -> service t cs (os ++ ["NIEZROZUMIALA KOMENDA SERWISOWA " ++ c ++
                      "; MOŻLIWE KOMENDY: STAN, OPROZNIJ, UZUPELNIJ"])


runMachine = vendmachine (MachineState [M50GR, M50GR, M50GR, M1PLN, M1PLN, M1PLN, M2PLN, M2PLN, M2PLN] [] [(3, 50), (3, 100), (3, 150), (3, 200)])


vendmachine :: MachineState -> IO MachineState
vendmachine i = do input <- getLine
                   let (newstate, strs) = machine i (cmds input) []
                   mapM (\x -> putStrLn ("-> " ++ x)) strs
                   vendmachine newstate