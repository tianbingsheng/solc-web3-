
var solc = require('solc');
var fs = require('fs');
var path = require('path');

//拼接路径
let filepath = path.join(__dirname,"contract/MyToken.sol");
//同步读取文件方式,通过utf-8出来的数据已经是json字符串数据了
let data = fs.readFileSync(filepath,"utf8");
//将数据转换为字符串
console.log(data);

//var input = 'contract x { function g() {} }';

// Setting 1 as second paramateractivates the optimiser
//编译,生成output
var output = solc.compile(data, 1);

//主要目的就是存储编译以后的数据
for (var contractName in output.contracts) {
    // code and ABI that are needed by web3
    console.log(contractName + ': ' + output.contracts[contractName].bytecode);
    console.log(contractName + '; ' + JSON.parse(output.contracts[contractName].interface))

   // 把每一个编译以后的数据写入文件当中
    //__dirname  表示根路径
    let buildContractPath = path.join(__dirname,"build",contractName.replace(":","")+'.json');
    //console.log(buildContractPath);

    //将对象数据转换为json字符串数据  加上null 4  就是对写入的内容进行格式化
    fs.writeFileSync(buildContractPath,JSON.stringify(output.contracts[contractName],null,4));
}



















