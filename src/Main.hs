module Main where

import           Runner
import           System.Environment
import           System.Exit

main :: IO ()
main = do
  args <- getArgs
  case args of
    []     -> exitWith (ExitFailure 111)
    (x:xs) -> do
      (code, stdout, stderr) <- run x xs
      putStr stdout
      putStr stderr
      exitWith code
