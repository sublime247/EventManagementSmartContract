import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const EventModule = buildModule("EventNFTModule", (m) => {

  const evenmanagement = m.contract("EventManagement");

  return { evenmanagement };
});

export default EventModule;
