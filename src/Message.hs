module Message
  ( Message(..)
  ) where

data Message a b
  = Event b a
  | HeartBeat a
  deriving (Show)

