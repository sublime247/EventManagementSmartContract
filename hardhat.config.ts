import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";
dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY!}`,
      accounts: [process.env.SEPOLIA_PRIVATE_KEY!],
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY!,
   
    
  },
  sourcify: {
    enabled:true
  }
};

export default config;
