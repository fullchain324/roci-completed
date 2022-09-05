// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import "../interfaces/IERC20Minimal.sol";

contract RociERC20 is IERC20Minimal {
    uint256 totalSupply_;

    address[] public allowedContracts;
    mapping(address => bool) isContractAllowed;
    mapping(address => mapping(address => uint256)) public contractBalanceOf;

    mapping(address => uint256) public override balanceOf;
    mapping(address => mapping(address => uint256)) public override allowance;

    function addContract(address _contract) public {
        allowedContracts.push(_contract);
        isContractAllowed[_contract] = true;
    }

    function mint(address to, uint256 amount, address _contract) 
        public override {
        require(isContractAllowed[_contract], "Now allowed contract to mint.");
        totalSupply_ = balanceOf[to] + amount;
        require(totalSupply_ >= amount, "overflow balance");
        balanceOf[to] = totalSupply_;
        contractBalanceOf[to][_contract] += amount;
    }

    function totalSupply() 
        public 
        view 
        returns (uint256) {
        return totalSupply_;
    }

    function transfer(address recipient, uint256 amount, address _contract)
        public override
        returns (bool)
    {
        require(isContractAllowed[_contract], "Now allowed contract to transfer.");
        uint256 balanceBefore = balanceOf[msg.sender];
        require(balanceBefore >= amount, "insufficient balance");
        balanceOf[msg.sender] = balanceBefore - amount;

        uint256 balanceRecipient = balanceOf[recipient];
        require(
            balanceRecipient + amount >= balanceRecipient,
            "recipient balance overflow"
        );
        balanceOf[recipient] = balanceRecipient + amount;

        contractBalanceOf[msg.sender][_contract] -= amount;
        contractBalanceOf[recipient][_contract] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount)
        public override
        returns (bool)
    {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount, address _contract) 
        public override
        returns (bool) {
        require(isContractAllowed[_contract], "Now allowed contract to transfer.");

        uint256 allowanceBefore = allowance[from][msg.sender];
        //require(allowanceBefore >= amount, "allowance insufficient");

        allowance[from][msg.sender] = allowanceBefore - amount;

        uint256 balanceTo = balanceOf[to];
        require(
            balanceTo + amount >= balanceTo,
            "overflow balance to"
        );
        balanceOf[to] = balanceTo + amount;
        uint256 balanceFrom = balanceOf[from];
        require(balanceFrom >= amount, "underflow balance from");
        balanceOf[from] = balanceFrom - amount;

        contractBalanceOf[from][_contract] -= amount;
        contractBalanceOf[to][_contract] += amount;

        emit Transfer(from, to, amount);
        return true;
    }
}
