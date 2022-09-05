// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import './test/RociERC20.sol';
import "./interfaces/IERC20Minimal.sol";

contract RociOct20 {
    address private _rociERC20;

    /// @notice creates a new LaunchPoolTracker.
    /// @dev up to 3 tokens are allowed to be staked.
    constructor(RociERC20 rociERC20_) {
        require(address(rociERC20_) != address(0), "Contract can't be zero address");
        _rociERC20 = address(rociERC20_);
    }

    function mint(address to, uint256 amount) 
        public {            
        IERC20Minimal(_rociERC20).mint(to, amount, address(this));
    }

    function transfer(address from, address to, uint256 amount) 
        public {    
        IERC20Minimal(_rociERC20).transferFrom(from, to, amount, address(this));
    }
}