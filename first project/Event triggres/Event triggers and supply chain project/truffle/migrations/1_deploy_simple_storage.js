const ItemManager = artifacts.require("./ItemManager.sol");
// const Ownable = artifacts.require("./Ownable.sol");
// const Item = artifacts.require("./Item.sol");

module.exports = function (deployer) {  
  deployer.deploy(ItemManager);
};



// module.exports = function (deployer) {
//   deployer.deploy(Item);
// };



// module.exports = function (deployer) {
//   deployer.deploy(Ownable);
// };