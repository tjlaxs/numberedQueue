module Listener
  ( listener
  ) where

import Control.Concurrent (threadDelay)
import Control.Concurrent.STM (atomically)
import Control.Concurrent.STM.TQueue (TQueue, newTQueueIO, readTQueue, writeTQueue)
import Control.Concurrent.STM.TVar (TVar)
import Control.Monad (forever)
import Data.Text (Text)
import Network.Wai
import Network.HTTP.Types
import Network.Wai.Handler.Warp (run)
import Say (say)

import Message (Message(Event))
import MsgChan (MsgChan, writeMessage)

toApp :: MsgChan Integer (Message Integer Text) -> Application
toApp chn request respond =
  case rawPathInfo request of
    "/one" -> do
      atomically $ writeMessage chn (Event "One")
      respond $ responseLBS status200 [("Content-Type", "text/plain")] "One"
    "/two" -> do
      atomically $ writeMessage chn (Event "Two")
      respond $ responseLBS status200 [("Content-Type", "text/plain")] "Two"
    _ -> respond $ responseLBS status404 [("Content-Type", "text/plain")] "404 - Not Found"

listener :: MsgChan Integer (Message Integer Text) -> IO ()
listener chn = do
  say "listening for queries on port 8080..."
  run 8080 $ toApp chn
