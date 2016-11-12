module Diceware exposing(passphrase, lookupWord)
{-| This module provides lookup methods for the
default Diceware dictionary of 7776 words.
The list is obtained from http://world.std.com/~reinhold/diceware.html
which also provides a description of the
Diceware password generation method.

# Obtaining inputs
Inputs for the Diceware lookup consist of 5 dice
throws producing values between 1 to 6 inclusive,
out of those results a key is formed used to look
up a word from the dictionary.

For example if we performed 5 throws with results
1,1,6,3,2 we would construct the key 11632 which
corresponds to the world `allis` in the dictionary.

In order to reduce the possiblity of incorrect input
this library expects the throws to be encoded as
tuples of 5 integers so the above becomes

    (1,1,6,3,2)

which can be used with the provided lookupWord

    lookupWord (1,1,6,3,2) == "allis"

Since Diceware is used to generate passphrases used
to protect accounts, GPG keys and other potentially
sensitive data the source of inputs is important.

Elm (as of version 0.17) doesn't ship with a cryptographically
secure random number generator hence this library is not
generating the sequences and expects library consume to
provide a secure source.

The recommended approach is creating a javascript port
that uses the browsers crypto.getRandomValues()

# Dictionary lookup
@docs lookupWord

# Creating passphrases
@docs passphrase

-}

import Dict
import String

import Wordlist

{-| Create a passphrase from a provided list of inputs.
The inputs must be a List of tuples of 5 integers with
values between 1 and 6 inclusive. Values outside of the
range will cause a lookup failure and will result in
Debug.crash being called.

The separator decides how the resulting passhprase
is delimited.

    passphrase "-" [ (1,2,3,4,5)
                   , (2,3,2,4,5)
                   , (5,6,6,2,3)
                   ] == "apathy-dodge-tense"

-}
passphrase : String -> List (Int, Int, Int, Int, Int) -> String
passphrase sep inputs =
        String.join sep (List.map lookupWord inputs) 

{-| Lookup a word in the default Diceware dictiony.
The input must be a tuple of 5 integer with values
between 1 and 6 inclusive. Values outside of the
range will cause a lookup failure and will result
in Debug.crash being called.

    lookupWord (1,2,3,4,5) == "apathy"
-}
lookupWord : (Int, Int, Int, Int, Int) -> String
lookupWord input =
        case (Dict.get input Wordlist.wordlist) of
                Just w ->
                        w
                Nothing ->
                        Debug.crash("Diceware word not found for the provided combination")

