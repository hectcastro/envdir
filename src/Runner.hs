module Runner where

import           Control.Monad
import qualified Data.Map           as M
import qualified Data.Text          as T
import           System.Directory
import           System.Environment
import           System.Exit
import           System.FilePath
import           System.Process

-- |Runs another program with the environment modified
-- according to files in a specified directory.
run :: FilePath -> [String] -> IO (ExitCode, String, String)
run _ [] =
  return (ExitFailure 111, "", "envdir: usage: envdir dir child")
run d (x:xs) = do
  ks <- getEnvironmentFileBaseName fs
  vs <- getEnvironmentFileContents fs
  e  <- getEnvironment
  let newEnv = M.toList $ M.fromList $ e ++ zip ks vs
  readCreateProcessWithExitCode (proc x xs){env = Just newEnv} ""
  where fs = environmentFiles d

-- |Collects files in a directory and prepends the directory
-- path to each.
environmentFiles :: FilePath -> IO [FilePath]
environmentFiles d = filterM doesFileExist =<< l
  where l = map (d </>) <$> listDirectory d

-- |Reads the contents of a list of FilePaths and returns
-- a list of their contents trimmed of whitespace.
getEnvironmentFileContents :: IO [FilePath] -> IO [String]
getEnvironmentFileContents xs = mapM f =<< xs
  where f x = do
          v <- readFile x
          return $ T.unpack . T.strip . T.pack $ v

-- |Extracts the basename of a list of FilePaths and returns
-- it as a list.
getEnvironmentFileBaseName :: IO [FilePath] -> IO [String]
getEnvironmentFileBaseName xs = do
  fps <- xs
  return $ map takeBaseName fps
