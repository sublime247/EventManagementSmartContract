import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre from "hardhat";

describe("EventManagementSystem", function () {
  async function EventNft() {
    const [owner, otherAccount] = await hre.ethers.getSigners();
    const EventNft = await hre.ethers.getContractFactory("EventNFT");
    const eventNft = await EventNft.deploy();
    const tokenURI = "https://gateway.pinata.cloud/ipfs/QmXrBZLqLDHysXMqaPgz5CwBoBULUJZrh83sZW5zQfowin";
      await eventNft.mintNft(tokenURI);
    return { owner, eventNft , otherAccount,  };
  }


  async function EventManagement() {
    const [owner, otherAccount] = await hre.ethers.getSigners();
    const EventManagement = await hre.ethers.getContractFactory("EventManagement");
    const eventmanagement = await EventManagement.deploy();
   
    return { owner, eventmanagement, otherAccount };
  }

  describe("Deployment", function () {
    it("Should check if eventmananger is the one creating the Event", async function () {
      const { owner, eventmanagement, otherAccount } = await loadFixture(EventManagement);
      expect(await eventmanagement.eventManager()).to.not.equal(otherAccount);
    });

    it("Should check if eventmananger is not addresszero", async function () {
      const { owner, eventmanagement } = await loadFixture(EventManagement);
      expect(await eventmanagement.eventManager()).to.not.equal("0x0000000000000000000000000000000000000000");
    });
  });

  describe("CreateEvent", function () {
    it("Should check if only manager can create an Event", async function () {
      const { owner, otherAccount, eventmanagement } = await loadFixture(EventManagement);
      const { eventNft } = await loadFixture(EventNft);
      const nftAddress = eventNft;

      expect(await eventmanagement.eventManager()).to.equal(owner);
      await expect(eventmanagement.createEvent(
        "Eat",
        nftAddress,
        "lokoja",
        "ndee",
        0
      )).to.not.be.reverted;
      await expect(eventmanagement.connect(otherAccount).createEvent(
        "Eat",
        otherAccount,
        "lokoja",
        "ndee",
        0
      )).to.be.revertedWithCustomError(eventmanagement, "NotAuthorized");
    });


  });
  describe("RemoveEvent", function () {
    it("Should check if only manager can remove an Event", async function () {
      const { owner, otherAccount, eventmanagement } = await loadFixture(EventManagement);
      const { eventNft } = await loadFixture(EventNft);
      const nftAddress = eventNft;

      expect(await eventmanagement.eventManager()).to.equal(owner);
      await expect(eventmanagement.removeEvent(
       1
      )).to.not.be.reverted;

      await expect(eventmanagement.connect(otherAccount).removeEvent(
        1
      )).to.be.revertedWithCustomError(eventmanagement, "NotAuthorized");
      expect(await eventmanagement.eventTrackingId()).to.equal(0);

// 
  });
  });
  
  // for user to register for an event

  describe("RegisterForEvent", function () { 
    it("Should check if  user can register for an Event", async function () {
      const { owner, otherAccount, eventmanagement } = await loadFixture(EventManagement);
      const { eventNft } = await loadFixture(EventNft);
      const nftAddress = eventNft;

      expect(await eventmanagement.eventManager()).to.equal(owner);
      await expect(eventmanagement.createEvent(
        "Eat",
        nftAddress,
        "lokoja",
        "ndee",
        0
      )).to.not.be.reverted;

      await expect(eventmanagement.registerForEvent(
        nftAddress,
        1
      )).to.be.revertedWith("Can't register for event twice");
      await expect(eventmanagement.connect(otherAccount).registerForEvent(
        otherAccount.address,
        1
      )).to.be.revertedWithCustomError(eventmanagement, "InvalidNFT");
      
       expect(eventmanagement.connect(otherAccount).registerForEvent(
        nftAddress,
        1
      ));
      await expect(eventmanagement.connect(otherAccount).registerForEvent(
        nftAddress,
        1
      )).to.be.revertedWith( "Can't register for event twice");;
    
    });
  }
  );
});