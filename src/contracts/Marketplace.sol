pragma solidity ^0.5.0;

contract Marketplace{
    string public name;
    uint public productCount = 0;
    mapping(uint => Product) public products;

    struct Product{
        uint id;
        string name;
        uint price;
        address payable owner;
        bool purchased;
    }

    event productCreated(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

     event ProductPurchased(
            uint id,
            string name,
            uint price,
            address payable owner,
            bool purchased
        );

    constructor()public{
        name = "mondays Marketplace";
    }
    function createProduct(string memory _name, uint _price)public {

        require(bytes(_name).length > 0);

        require(_price > 0);

        productCount++;

        products[productCount] = Product(productCount, _name, _price, msg.sender, false );
        
        emit productCreated (productCount, _name, _price, msg.sender, false );
    }

    function purchaseProduct(uint _id)public payable {
        //fetch the product 
        Product memory _product = products[_id];
        //fetch the owner 
        address  payable  _seller = _product.owner;
        //make sure the product has a valid id 
        require(_product.id > 0 && _product.id <= productCount);
        //require there is enough ether in trx
        require(msg.value >= _product.price);
        //require the product isnt purchased
        require(!_product.purchased);
        //require buyer is not seller
        require(_seller != msg.sender);
        // transfer ownership to buyer 
        _product.owner = msg.sender;
        //marked as purchased
        _product.purchased = true;
        //updated the product 
        products[_id]= _product;
        //pay seller by sending them ether
        address(_seller).transfer(msg.value);

        // trigger an event 
        emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true );
    }
}