module Main where

import           Runner
import           System.Environment
import           System.Exit

parse :: [String] -> Maybe (IO String)
parse []     = Nothing
parse (x:xs) = Just (run x xs)

main :: IO ()
main = do
  args <- getArgs
  case parse args of
    Nothing -> exitWith (ExitFailure 111)
    Just v  -> v >>= putStr
