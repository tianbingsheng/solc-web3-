//通过web3接口进行连接私有网络

let Web3 = require('web3');  //web3本身具有一些基础性的方法提供
let fs =  require('fs');
let path = require('path');


//提供连接以太坊网络的方法
// "Web3.providers.givenProvider" will be set if in an Ethereum supported browser.
var web3 = new Web3(Web3.givenProvider || 'http://127.0.0.1:8545');

let contractPath = path.join(__dirname,"build","MyToken.json");

//读取编译后的合约数据文件
let data = fs.readFileSync(contractPath,'utf-8');
//将json字符串转换为对象
let jsonObject = JSON.parse(data);

//通过编译后的interface获取到合约的实例
// console.log("----------------");
// console.log(jsonObject.interface);

var myContract = new web3.eth.Contract(JSON.parse(jsonObject.interface));
console.log(myContract);

//部署合约  根据web3的接口文档
myContract.deploy({
    //注意部署是参数bytecode的格式0x;
    data: "0x"+jsonObject.bytecode,
    arguments: ['kongyixueyuan','KYXYB',0,100000]
})
    .send({
        from: '0x1627483c6f2f6e98ddbcdd053367e3325c34c768',
        gas: 1500000,
        gasPrice: '30000000000000'
    }, function(error, transactionHash){
        console.log(transactionHash);
    })
    .on('error', function(error){
        console.log(error);
    })
    .on('transactionHash', function(transactionHash){
        console.log(transactionHash);
    })
    .on('receipt', function(receipt){
        console.log(receipt.contractAddress) // contains the new contract address
    })
    .then(async function(newContractInstance){
        console.log(newContractInstance.options.address) // instance with the new contract address
        newContractInstance.methods.name().call
            .then(function (r) {
               console.log(r);
            });

        //输出合约的名字  等等四个属性的输出
        let name = await newContractInstance.methods.name().call();
        console.log(name);
    });























