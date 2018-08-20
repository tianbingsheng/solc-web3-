pragma solidity ^0.4.24;

contract EIP20Interface {

    uint256 public totalSupply;
    //获取owner地址的余额
    function balanceOf(address _owner) view returns (uint256 balance);
    //转账,发起调用方向to转_value个token
    function transfer(address _to, uint256 _value) returns (bool success);
    //转账,从from向to转_value个token
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
    //允许_spender这个地址从自己(调用方)的账户转走_value个Token
    function approve(address _spender, uint256 _value) returns (bool success);
    //自己(_owner)查询_spender地址还可以转走自己多少个token
    function allowance(address _owner, address _spender) view returns (uint256 remaining);

    //转账的时候必须要调用,transfer/transferFrom
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    //成功执行approve方法后调用的事件
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}


contract MyToken is EIP20Interface{
    //获取token名字,比如"CHINACOIN"
    string  public name ;
    //获取token简称,比如:"CCN"
    string  public symbol;
    //获取小数位,比如以太坊的decimals为18wei
    uint8   public decimals;
    //获取token发布的总量,比如EOS  10亿
    uint256 public totalSupply;

    //用来存拥有者的余额
    mapping(address=>uint256) balances ;

    //地址可以允许转入多少的token,一个地址可以设置多个可允许地址的转入的token数量
    mapping(address=> mapping(address=>uint256)) allowances ;


    //构造函数进行传递
    function MyToken (string _name,string _symbol,uint8 _decimals,uint256 _totalSupply){
        name = _name ;
        symbol = _symbol ;
        decimals = _decimals ;
        totalSupply = _totalSupply ;
        //发布者拥有合约代币的总量
        balances[msg.sender] = totalSupply ;
    }


    //获取owner地址的余额
    function balanceOf(address _owner) view returns (uint256 balance){
        return balances[_owner] ;
    }
    //转账,发起调用方向to转_value个token
    function transfer(address _to, uint256 _value) returns (bool success){
        //检测数据溢出的考虑...
        require( _value > 0 && balances[_to] + _value > balances[_to] && balances[msg.sender]>_value);

        balances[_to] += _value ;
        balances[msg.sender] -= _value ;
        //必须调用Transfer事件方法,EIP20接口方法...
        Transfer(msg.sender,_to,_value);
        return true ;
    }
    //转账,从from向to转_value个token,必须要经过允许,才能转入你的账户
    //首先实现approve这个合约方法,思路才会理清楚
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
        //别的账户向自己的账户转代币,首先要查看别人是否同意
        //别人那来转给自己
        uint256 allowan = allowances[_from][_to] ;
        //允许的金额,必须要大于你要索取的金额,必须要转给自己
        require(allowan > _value && balances[_from] > _value && _to == msg.sender && balances[_to] + _value>balances[_to]);

        allowances[_from][_to] -= _value ;
        balances[_from] -= _value ;
        //考虑数据溢出的问题
        balances[_to] += _value ;
        Transfer(_from,_to,_value) ;
        return true ;
    }



    //允许_spender这个地址从自己(调用方)的账户转走_value个Token
    function approve(address _spender, uint256 _value) returns (bool success){
        //根据token标准接口说明,指定重复的账户地址会覆盖之前所设置的可允许转入的token的数值
        //判断调用方账户首先要有一定的余额允许其他人转,设置允许别人可以从自己提钱
        require(_value > 0 && balances[msg.sender]>_value) ;
        allowances[msg.sender][_spender] = _value ;

        Approval(msg.sender,_spender,_value) ;
        return true ;
    }
    //自己(_owner)查询_spender地址还可以转走自己多少个token
    function allowance(address _owner, address _spender) view returns (uint256 remaining){

        return allowances[_owner][_spender] ;
    }


}
