// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;



contract Coffee {
      // Define 'owner'
  address owner;

  // Define a variable called 'upc' for Universal Product Code (UPC)
  string  upc;

  // Define a variable called 'sku' for Stock Keeping Unit (SKU)
  uint  sku;

  // Define a public mapping 'items' that maps the UPC to an Item.
  mapping (uint => Batch) inv;
    
    constructor() public payable {
    owner = msg.sender;
    sku = 0;
    upc = "B1.1";
  }
   enum State
  {
      seeding ,
      growing ,
      harvested ,
      processing ,
      roasting ,
      packaging
    }

    struct Batch {
    uint    sku;                    // Stock Keeping Unit (SKU)
    string  upc;                  
    address pAdd; 
    State   itemState; 
    string totalyeild;

    string s_variety ;
    string s_temp ;
    string s_region ;
    string s_planter;
    uint s_soiltype ;
    string[] s_imgs ;
    string s_date;

    string h_temp ;
    string[] fert ;
    string[] h_tech;
    string h_date;
    string[] h_imgs;

    string p_date;
    string[] p_tech;
    string[] p_imgs;

    string r_type;
    string r_partsize;
    string r_date;
    string r_location;
    string[] r_imgs;

    string f_date;
    string[] f_facilities;

  }
  event Planted(string upc);
  event Harvested(string upc);
  event Processed(string upc); 
  event Roasted(string upc);
  event Packaged(string upc); 

 

   function getInv() public view returns (Batch[] memory) {
        
        Batch[] memory ele = new Batch[](sku);
        uint currentIndex = 0;
        uint currentId;
        for(uint i=0;i<sku;i++)
        {
            currentId = i + 1;
            Batch storage currentItem = inv[currentId];
            ele[currentIndex] = currentItem;
            currentIndex += 1;
        }
        
        return ele;
    }
    function getupcs() public view returns (string[] memory) {
        
        string[] memory upcs = new string[](sku);
        uint currentIndex = 0;
        uint currentId;
        for(uint i=0;i<sku;i++)
        {
            currentId = i + 1;
            string storage currentItem = inv[currentId].upc;
            upcs[currentIndex] = currentItem;
            currentIndex += 1;
        }
        
        return upcs;
    }

    function getNumberName( State number) private view returns (string memory)  {
        State strNumber = number;
        if (strNumber == State.seeding) return "Seeded";
        if (strNumber == State.growing) return "Growing";
        if (strNumber == State.harvested) return "Harvested";
        if (strNumber == State.processing) return "Processing";
        if (strNumber == State.roasting) return "Roasting";
        if (strNumber == State.packaging) return "Packaging";
        return "";
    }

     function getstates() public view returns (string[] memory) {
        
        string[] memory states = new string[](sku);
       // string[] memory states = new string[](sku);
        uint currentIndex = 0;
        uint currentId;
        for(uint i=0;i<sku;i++)
        {
            currentId = i + 1;
            string memory currentItem2 = getNumberName(inv[currentId].itemState);
            states[currentIndex] = currentItem2;
            currentIndex += 1;
        }
        
        return states;
    }

  function addbatch(string memory  _upc , address _pAdd , string memory _s_variety , string memory _s_temp , string memory _s_region , string memory _s_planter , uint _s_soiltype , string[] memory _s_images ,
  string memory _s_date
    ) public payable {

        sku = sku + 1;
      Batch memory nbatch ;
      nbatch.sku = sku;
      nbatch.upc = _upc ;
      nbatch.pAdd = _pAdd;
      nbatch.itemState = State.seeding;
      nbatch.s_variety = _s_variety;
      nbatch.s_temp = _s_temp;
      nbatch.s_region = _s_region;
      nbatch.s_planter = _s_planter;
      nbatch.s_soiltype = _s_soiltype;
      nbatch.s_imgs = _s_images;
      nbatch.s_date = _s_date;
      inv[sku] = nbatch;

      emit Planted(_upc);
  }


  function harvest ( uint  _sku ,string memory _h_temp ,  string[] memory _fert , string[] memory _h_tech, string memory _h_date, string[]  memory _h_imgs ) public payable {
      inv[_sku].h_temp = _h_temp;
      inv[_sku].fert = _fert;
      inv[_sku].h_tech = _h_tech;
      inv[_sku].h_date = _h_date;
      inv[_sku].h_imgs = _h_imgs;
      inv[_sku].itemState = State.harvested;
        emit Harvested(inv[_sku].upc);

  }

  function process ( uint  _sku ,string memory _p_date , string[] memory _p_tech, string[] memory _p_imgs ) public payable {
      inv[_sku].p_date = _p_date;
      inv[_sku].p_tech = _p_tech;
      inv[_sku].p_imgs = _p_imgs;
      inv[_sku].itemState = State.processing;
      emit Processed(inv[_sku].upc);

  }

  function roasting ( uint  _sku ,string memory _r_type, string memory _r_partsize,string memory _r_date,string memory _r_location, string[] memory _r_imgs , string memory _totalyeild ) public payable {
      inv[_sku].r_type = _r_type;
      inv[_sku].r_partsize = _r_partsize;
      inv[_sku].r_date = _r_date;
      inv[_sku].r_location = _r_location;
      inv[_sku].r_imgs = _r_imgs;
      inv[_sku].totalyeild = _totalyeild;
      inv[_sku].itemState = State.roasting;

      emit Roasted(inv[_sku].upc);

  }

  function packaging ( uint  _sku ,string memory _f_date , string[] memory _f_facilities) public payable returns (Batch memory) {
      inv[_sku].f_date = _f_date;
      inv[_sku].f_facilities = _f_facilities;
      inv[_sku].itemState = State.packaging;
      emit Packaged(inv[_sku].upc);
      Batch memory ele = inv[_sku];

      return ele;


  }

  function compare(string memory str1, string memory str2) public pure returns (bool) {
        if (bytes(str1).length != bytes(str2).length) {
            return false;
        }
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }

   function getinfo( string memory upc ) public payable  returns (Batch[] memory)  {
        uint totalItemCount = sku;
        uint itemCount = 0;
        uint currentIndex = 0;
        Batch[] memory items = new Batch[](itemCount);
        //Important to get a count of all the NFTs that belong to the user before we can make an array for them
        for(uint i=0; i < totalItemCount; i++)
        {
            if(compare(inv[i+1].upc ,upc) == true){
                Batch storage currentItem = inv[i+1];
                items[currentIndex] = currentItem;
                return items;
            }
            itemCount += 1;
        }        
        return items;
    }



}