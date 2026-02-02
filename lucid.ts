import { Lucid, Blockfrost } from "lucid-cardano";

export const getLucid = async (walletName: string) => {
  const lucid = await Lucid.new(
    new Blockfrost(
      process.env.NEXT_PUBLIC_BLOCKFROST_URL || "https://cardano-preprod.blockfrost.io/api/v0",
      process.env.NEXT_PUBLIC_BLOCKFROST_PROJECT_ID!
    ),
    "Preprod"
  );
  
  const api = await window.cardano[walletName.toLowerCase()].enable();
  lucid.selectWallet(api);
  return lucid;
};