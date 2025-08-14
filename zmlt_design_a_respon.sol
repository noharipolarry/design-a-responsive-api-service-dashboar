pragma solidity ^0.8.0;

contract ResponsiveAPIServiceDashboard {
    // Configuration
    address public owner;
    uint public apiCallsLimit;
    uint public bandwidthLimit;
    uint public storageLimit;
    uint public userCountLimit;

    // User Management
    mapping (address => User) public users;
    struct User {
        address userId;
        uint apiCallsUsed;
        uint bandwidthUsed;
        uint storageUsed;
    }

    // API Endpoints
    mapping (string => APIEndpoint) public apiEndpoints;
    struct APIEndpoint {
        string endpointUrl;
        uint apiCallsLimit;
        uint bandwidthLimit;
        uint storageLimit;
    }

    // Dashboard Metrics
    uint public totalApiCalls;
    uint public totalBandwidthUsed;
    uint public totalStorageUsed;
    uint public totalUsers;

    // Events
    event UserCreated(address indexed userId);
    event ApiEndpointCreated(string indexed endpointUrl);
    event ApiCallMade(string endpointUrl, address userId);
    event BandwidthUsageUpdated(string endpointUrl, uint bandwidthUsed);
    event StorageUsageUpdated(string endpointUrl, uint storageUsed);
    event UserApiCallsUpdated(address userId, uint apiCallsUsed);
    event UserBandwidthUpdated(address userId, uint bandwidthUsed);
    event UserStorageUpdated(address userId, uint storageUsed);

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Functions
    constructor() {
        owner = msg.sender;
        apiCallsLimit = 100;
        bandwidthLimit = 100;
        storageLimit = 100;
        userCountLimit = 100;
    }

    function createUser(address _userId) public onlyOwner {
        users[_userId] = User(_userId, 0, 0, 0);
        totalUsers++;
        emit UserCreated(_userId);
    }

    function createApiEndpoint(string memory _endpointUrl, uint _apiCallsLimit, uint _bandwidthLimit, uint _storageLimit) public onlyOwner {
        apiEndpoints[_endpointUrl] = APIEndpoint(_endpointUrl, _apiCallsLimit, _bandwidthLimit, _storageLimit);
        emit ApiEndpointCreated(_endpointUrl);
    }

    function makeApiCall(string memory _endpointUrl) public {
        require(apiEndpoints[_endpointUrl].apiCallsLimit > 0, "API Calls Limit reached");
        apiEndpoints[_endpointUrl].apiCallsLimit--;
        users[msg.sender].apiCallsUsed++;
        totalApiCalls++;
        emit ApiCallMade(_endpointUrl, msg.sender);
    }

    function updateBandwidthUsage(string memory _endpointUrl, uint _bandwidthUsed) public {
        apiEndpoints[_endpointUrl].bandwidthLimit -= _bandwidthUsed;
        users[msg.sender].bandwidthUsed += _bandwidthUsed;
        totalBandwidthUsed += _bandwidthUsed;
        emit BandwidthUsageUpdated(_endpointUrl, _bandwidthUsed);
    }

    function updateStorageUsage(string memory _endpointUrl, uint _storageUsed) public {
        apiEndpoints[_endpointUrl].storageLimit -= _storageUsed;
        users[msg.sender].storageUsed += _storageUsed;
        totalStorageUsed += _storageUsed;
        emit StorageUsageUpdated(_endpointUrl, _storageUsed);
    }
}