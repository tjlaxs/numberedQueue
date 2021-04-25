module Utils
  ( advance
  , seconds
  ) where

import Control.Concurrent.STM (STM)
import Control.Concurrent.STM.TVar (TVar, readTVar, writeTVar)

seconds n = n * 1000000

advance :: TVar Int -> STM Int
advance tv = do
  oc <- readTVar tv
  writeTVar tv (oc + 1)
  return oc
