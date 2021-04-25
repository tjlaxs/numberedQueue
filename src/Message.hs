module Message
  ( Message(..)
  ) where

import Data.Text (Text)

data Message
  = Event Int Text
  | HeartBeat Int
  deriving (Show)

