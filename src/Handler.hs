module Handler (handler) where

import Control.Concurrent.STM (atomically)
import Control.Concurrent.STM.TQueue (TQueue, readTQueue)
import Control.Monad (forever)
import qualified Data.Text as T
import Say (say)

import Message (Message(..))

-- | Listens for messages and reacts on them
handler :: TQueue Message -> IO ()
handler q = do
  say "Starting message listener..."
  forever $ do
    msg <- atomically $ readTQueue q
    case msg of
      Event c msg -> say $ "Got an event (" <> (T.pack . show) c <> "): " <> msg
      HeartBeat c -> say $ hb c
  say "done"
  where
    ret c s = (T.pack . show) c <> " : " <> s
    hb c = case c `mod` 3 of
      0 -> ret c "Heartbeat"
      1 -> ret c "why do you miss"
      2 -> ret c "when my baby kisses me"
