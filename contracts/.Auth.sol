pragma solidity ^0.5.0;
contract Identity{
    function isRegistered() public view returns(uint){}
}
contract Auth{
    Identity user;
    constructor(address _t) public {
        user = Identity(_t);
    }
    struct Client{
        string name;
        string client_id;
        string client_secret;
        string project_name;
    }
    
    mapping (address => uint ) public clientIds;

    Client[] public client;

    event newClientRegistered(uint id);
    event clientUpdateEvent(uint id);

    modifier checkSenderIsRegistered{
        require(user.isRegistered());
        _;
    }
    function registerClient(string memory _name) public returns(uint) {
        return addClient(msg.sender, _name);
    }
    function addClient(address _wAddr, string memory _name) private returns(uint){
        uint clientId = clientIds[_wAddr];
        require(clientId == 0);

        clientIds[_wAddr] = client.length;
        uint newClientId = client.length++;

        client[newClientId] = Client({
            name : _name,
            client_id: "",
            client_secret: "",
            project_name: ""
        });
        emit newClientRegistered(newClientId);

        return newClientId;
    }
    function addClientApp(string memory _pname, string memory _cid, string memory _cscrt) public returns(uint){
        uint clientId = clientIds[msg.sender];
        Client storage c = client[clientId];
        c.project_name = _pname;
        c.client_id = _cid;
        c.client_secret = _cscrt;

        emit clientUpdateEvent(clientId);

        return clientId;
    }
    function totalClients() public view returns (uint){
        return client.length - 1;
      }

    function getClientById(uint _id) public view
    returns(
      string memory,
      string memory,
      string memory,
      string memory
      ){
        require((_id > 0 ) || (_id <= client.length));

        Client memory i = client[_id];

        return(
          _id,
          i.name,
          i.client_id,
          i.client_secret,
          i.project_name
          );
      }      
    function getClientProfile() checkSenderIsRegistered public view
        returns(
          string memory,
          string memory,
          string memory,
          string memory
          ) {
            uint id = clientIds[msg.sender];

            return getClientById(id);
          }

}