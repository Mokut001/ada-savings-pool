import React, { useState, useEffect } from 'react';
import { getLucid } from '../lib/lucid';
import { SCRIPT_ADDRESS } from '../lib/constants';

export default function Home() {
  const [lucid, setLucid] = useState<any>(null);
  const [address, setAddress] = useState("");
  const [balance, setBalance] = useState("0");

  const connectWallet = async () => {
    const l = await getLucid("Nami"); // Simplified
    setLucid(l);
    setAddress(await l.wallet.address());
  };

  return (
    <div style={{ padding: '40px', fontFamily: 'sans-serif' }}>
      <h1>ADA Savings Vault</h1>
      {!address ? (
        <button onClick={connectWallet}>Connect Nami Wallet</button>
      ) : (
        <div>
          <p>Connected: {address}</p>
          <div style={{ border: '1px solid #ccc', padding: '20px', borderRadius: '8px' }}>
            <h3>Deposit & Start Saving</h3>
            <input type="number" placeholder="Target ADA" style={{ display: 'block', margin: '10px 0' }} />
            <input type="number" placeholder="Deposit Amount" style={{ display: 'block', margin: '10px 0' }} />
            <button>Deposit to Vault</button>
          </div>
        </div>
      )}
    </div>
  );
}