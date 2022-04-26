const { readFile, writeFile } = require('fs/promises');
const chalk = require('chalk');

const FILE_PATH = './deployed.json';
/*
  This function should be called after a successuf deployment in your scripts.
  It will create/update a file named deployed.json containing deployment informations of your smart contracts.
  DO NOT EDIT deployed.json MANUALLY, this is an automatically generated file.
*/
exports.deployed = async (contractName, networkName, address) => {
  console.log(chalk.green.bold(`${contractName} deployed on ${networkName} at ${address}`));
  console.log(chalk.green(`updating ${FILE_PATH} with ${contractName} on ${networkName} at ${address}`));
  // Open and Read current FILE_PATH if exists
  let jsonString = '';
  let obj = {};
  try {
    jsonString = await readFile(FILE_PATH, 'utf-8');
    obj = JSON.parse(jsonString);
  } catch (e) {
    // If does not exist, do nothing
  }
  const _addrObj = {};
  const _chainObj = {};
  let _networksObj = {};
  _addrObj.address = address;
  _chainObj[networkName] = _addrObj;
  _networksObj = { ...obj[contractName], ..._chainObj };
  obj[contractName] = _networksObj;
  jsonString = JSON.stringify(obj);

  try {
    await writeFile(FILE_PATH, jsonString);
  } catch (e) {
    console.log(e.message);
    throw e;
  }
};
