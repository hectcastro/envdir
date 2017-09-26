module Runner where

import           Control.Monad
import           System.Directory
import           System.FilePath
import           System.Process

run :: FilePath -> [String] -> IO String
run _ [] = undefined
run d (x:xs) = do
  ks <- getEnvironmentFileBaseName fs
  vs <- getEnvironmentFileContents fs
  readCreateProcess (proc x xs){env = Just (zip ks vs)} ""
  where fs = environmentFiles d

environmentFiles :: FilePath -> IO [FilePath]
environmentFiles d = filterM doesFileExist =<< l
  where l = map (d </>) <$> listDirectory d

getEnvironmentFileContents :: IO [FilePath] -> IO [String]
getEnvironmentFileContents xs = mapM readFile =<< xs

getEnvironmentFileBaseName :: IO [FilePath] -> IO [String]
getEnvironmentFileBaseName xs = do
  fps <- xs
  return $ map takeBaseName fps