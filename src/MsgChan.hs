module MsgChan
  ( MsgChan
  , mkMsgChan
  , mkMsgChanIO
  , readMessage
  , writeMessage
  ) where

import Control.Concurrent.STM (STM, atomically)
import Control.Concurrent.STM.TQueue (TQueue, newTQueue, readTQueue, writeTQueue)
import Control.Concurrent.STM.TVar (TVar, newTVar, readTVar, writeTVar)
import Data.Monoid (Sum(..))

data MsgChan a b = MsgChan (TVar (Sum a)) (TQueue b)

advance :: Num a => TVar (Sum a) -> STM a
advance tv = do
  oc <- readTVar tv
  writeTVar tv (oc <> Sum 1)
  return $ getSum oc

mkMsgChan :: Num a => STM (MsgChan a b)
mkMsgChan = do
  tq <- newTQueue
  tv <- newTVar mempty
  return (MsgChan tv tq)

mkMsgChanIO :: Num a => IO (MsgChan a b)
mkMsgChanIO = atomically mkMsgChan

writeMessage :: Num a => MsgChan a b -> (a -> b) -> STM ()
writeMessage (MsgChan v q) msg = do
  n <- advance v
  writeTQueue q (msg n)

readMessage :: Num a => MsgChan a b -> STM b
readMessage (MsgChan _ q) = readTQueue q
  
