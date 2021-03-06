var abi = [
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_auditor",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "_NFT",
          "type": "address"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "internalType": "address",
          "name": "_auditor",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "address",
          "name": "_contract",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "string",
          "name": "_message",
          "type": "string"
        }
      ],
      "name": "ApprovedAudit",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "internalType": "address",
          "name": "_previous",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "address",
          "name": "_next",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "_time",
          "type": "uint256"
        }
      ],
      "name": "ChangedNFT",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "internalType": "address",
          "name": "_auditor",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "address",
          "name": "_contract",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "string",
          "name": "_message",
          "type": "string"
        }
      ],
      "name": "OpposedAudit",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "internalType": "address",
          "name": "_previous",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "address",
          "name": "_next",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "_time",
          "type": "uint256"
        }
      ],
      "name": "TransferredOwnership",
      "type": "event"
    },
    {
      "inputs": [],
      "name": "NFT",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [],
      "name": "approveAudit",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "audited",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [],
      "name": "auditedContract",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [],
      "name": "auditor",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [],
      "name": "opposeAudit",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "owner",
      "outputs": [
        {
          "internalType": "address payable",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_auditor",
          "type": "address"
        }
      ],
      "name": "setAuditor",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address payable",
          "name": "_owner",
          "type": "address"
        }
      ],
      "name": "transferOwnership",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "donate",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function",
      "payable": true
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_NFT",
          "type": "address"
        }
      ],
      "name": "setNFT",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "destroyContract",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ]