module Main where

import Control.Monad (forever)
import Control.Concurrent (forkIO, threadDelay)
import Control.Concurrent.STM.TVar (newTVarIO)
import Control.Concurrent.STM.TQueue (newTQueueIO)
import Say (say)

import Listener (listener)
import Handler (handler)
import HeartBeat (heartBeat)
import MsgChan (mkMsgChanIO)

main :: IO ()
main = do
  say "helo"
  chn <- mkMsgChanIO

  forkIO $ listener chn
  forkIO $ heartBeat chn
  forkIO $ handler chn

  -- wait for additional 30 seconds
  threadDelay $ 30000000
  say "oleh"
