module Runner where

import           Control.Monad
import qualified Data.Map           as M
import qualified Data.Text          as T
import           System.Directory
import           System.Environment
import           System.Exit
import           System.FilePath
import           System.Process

run :: FilePath -> [String] -> IO (ExitCode, String, String)
run _ [] = fail "usage: envdir dir child"
run d (x:xs) = do
  ks <- getEnvironmentFileBaseName fs
  vs <- getEnvironmentFileContents fs
  e  <- getEnvironment
  let newEnv = M.toList $ M.fromList $ e ++ zip ks vs
  readCreateProcessWithExitCode (proc x xs){env = Just newEnv} ""
  where fs = environmentFiles d

environmentFiles :: FilePath -> IO [FilePath]
environmentFiles d = filterM doesFileExist =<< l
  where l = map (d </>) <$> listDirectory d

getEnvironmentFileContents :: IO [FilePath] -> IO [String]
getEnvironmentFileContents xs = mapM f =<< xs
  where f x = do
          v <- readFile x
          return $ T.unpack . T.strip . T.pack $ v

getEnvironmentFileBaseName :: IO [FilePath] -> IO [String]
getEnvironmentFileBaseName xs = do
  fps <- xs
  return $ map takeBaseName fps
