// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract aadhar{

    struct Aadhar{
        string name;
        string _address;
        string dob;
        uint256 aadharNo;
    }
    mapping (address => Aadhar) private aadharData;
    mapping (address => bool) private hasData;
    mapping (uint256 aadharNo => address) public show_WalletAddress;
    address admin;
    event walletAddress(address);
    constructor() {
        admin=msg.sender;
    }
    modifier onlyAdmin(){
        require(msg.sender == admin);
        _;
    }

    function storeAadhar(
        string memory name,
        string memory _address,
        string memory dob,
        uint256 aadharNo,
        address _walletAddress
    )public onlyAdmin{
          aadharData[_walletAddress] = Aadhar(name,_address,dob,aadharNo);
          hasData[_walletAddress] = true;
          emit walletAddress(_walletAddress);
    }

    function showAadhar() public view 
    returns(
        string memory name,
        string memory _address,
        string memory dob,
        uint256 aadharNo
        ){   
            require(hasData[msg.sender] == true,"YOUR DETAILS ARE NOT FOUND");
            return (aadharData[msg.sender].name, aadharData[msg.sender]._address,
            aadharData[msg.sender].dob,aadharData[msg.sender].aadharNo);

    }
}
