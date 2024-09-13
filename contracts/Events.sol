// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;
import {Events, Errors} from "./Utils.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract EventManagement {
    enum  EventType {
        Tech,
        Religious,
        Entertaiment,
        Career
    }
    uint256 public eventTrackingId;
    address public eventManager;
    uint256 noEventsAvalaible;
    struct EventDetail {
        string eventName;
        string eventLocation;
        uint256 timeCreated;
        string dateHappening;
        EventType eventType;
        bool isCreated;
        bool isEnded;
        address nftTokenAddress;
        uint256 timeRemoved;
    }

    struct UserDetails {
        address userName;
        address nftTokenAddress;
        uint256 timeofRegister;
        EventType eventType;
    }

    mapping(uint256 => EventDetail) eventDetail;
    mapping(uint256 => UserDetails) eventRegistration;
    mapping(address=>mapping(uint256=> bool)) hasRegister;  //this map each event for a perticular event;
   
    constructor() {
        eventManager = msg.sender;
    }

    function onlyManager() private view {
        if(msg.sender!= eventManager){
            revert Errors.NotAuthorized();
        }
    }
        function addressZero() private view{
            if(msg.sender==address(0)){
                revert Errors.ZeroAddressDetected();
            }
        }
 
 function invalidNft(address _userft, address eventnft) private pure{
    if (_userft!=eventnft){
        revert Errors.InvalidNFT();
    }
 }

    /* ______function for event manager to create event_______*/

    function createEvent(
        string memory _eventName,
        address _nftTokenAddress,
        string memory _eventLocation,
        string memory _dateHappening,
        EventType _eventType
    ) external {
        onlyManager();
        addressZero();
        uint256 _eventId = eventTrackingId + 1;
        EventDetail storage newEventDetail = eventDetail[_eventId];
        newEventDetail.eventName = _eventName;
        newEventDetail.nftTokenAddress = _nftTokenAddress;
        newEventDetail.dateHappening = _dateHappening;
        newEventDetail.eventLocation = _eventLocation;
        newEventDetail.eventType = _eventType;
        newEventDetail.timeCreated = block.timestamp;
        newEventDetail.isCreated = true;
        // isEventCreated[msg.sender][_eventId] = true;

        eventTrackingId += 1;

        emit Events.EventCreated(
            _eventName,
            _eventId,
            newEventDetail.timeCreated,
            newEventDetail.isCreated
        );
    }

    /* ______function for event manager to remove event_______*/

    function removeEvent(uint256 eventId) external {
        onlyManager();
        addressZero();
        EventDetail memory _eventToRemove = eventDetail[eventId];
        delete _eventToRemove;
        _eventToRemove.isEnded = true;
        _eventToRemove.timeRemoved = block.timestamp;
        emit Events.EventRemoved(eventId, _eventToRemove.timeRemoved);
    }

    /* ______function for users/attendee to register for an Event_______*/

    function registerForEvent(
        address _userNftTokenAddress,
        uint256 _eventId
    ) external {
        addressZero();
        require(
            eventDetail[_eventId].isCreated,
            "Event does Not Exist/IvalidId"
        );
        require(!eventDetail[_eventId].isEnded, "Event has Ended");

        UserDetails memory _userRegister;
        require(!hasRegister[msg.sender][_eventId], "Can't register for event twice" );
        invalidNft(_userNftTokenAddress, eventDetail[_eventId].nftTokenAddress);


        _userRegister.userName = msg.sender;
        _userRegister.timeofRegister = block.timestamp;
        _userRegister.eventType = eventDetail[_eventId].eventType;
         hasRegister[msg.sender][_eventId]=true;
        emit Events.RegistredSuccessful(
            eventDetail[_eventId].eventName,
            _eventId,
            _userRegister.timeofRegister,
            msg.sender
        );
    }
}
