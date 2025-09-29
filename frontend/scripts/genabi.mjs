#!/usr/bin/env node

import { readFileSync, writeFileSync, readdirSync, statSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const ROOT_DIR = join(__dirname, '..', '..', 'fhevm-hardhat-template');
const OUTPUT_DIR = join(__dirname, '..', 'abi');

const CONTRACT_NAMES = ["FHECounter", "WishPool"];

console.log('===================================================================');
console.log('Generating ABI and Address files for frontend');
console.log('===================================================================');

// Ensure output directory exists
try {
  readdirSync(OUTPUT_DIR);
} catch (error) {
  console.error(`Output directory ${OUTPUT_DIR} does not exist`);
  process.exit(1);
}

function readDeployment(contractName) {
  const deploymentPath = join(ROOT_DIR, 'deployments', 'localhost', `${contractName}.json`);
  try {
    const deployment = JSON.parse(readFileSync(deploymentPath, 'utf8'));
    return {
      address: deployment.address,
      abi: deployment.abi
    };
  } catch (error) {
    console.warn(`Warning: Could not read deployment for ${contractName}, using zero address`);
    return {
      address: '0x0000000000000000000000000000000000000000',
      abi: []
    };
  }
}

function writeABIFile(contractName, abi) {
  const outputPath = join(OUTPUT_DIR, `${contractName}ABI.ts`);
  const content = `/*
  This file is auto-generated.
  Command: 'npm run genabi'
*/
export const ${contractName}ABI = ${JSON.stringify(abi, null, 2)} as const;
`;
  writeFileSync(outputPath, content, 'utf8');
  console.log(`Generated ${outputPath}`);
}

function writeAddressFile(contractName, address) {
  const outputPath = join(OUTPUT_DIR, `${contractName}Addresses.ts`);
  const content = `/*
  This file is auto-generated.
  Command: 'npm run genabi'
*/
export const ${contractName}Addresses = {
  "31337": { address: "${address}", chainId: 31337, chainName: "hardhat" },
  "11155111": { address: "${address}", chainId: 11155111, chainName: "sepolia" },
};
`;
  writeFileSync(outputPath, content, 'utf8');
  console.log(`Generated ${outputPath}`);
}

for (const CONTRACT_NAME of CONTRACT_NAMES) {
  console.log(`\n===================================================================`);
  console.log(`Processing ${CONTRACT_NAME}`);
  console.log('===================================================================');

  const { address, abi } = readDeployment(CONTRACT_NAME);
  writeABIFile(CONTRACT_NAME, abi);
  writeAddressFile(CONTRACT_NAME, address);
}

console.log('\n===================================================================');
console.log('ABI generation completed successfully!');
console.log('===================================================================');
