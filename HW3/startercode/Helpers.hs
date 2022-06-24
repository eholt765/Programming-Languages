module Helpers
( readMazeFile
, printMaze
) where

import Prelude
import Data.Char
import Data.List
import Debug.Trace

readMazeFile :: String -> IO ([[Char]],[Char])
readMazeFile = readIO

printMaze :: [[Char]] -> IO ()
printMaze [] = do
 print ""
printMaze (ro:ros) = do
 print ro
 printMaze ros

