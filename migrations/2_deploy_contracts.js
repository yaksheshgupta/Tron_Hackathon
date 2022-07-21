var EquistartFactory = artifacts.require("./EquistartFactory.sol");
var EquistartProject = artifacts.require("./EquistartProject.sol");
module.exports = function(deployer) {
  const name="yakshesh"
  const symbol="yksh"
  const amount =123
  const addre="TAw9gtbuoxfpoMD9iTvXcryU7GbF5PccjS"
  deployer.deploy(EquistartProject,name,symbol,amount,addre);
  deployer.deploy(EquistartFactory);
};
