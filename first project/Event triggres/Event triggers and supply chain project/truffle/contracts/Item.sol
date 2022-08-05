pragma solidity ^0.6.4;

import "./ItemManager.sol";
contract Item{
    uint public priceInWei;
    uint public index;
    uint public pricePaid;

    ItemManager parentContract;
    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) public{
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }

    receive() external payable{
        //address(parentContract).transfer(msg.value);
        /*call function gives two retuen value: one is boolean if it was successful
        other one is - if the function (to which we are sending
        the trigger) has a return value*/
        require(pricePaid == 0,"item yet ion production");
        require(priceInWei == msg.value,"only full payments allowed");
        priceInWei += msg.value;
        //(bool success,/*function has no return value*/)=address(parentContract).call.value(msg.value)(abi.encodeWithSignature("triggerPayment(uint256)",index));
        //require(success,"Tx was not successful");
        (bool success,/*function has no return value*/)=address(parentContract).call{value:msg.value}(abi.encodeWithSignature("triggerPayment(uint256)",index));
        require(success,"Tx was not successful");
    }// for using less gas we will use a low level function; address.transfer will take up the
    //whole 2300 gas. we want to send a trigger to the other when the payment is made
    // therefore we require this. low level function send a booleanif the tx is successful.
    fallback() external payable{} //required in remix to interact
}