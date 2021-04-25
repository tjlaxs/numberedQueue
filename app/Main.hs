module Main where

import Control.Monad (forever)
import Control.Concurrent (forkIO, threadDelay)
import Control.Concurrent.STM.TVar (newTVarIO)
import Control.Concurrent.STM.TQueue (newTQueueIO)
import Say (say)

import Listener (listener)
import Handler (handler)
import HeartBeat (heartBeat)
import Utils (seconds)

main :: IO ()
main = do
  say "helo"
  q <- newTQueueIO
  cnt <- newTVarIO 0

  forkIO $ listener q cnt
  forkIO $ heartBeat q cnt
  forkIO $ handler q

  -- wait for additional 30 seconds
  threadDelay $ seconds 30
  say "oleh"
