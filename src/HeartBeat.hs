module HeartBeat 
  ( heartBeat
  ) where

import Control.Concurrent (threadDelay)
import Control.Concurrent.STM (atomically)
import Control.Concurrent.STM.TQueue (TQueue, writeTQueue)
import Control.Concurrent.STM.TVar (TVar)
import Control.Monad (forever)
import Say (say)

import Utils
import Message (Message(HeartBeat))

-- | Queues a HeartBeat message every second
heartBeat :: TQueue Message -> TVar Int -> IO ()
heartBeat q cnt = do
  say "Starting heart beat..."
  forever $ do
    atomically $ do 
      n <- advance cnt
      writeTQueue q (HeartBeat n)
    threadDelay $ seconds 1
