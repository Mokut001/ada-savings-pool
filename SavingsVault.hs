{-# LANGUAGE DataKinds           #-}
{-# LANGUAGE FlexibleContexts    #-}
{-# LANGUAGE NoImplicitPrelude   #-}
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell     #-}
{-# LANGUAGE TypeApplications    #-}
{-# LANGUAGE TypeFamilies        #-}
{-# LANGUAGE TypeOperators       #-}

module SavingsVault where

import           Plutus.V2.Ledger.Api
import           Plutus.V2.Ledger.Contexts
import           PlutusTx
import           PlutusTx.Prelude

-- Datum stores the owner's public key hash and the target amount in Lovelace
data SavingsDatum = SavingsDatum
    { owner  :: PubKeyHash
    , target :: Integer
    }
PlutusTx.unstableMakeIsData ''SavingsDatum

-- Simple redeemer for withdrawal
data SavingsRedeemer = Withdraw
PlutusTx.unstableMakeIsData ''SavingsRedeemer

{-# INLINABLE mkValidator #-}
mkValidator :: SavingsDatum -> SavingsRedeemer -> ScriptContext -> Bool
mkValidator dat Withdraw ctx = 
    traceIfFalse "Not authorized: Only owner can withdraw" isOwner &&
    traceIfFalse "Target not reached: Savings still in progress" targetReached
  where
    info :: TxInfo
    info = scriptContextTxInfo ctx

    -- Ensure the transaction is signed by the vault owner
    isOwner :: Bool
    isOwner = txSignedBy info (owner dat)

    -- Check if the UTXO being spent satisfies the target amount
    -- In a real scenario, we calculate the ADA value of the script input
    targetReached :: Bool
    targetReached = 
        let 
            ownInput = case findOwnInput ctx of
                Nothing -> traceError "Input not found"
                Just i  -> i
            adaAmount = getLovelace (fromValue (txInInfoResolved ownInput))
        in 
            adaAmount >= target dat

validator :: Validator
validator = mkValidatorScript $$(PlutusTx.compile [|| mkValidator ||])