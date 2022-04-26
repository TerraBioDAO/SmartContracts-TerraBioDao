// SPDX-License-Identifier: MIT

/// @title TerrabioDAOPresale contract
/// @author Benmissi-A
/// @notice Presale TerrabioDAO
/// @dev ......

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TerrabioDAOPresale is AccessControl {
  
    IERC20 private _UDC;
    IERC20 private _UDT;

    bytes32 public constant KEYMASTER_ROLE = keccak256("KEYMASTER_ROLE");
    bytes32 public constant VAULT_ROLE = keccak256("VAULT_ROLE");

    uint256 public totalSupply = 15* 10**25;
    uint256 public totalInvest;
    address public vault;
    address private _master1;
    address private _master2;
    address private _master3;
    uint256 private _check;
    bool public presaleIsOpen = true;

    mapping(address => bool) public whiteListed;
    mapping(address => uint256) private _userInvestBalance;
    mapping(address => uint256) private _userBalance;
    mapping(address => bool) private _hasVoted;

    modifier multisig() {
         require(_check > 1, "TerrabioDAOPresale: you need one more permission ");
         _;
    }
    modifier openPresale() {
         require( presaleIsOpen == true, "TerrabioDAOPresale: the presale is closed ");
         _;
    }

    event Deposited(address indexed sender, uint256 amount);
    event Withdrew(address indexed recipient, uint256 usdc, uint256 usdt);
    event Registered(address indexed whitelisted, bool status);
    event Permited(address indexed whitelisted, bool status);

    constructor(address UsdcAdress_, address UsdtAdress_ , address master1_, address master2_, address master3_ , address yggdrasil_){
        _UDC = IERC20(UsdcAdress_);
        _UDT = IERC20(UsdtAdress_);
        _setupRole(KEYMASTER_ROLE, master1_);
        _setupRole(KEYMASTER_ROLE, master2_);
        _setupRole(KEYMASTER_ROLE, master3_);
        _setupRole(VAULT_ROLE, yggdrasil_);
         vault = yggdrasil_ ;
        _master1 = master1_;
        _master2 = master2_;
        _master3 = master3_;

    }
    
    function permission() public onlyRole(KEYMASTER_ROLE) returns(bool){

        require(_hasVoted[msg.sender] == false , "TerrabioDAOPresale: you have already voted");
        if(_hasVoted[msg.sender]){
        _hasVoted[msg.sender]=false;
        _check -= 1;
        }else{
        _hasVoted[msg.sender]=true;
        _check += 1;
        }
        emit Permited(msg.sender, _hasVoted[msg.sender]);
        return _hasVoted[msg.sender];
    }

    function buyTbio(uint256 amount_ , uint8 nb_) external openPresale() {
        require(totalSupply > 0 , "TerrabioDAOPresale: all tokens have been sold");
        require(_userInvestBalance[msg.sender]< 5 * 10**22,"TerrabioDAOPresale: you can not buy more than 50000 $" );
        require(amount_ >= 1 * 10**7 , "TerrabioDAOPresale: the minimum amount 10$");
        uint256 ratio;
        whiteListed[msg.sender] == true ? ratio = 25 *10 **12 : ratio = 166667 * 10**8;
        totalSupply -= ratio * amount_ ;
        totalInvest += amount_;
        _userInvestBalance[msg.sender]+=amount_;
        _userBalance[msg.sender]+= ratio * amount_;
        nb_ == 0
        ? _UDC.transferFrom(msg.sender, address(this), amount_)
        : _UDT.transferFrom(msg.sender, address(this), amount_);
        emit Deposited(msg.sender , amount_);
    }

    function getAllowance(address sender_, uint8 nb_)public view returns(uint256) {
        uint256 res;
        nb_ == 0
        ? res =  _UDC.allowance(sender_, address(this))
        : res =  _UDT.allowance(sender_, address(this));
        return res ;
    }

    function getBalanceOf(address user_, uint8 nb_)public view returns(uint256) {
        uint256 res;
        nb_ == 0 
        ? res = _UDC.balanceOf(user_)
        : res = _UDT.balanceOf(user_);    
        return res ;    
    }

    function withdraw() public onlyRole(KEYMASTER_ROLE) multisig(){
        uint256 usdc = _UDC.balanceOf(address(this));
        uint256 usdt = _UDT.balanceOf(address(this));

        _UDC.transfer(vault,  _UDC.balanceOf(address(this)));  
        _UDT.transfer(vault,  _UDT.balanceOf(address(this)));

        _hasVoted[_master1]=false;
        _hasVoted[_master2]=false;
        _hasVoted[_master3]=false;
        _check = 0;
        emit Withdrew(vault, usdc, usdt);
    }
    function closePresale()public multisig(){
        presaleIsOpen = false;
    }

    function registerToWhitelist(address userAddress_) public onlyRole(KEYMASTER_ROLE){
        whiteListed[userAddress_] = true;
        emit Registered(userAddress_,true);
    }

    function banFromWhiteList(address userAddress_) public onlyRole(KEYMASTER_ROLE){
         whiteListed[userAddress_] = false;
         emit Registered(userAddress_,true);
    }
 
    function getUserBalance(address userAddress_) public view returns (uint256){
        return _userBalance[userAddress_];
    }
    function getUserInvestBalance(address userAddress_) public view returns (uint256){
        return _userInvestBalance[userAddress_];
    }


    function supportsInterface(bytes4 interfaceId) public view virtual override( AccessControl) returns (bool) {
      return super.supportsInterface(interfaceId);
    }

}
