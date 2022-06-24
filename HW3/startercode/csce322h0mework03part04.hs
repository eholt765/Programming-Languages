import Prelude
import System.Environment ( getArgs )
import Data.List
import Helpers

-- The main method that will be used for testing / command line access
main = do
 args <- getArgs
 filename <- readFile (head args)
 (maze,moves) <- readMazeFile filename
 print "Result"
 printMaze (manyPlayersManyMoves maze moves)


-- YOUR CODE SHOULD COME AFTER THIS POINT
manyPlayersManyMoves :: [[Char]] -> [Char] -> [[Char]]
manyPlayersManyMoves maze [] = maze
manyPlayersManyMoves maze moves = newMaze
 where
 flatmaze = collapse1D maze
 intialListPlayers = []
 players = sort(findAllPlayers flatmaze intialListPlayers 0)
 newMaze = runEachPlayerOnce maze moves players 0 0

test :: [Char] -> Int -> Int
test players i
 | (i >= (j-1)) = 0
 | otherwise = i + 1
 where
 j = length players


runEachPlayerOnce :: [[Char]] -> [Char] -> [Char] -> Int -> Int -> [[Char]]
runEachPlayerOnce maze moves players i j
 | (j < ((length moves) -1)) = runEachPlayerOnce newMaze moves players nextI (j+1)
 | otherwise = newMaze
 where
 currMove = moves!!j
 currPlayer = players!!i
 nextI = test players i
 newMaze = checkIfExitFound maze currMove currPlayer players


findAllPlayers :: [Char] -> [Char] -> Int -> [Char]
findAllPlayers maze playerList i
 | ((i < len) && (checkSpot == False)) = findAllPlayers maze playerList (i+1)
 | ((i < len) && (checkSpot == True)) = findAllPlayers maze (playerList ++ [spot]) (i+1)
 | otherwise = playerList
 where
 len = length maze
 spot = maze!!i
 checkSpot = ((spot == '1') || (spot == '2') || (spot == '3') || (spot == '4'))


checkIfExitFound :: [[Char]] -> Char -> Char -> [Char] -> [[Char]]
checkIfExitFound maze move player allPlayers
 | (playerAtExit == 1) = maze
 | otherwise = (onePlayerOneMove maze move player)
 where
 playerAtExit = exitFound maze allPlayers 0

exitFound :: [[Char]] -> [Char] -> Int -> Int
exitFound maze players i
 | ((i < len) && (player == exit)) = 1
 | ((i < len) && (player /= exit)) = exitFound maze players (i+1)
 | otherwise = 0
 where
 currPlayer = players!!i
 player = head(find2D currPlayer maze)
 len = ((length players) -1)
 exit = findExit maze 0



onePlayerOneMove :: [[Char]] -> Char -> Char -> [[Char]]
onePlayerOneMove maze move thisPlayer = finalMaze
 where
 player = head(find2D thisPlayer maze)
 adj = getAdjacent player
 nextCords = (newDirectionPlus move adj)
 exit = findExit maze 0
 isNextClear = recurseNext maze player nextCords exit move thisPlayer
 xPlayer = fst player
 yPlayer = snd player
 col = mazeCols maze
 row = mazeRows maze
 posObj1 = pos1DMaze xPlayer col yPlayer
 xNewLoc = fst isNextClear
 yNewLoc = snd isNextClear
 posObj2 = pos1DMaze xNewLoc col yNewLoc
 locations = orderOfLoc posObj1 posObj2
 loc1 = fst locations
 loc2 = snd locations
 flatmaze = collapse1D maze
 swappedMaze = swap flatmaze (loc1, loc2)
 finalMaze = chunk col swappedMaze


newDirectionPlus :: Char -> [(Int,Int)] -> (Int,Int)
newDirectionPlus move adjSpace
 | (move == 'r') = adjSpace!!2
 | (move == 'l') = adjSpace!!1
 | (move == 'u') = adjSpace!!0
 | (move == 'd') = adjSpace!!3


nextEmpty :: [[Char]] -> (Int,Int) -> (Int,Int) -> Int
nextEmpty maze (newx,newy) (ex,ey)
 | ((nextSpot == '-') && (exitLocated == True)) = 2
 | (nextSpot == '-') = 1
 | otherwise = 0
 where nextSpot = characterAt maze (newx,newy)
       exitLocated = ((newx,newy) == (ex,ey))

recurseNext :: [[Char]] -> (Int,Int) -> (Int,Int) -> (Int,Int) -> Char -> Char -> (Int,Int)
recurseNext maze (oldx,oldy) (newx,newy) (ex,ey) move player
 | (isSafe == 2) = (newx,newy)

 | ((isSafe == 1) && (choice == 'D')) = (newx,newy)
 | ((isSafe == 1) && (choice == 'a') && (move == 'l')) = recurseNext maze (newx,newy) ((newx+1),newy) (ex,ey) 'd' player
 | ((isSafe == 1) && (choice == 'b') && (move == 'r')) = recurseNext maze (newx,newy) ((newx+1),newy) (ex,ey) 'd' player
 | ((isSafe == 1) && (choice == 'c') && (move == 'u')) = recurseNext maze (newx,newy) (newx,(newy-1)) (ex,ey) 'l' player
 | ((isSafe == 1) && (choice == 'd') && (move == 'd')) = recurseNext maze (newx,newy) (newx,(newy-1)) (ex,ey) 'l' player
 | ((isSafe == 1) && (choice == 'e') && (move == 'r')) = recurseNext maze (newx,newy) ((newx-1),newy) (ex,ey) 'u' player
 | ((isSafe == 1) && (choice == 'f') && (move == 'l')) = recurseNext maze (newx,newy) ((newx-1),newy) (ex,ey) 'u' player
 | ((isSafe == 1) && (choice == 'g') && (move == 'd')) = recurseNext maze (newx,newy) (newx,(newy+1)) (ex,ey) 'r' player
 | ((isSafe == 1) && (choice == 'h') && (move == 'u')) = recurseNext maze (newx,newy) (newx,(newy+1)) (ex,ey) 'r' player

 | ((isSafe == 1) && (choice == 'O') && (move == 'r')) = recurseNext maze (newx,newy) (newx,(newy+1)) (ex,ey) 'r' player
 | ((isSafe == 1) && (choice == 'O') && (move == 'l')) = recurseNext maze (newx,newy) (newx,(newy-1)) (ex,ey) 'l' player
 | ((isSafe == 1) && (choice == 'O') && (move == 'u')) = recurseNext maze (newx,newy) ((newx-1),newy) (ex,ey) 'u' player
 | ((isSafe == 1) && (choice == 'O') && (move == 'd')) = recurseNext maze (newx,newy) ((newx+1),newy) (ex,ey) 'd' player

 | (isSafe == 0) = (oldx,oldy)

 where isSafe = nextEmpty maze (newx,newy) (ex,ey)
       choice = checkForChoice maze (newx,newy) move player


orderOfLoc :: Int -> Int -> (Int,Int)
orderOfLoc loc1 loc2
 | (loc1 <= loc2) = (loc1, loc2)
 | otherwise = (loc2, loc1)

swap :: [Char] -> (Int,Int) -> [Char]
swap maze locs
 | (locObj1 == (locObj2)) = maze
 | (locObj1 == (locObj2-1)) = swappedMaze
 | otherwise = swappedMazeWithMid

 where
 greater = maximum locs
 locObj1 = fst locs
 locObj2 = snd locs
 len = length maze
 n = (len - (len - greater))
 front = take locObj1 maze
 back = drop (locObj2 + 1) maze
 obj1 = (maze!!(locObj1))
 obj2 = (maze!!(locObj2))
 max = length maze
 preMStr = take (n) maze
 mid = getMid preMStr 0 (locObj1 + 1)
 swappedMaze = front ++ [obj2] ++ [obj1] ++ back
 swappedMazeWithMid = front ++ [obj2] ++ mid ++ [obj1] ++ back

getMid :: [Char] -> Int -> Int -> [Char]
getMid maze i j
 | (i == j) = maze
 | otherwise = getMid (tail maze) (i+1) j

checkForChoice :: [[Char]] -> (Int,Int) -> Char -> Char -> Char
checkForChoice maze (newx,newy) move player
 | (choicePoint == True) = 'D'
 | (checkLtoD == True) = 'a'
 | (checkRtoD == True) = 'b'
 | (checkUtoL == True) = 'c'
 | (checkDtoL == True) = 'd'
 | (checkRtoU == True) = 'e'
 | (checkLtoU == True) = 'f'
 | (checkDtoR == True) = 'g'
 | (checkUtoR == True) = 'h'
 | otherwise = 'O'
 where nextMove = getAdjacent (newx,newy)
       nextSpot = ((maze!!newx)!!newy)
       rSpot = (characterAt maze (nextMove!!2))
       lSpot = (characterAt maze (nextMove!!1))
       uSpot = (characterAt maze (nextMove!!0))
       dSpot = (characterAt maze (nextMove!!3))
       allAvail = (((rSpot == '-') || (rSpot == player)) && ((lSpot == '-') || (lSpot == player)) && ((uSpot == '-') || (uSpot == player)) && ((dSpot == '-') || (dSpot == player)))
       allButR = (((lSpot == '-') || (lSpot == player)) && ((uSpot == '-') || (uSpot == player)) && ((dSpot == '-') || (dSpot == player)))
       allButL = (((rSpot == '-') || (rSpot == player)) &&  ((uSpot == '-') || (uSpot == player)) && ((dSpot == '-') || (dSpot == player)))
       allButU = (((rSpot == '-') || (rSpot == player)) && ((lSpot == '-') || (lSpot == player)) && ((dSpot == '-') || (dSpot == player)))
       allButD = (((rSpot == '-') || (rSpot == player)) && ((lSpot == '-') || (lSpot == player)) && ((uSpot == '-') || (uSpot == player)))
       choicePoint = ((allAvail == True) || (allButR == True) || (allButL == True) || (allButD == True) || (allButU == True))
       checkLAndD = (((lSpot == '-') || ((lSpot == player))) && ((dSpot == '-') || (dSpot == player)))
       checkRAndD = (((rSpot == '-') || ((rSpot == player))) && ((dSpot == '-') || (dSpot == player)))
       checkLAndU = (((lSpot == '-') || ((lSpot == player))) && ((uSpot == '-') || (uSpot == player)))
       checkRAndU = (((rSpot == '-') || ((rSpot == player))) && ((uSpot == '-') || (uSpot == player)))
       checkLtoD = ((move == 'l') && (checkRAndD == True))
       checkRtoD = ((move == 'r') && (checkLAndD == True))
       checkUtoL = ((move == 'u') && (checkLAndD == True))
       checkDtoL = ((move == 'd') && (checkLAndU == True))
       checkRtoU = ((move == 'r') && (checkLAndU == True))
       checkLtoU = ((move == 'l') && (checkRAndU == True))
       checkDtoR = ((move == 'd') && (checkRAndU == True))
       checkUtoR = ((move == 'u') && (checkRAndD == True))


characterAt :: [[Char]] -> (Int,Int) -> Char
characterAt maze (x,y) = symb
  where symb = ((maze!!x)!!y)

collapse1D :: [[Char]] -> [Char]
collapse1D maze = concat (maze)

chunk :: Int -> [a] -> [[a]]
chunk _ [] = []
chunk n xs = first : chunk n rest where (first, rest) = splitAt n xs

splitSkip :: Int -> [a] -> [[a]]
splitSkip n xs = transpose $ chunk n xs

pos1DMaze :: Int -> Int -> Int -> Int
pos1DMaze x col y = (x * col + y)

findExit :: [[Char]] -> Int -> (Int,Int)
findExit maze i
 | ((check == '-') || (check == '1') || (check == '2') || (check == '3') || (check == '4')) = pair
 | otherwise = findExit maze (i+1)
 where pair = borderCords!!i
       x = fst pair
       y = snd pair
       row = (mazeRows maze)-1
       col = (mazeCols maze)-1
       allCords = [ (x,y) | x<-[0..row], y<-[0..col] ]
       innerCords = [ (x,y) | x<-[0..row], y<-[0..col], x > 0, x < row , y > 0, y < col ]
       borderCords = removeInnerPairs allCords innerCords
       check = characterAt maze pair

removeInnerPairs  xs ys = filter (\x -> x `notElem` ys) xs

getAdjacent :: (Int,Int) -> [(Int,Int)]
getAdjacent (r,c) = [(r+v,c+h)|v<-[-1..1],h<-[-1..1],((abs v)+(abs h))==1]


mazeRows :: [[Char]] -> Int
mazeRows [] = 0
mazeRows (row:rows) = 1 + (mazeRows rows)

mazeCols :: [[Char]] -> Int
mazeCols [] = 0
mazeCols (row:rows) = length row


find2D :: Eq e => e -> [[e]] -> [(Int,Int)]
find2D e listOfLists = find2DHelper e listOfLists 0

find2DHelper :: Eq e => e -> [[e]] -> Int -> [(Int,Int)]
find2DHelper _ [] _ = []
find2DHelper e (list:lists) i = listTu ++ listsA
 where eList = finder e list
       eLists= find2DHelper e lists (i+1)
       listTu= map zeroTuple eList
       listsA= map incTuple eLists

zeroTuple :: Int -> (Int,Int)
zeroTuple a = (0,a)

incTuple :: (Int,Int) -> (Int,Int)
incTuple (a,b) = (a+1,b)

finder :: Eq a => a -> [a] -> [Int]
finder e list = (findHelper e list 0)

findHelper :: Eq a => a -> [a] -> Int -> [Int]
findHelper _ [] _ = []
findHelper e (h:t) i
 | ( e == h ) = i:(findHelper e t (i+1))
 | otherwise = (findHelper e t (i+1))
