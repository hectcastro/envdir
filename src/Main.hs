module Main where

import           Runner
import           System.Environment
import           System.Exit
import           System.IO

-- |Print usage information to stderr and exit with the
-- provided exit code.
usage :: Int -> IO ()
usage code = do
  hPutStrLn stderr "envdir: usage: envdir dir child"
  exitWith (ExitFailure code)

main :: IO ()
main = do
  args <- getArgs
  case args of
    []     -> usage 111
    [_]    -> usage 111
    (x:xs) -> do
      (code, out, err) <- run x xs
      putStr out
      hPutStr stderr err
      exitWith code
