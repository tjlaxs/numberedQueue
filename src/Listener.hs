module Listener
  ( listener
  ) where

import Control.Concurrent (threadDelay)
import Control.Concurrent.STM (atomically)
import Control.Concurrent.STM.TQueue (TQueue, newTQueueIO, readTQueue, writeTQueue)
import Control.Concurrent.STM.TVar (TVar)
import Control.Monad (forever)
import Say (say)

import Utils (advance, seconds)
import Message (Message(Event))

-- | This "listens" for events and queues them with a counter
listener :: TQueue Message -> TVar Int -> IO ()
listener q cnt = do
  say "Pretending to listen for messages from outer space..."
  forever $ do
    threadDelay $ seconds 3
    atomically $ do
      n <- advance cnt
      writeTQueue q (Event n "ALL GLORY TO THE HYPNOTOAD!")

