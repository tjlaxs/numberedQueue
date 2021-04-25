module Listener
  ( listener
  ) where

import Control.Concurrent (threadDelay)
import Control.Concurrent.STM (atomically)
import Control.Concurrent.STM.TQueue (TQueue, newTQueueIO, readTQueue, writeTQueue)
import Control.Concurrent.STM.TVar (TVar)
import Control.Monad (forever)
import Data.Text (Text)
import Say (say)

import Utils (seconds)
import Message (Message(Event))
import MsgChan (MsgChan, writeMessage)

-- | This "listens" for events and queues them with a counter
listener :: MsgChan Integer (Message Integer Text) -> IO ()
listener chn = do
  say "Pretending to listen for messages from outer space..."
  forever $ do
    threadDelay $ seconds 3
    atomically $ writeMessage chn (Event "ALL GLORY TO THE HYPNOTOAD!")

