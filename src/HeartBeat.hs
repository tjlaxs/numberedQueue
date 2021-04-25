module HeartBeat 
  ( heartBeat
  ) where

import Control.Concurrent (threadDelay)
import Control.Concurrent.STM (atomically)
import Control.Concurrent.STM.TQueue (TQueue, writeTQueue)
import Control.Concurrent.STM.TVar (TVar)
import Control.Monad (forever)
import Data.Text (Text)
import Say (say)

import Message (Message(HeartBeat))
import MsgChan (MsgChan, writeMessage)

-- | Queues a HeartBeat message every second
heartBeat :: MsgChan Integer (Message Integer Text) -> IO ()
heartBeat chn = do
  say "Starting heart beat..."
  forever $ do
    atomically $ writeMessage chn HeartBeat
    threadDelay $ 1000000
