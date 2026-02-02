module Main where
import Cardano.Api
import SavingsVault (validator)
import Plutus.V2.Ledger.Api (Validator(..))
import qualified Data.ByteString.Short as SBS
import Codec.Serialise (serialise)
import qualified Data.ByteString.Lazy as LBS

main :: IO ()
main = do
    let script = PlutusScriptSerialised . SBS.toShort . LBS.toStrict . serialise . unValidatorScript $ validator
    writeFileTextEnvelope "vault.plutus" Nothing script >>= \case
        Left err -> print $ displayError err
        Right () -> putStrLn "Contract compiled to vault.plutus"