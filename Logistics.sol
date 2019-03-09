pragma solidity ^0.4.24;

contract Logistics{ 
    address owner;
    
    struct package{
        bool is_UIDgenerated;
        uint itemId;
        string itemname;
        string transitstatus;
        uint orderstatus;   //1=ordered 2=shipping 3= delivered 4=canceled;
        
        address customer;
        uint ordertime;
        
        address carrier1;
        uint carrier1_time;
        
        address carrier2;
        uint carrier2_time;
        
        address carrier3;
        uint carrier3_time;
    }
    mapping (address=> package) public packagemapping;
    mapping (address=> bool) public carrierservice;
    
    constructor() public{
        owner=msg.sender;
    }
    
    modifier onlyOwner(){
        require(owner==msg.sender);
        _;
    }
    
    function orderitem(uint _itemid,string _itemname) public returns(address){
        address uniqueId=address(sha256(abi.encodePacked(msg.sender,now)));
        packagemapping[uniqueId].is_UIDgenerated=true;
        packagemapping[uniqueId].itemId=_itemid;
        packagemapping[uniqueId].itemname=_itemname;
        packagemapping[uniqueId].transitstatus="Your package has been ordered and is under processing";
        packagemapping[uniqueId].orderstatus=1;
        packagemapping[uniqueId].customer=msg.sender;
        packagemapping[uniqueId].ordertime=now;
        return uniqueId;
    }
    
    function ManageCouriers(address _carrierrAddress) public onlyOwner returns(string){
        if(!carrierservice[_carrierrAddress]){
            carrierservice[_carrierrAddress]=true;
        }
        else{
            carrierservice[_carrierrAddress]=false;
        }
        return "Carrier is updated";
    }
    
    function cancelorder(address _uniqueId) public returns(string){
       require(packagemapping[_uniqueId].is_UIDgenerated);
       require(packagemapping[_uniqueId].customer==msg.sender);
       packagemapping[_uniqueId].transitstatus="Your package has been cancelled";
       packagemapping[_uniqueId].orderstatus=4; 
       return "Order Cancelled successfully";
    }
    
    function carrier1Report(address _uniqueId,string _transitstatus) public{
        require(packagemapping[_uniqueId].is_UIDgenerated);
        require(packagemapping[_uniqueId].orderstatus==1);
        require(carrierservice[msg.sender]);
        packagemapping[_uniqueId].transitstatus=_transitstatus;
        packagemapping[_uniqueId].orderstatus=2; 
        packagemapping[_uniqueId].carrier1=msg.sender; 
        packagemapping[_uniqueId].carrier1_time=now; 
    }
    
    function carrier2Report(address _uniqueId,string _transitstatus) public{
        require(packagemapping[_uniqueId].is_UIDgenerated);
        require(packagemapping[_uniqueId].orderstatus==2);
        require(carrierservice[msg.sender]);
        packagemapping[_uniqueId].transitstatus=_transitstatus;
        packagemapping[_uniqueId].carrier2=msg.sender; 
        packagemapping[_uniqueId].carrier2_time=now; 
    }
    
    function carrier3Report(address _uniqueId,string _transitstatus) public{
        require(packagemapping[_uniqueId].is_UIDgenerated);
        require(packagemapping[_uniqueId].orderstatus==2);
        require(carrierservice[msg.sender]);
        packagemapping[_uniqueId].transitstatus=_transitstatus;
        packagemapping[_uniqueId].orderstatus=3; 
        packagemapping[_uniqueId].carrier3=msg.sender; 
        packagemapping[_uniqueId].carrier3_time=now; 
    }
}