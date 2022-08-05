pragma solidity ^0.6.4;

import "./Ownable.sol";
import "./Item.sol";

contract ItemManager is Ownable{

    enum SupplyChainState{Created, Paid, Delivered}//eg SupplyChainState{0,1,2};

    struct S_item{
        Item _item;
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }

    mapping (uint => S_item) public items;
    uint itemIndex;

    event SupplyChainStep(uint _itemIndex,uint _step, address _item);
    function createItem(string memory _identifier, uint _itemPrice) public onlyOwner{
        Item item = new Item(this,_itemPrice,itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStep(itemIndex,uint(items[itemIndex]._state),address(item));//converting enum to
        //uint because it has predefined value as per the order in enum declration
        itemIndex++; 
    }

    function triggerPayment(uint _itemIndex) public payable{
        Item item = items[_itemIndex]._item;
        require(address(item) == msg.sender,"Only items are allowed to update themselves");
        require(item.priceInWei() == msg.value,"Not fully paid yet");
        //require(items[_itemIndex]._itemPrice == msg.value,"Only full payment allowed");
        require(items[_itemIndex]._state == SupplyChainState.Created,"Item is further in the chain");
        items[_itemIndex]._state = SupplyChainState.Paid;
        emit SupplyChainStep(itemIndex,uint(items[itemIndex]._state), address(item));
        //items[_itemIndex]._itemPrice = msg.value;

    }

    function triggerDelivery(uint _itemIndex) public onlyOwner{
        require(items[_itemIndex]._state == SupplyChainState.Paid,"item is not paid yet");
        items[_itemIndex]._state = SupplyChainState.Delivered;
        emit SupplyChainStep(itemIndex,uint(items[itemIndex]._state), address(items[_itemIndex]._item));

    }
}