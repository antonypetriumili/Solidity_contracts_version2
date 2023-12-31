pragma solidity ^0.8.1;

// SPDX-License-Identifier: Unlicensed
interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: weiValue}(
            data
        );
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// pragma solidity >=0.5.0;

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

// pragma solidity >=0.5.0;

interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

// pragma solidity >=0.6.2;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

// pragma solidity >=0.6.2;

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

contract R is Context, IERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    string private _name = "----";
    string private _symbol = "---";
    uint8 private _decimals = 9;
    uint256 private initialsupply = 1_000_000_000;
    uint256 private _tTotal = initialsupply * 10**_decimals;
    address payable private _marketingWallet;

    mapping(address => uint256) private _tOwned;
    mapping(address => uint256) private buycooldown;
    mapping(address => uint256) private sellcooldown;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) private _isBlacklisted;

    struct Icooldown {
        bool buycooldownEnabled;
        bool sellcooldownEnabled;
        uint256 cooldown;
        uint256 cooldownLimit;
    }
    Icooldown public cooldownInfo =
        Icooldown({
            buycooldownEnabled: true,
            sellcooldownEnabled: true,
            cooldown: 30 seconds,
            cooldownLimit: 60 seconds
        });
    struct ILaunch {
        uint256 launchedAt;
        bool launched;
        bool launchProtection;
    }
    ILaunch public wenLaunch =
        ILaunch({
            launchedAt: 0, 
            launched: false, 
            launchProtection: true
        });

    struct ItxSettings {
        uint256 maxTxAmount;
        uint256 maxWalletAmount;
        uint256 numTokensToSwap;
        bool limited;
    }

    ItxSettings public txSettings =
        ItxSettings({
            maxTxAmount: (_tTotal * 1) / 100,
            maxWalletAmount: (_tTotal * 2) / 100,
            numTokensToSwap: (_tTotal * 5) / 1000,
            limited: true
        });
    uint256 private constant MAX = ~uint256(0);
    uint256 public _liquidityFee = 3;
    uint256 private _previousLiquidityFee = _liquidityFee;
    uint256 public _marketingFee = 9;
    uint256 private _previousMarketingFee = _marketingFee;
    uint256 public _buyLiquidityFee = 3;
    uint256 private _previousBuyLiquidityFee = _buyLiquidityFee;
    uint256 public _buyMarketingFee = 9;
    uint256 private _previousBuyMarketingFee = _buyMarketingFee;

    IUniswapV2Router02 public immutable uniswapV2Router;
    address public immutable uniswapV2Pair;
    bool inSwapAndLiquify;
    bool private swapAndLiquifyEnabled = true;

    event ToMarketing(uint256 ETHSent);
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );

    modifier lockTheSwap() {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    constructor(address marketingWallet) {
        _tOwned[_msgSender()] = _tTotal;
        _marketingWallet = payable(marketingWallet);
        // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());
        uniswapV2Router = _uniswapV2Router;
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _tOwned[account];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function setNumTokensToSwap(uint256 percent, uint256 divisor) external onlyOwner {
        uint256 swapAmount = _tTotal.mul(percent).div(divisor);
        txSettings.numTokensToSwap = swapAmount;
    }

    function setSellFee(uint256 liquidityFee, uint256 marketingFee) external onlyOwner {
        require(liquidityFee + marketingFee <= 20);
        _liquidityFee = liquidityFee;
        _marketingFee = marketingFee;
    }

    function setBuyFee(uint256 marketingFee, uint256 liquidityFee) external onlyOwner {
        require(liquidityFee + marketingFee <= 20);
        _buyMarketingFee = marketingFee;
        _buyLiquidityFee = liquidityFee;
    }

    function setCooldown(uint256 amount) external onlyOwner {
        require(amount <= cooldownInfo.cooldownLimit);
        cooldownInfo.cooldown = amount;
    }

    function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
        require(percent >= 1 && divisor <= 1000); // cannot set lower than .1%
        uint256 new_tx = _tTotal.mul(percent).div(divisor);
        txSettings.maxTxAmount = new_tx;
    }

    function setMaxWalletPercent(uint256 percent, uint256 divisor) external onlyOwner {
        require(percent >= 1 && divisor <= 1000); // cannot set lower than .1%
        uint256 new_mw = _tTotal.mul(percent).div(divisor);
        txSettings.maxWalletAmount = new_mw;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool){
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

    function setBlacklistStatus(address account, bool blacklisted) external onlyOwner {
        if (blacklisted == true) {
            _isBlacklisted[account] = true;
        } else if (blacklisted == false) {
            _isBlacklisted[account] = false;
        }
    }

    function setSniperStatus(address account, bool blacklisted) private{
        if(account == uniswapV2Pair) {revert();}
        
        if (blacklisted == true) {
            _isBlacklisted[account] = true;
        } 
    }

    function limits(bool onoff) public onlyOwner {
        txSettings.limited = onoff;
    }

    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function isBlacklisted(address account) public view returns (bool) {
        return _isBlacklisted[account];
    }

    function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
        swapAndLiquifyEnabled = _enabled;
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }

    //to receive ETH from uniswapV2Router when swapping
    receive() external payable {}

    function removeAllFee() private {
        if (
            _liquidityFee == 0 &&
            _marketingFee == 0 &&
            _buyMarketingFee == 0 &&
            _buyLiquidityFee == 0
        ) return;
        _previousMarketingFee = _marketingFee;
        _previousLiquidityFee = _liquidityFee;
        _previousBuyMarketingFee = _buyMarketingFee;
        _previousBuyLiquidityFee = _buyLiquidityFee;
        _buyMarketingFee = 0;
        _buyLiquidityFee = 0;
        _marketingFee = 0;
        _liquidityFee = 0;
    }

    function restoreAllFee() private {
        _marketingFee = _previousMarketingFee;
        _liquidityFee = _previousLiquidityFee;
        _buyLiquidityFee = _previousBuyLiquidityFee;
        _buyMarketingFee = _previousBuyMarketingFee;
    }

    function _approve(address owner,address spender,uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
        uint256 FeeDivisor = _buyLiquidityFee + _buyMarketingFee + _liquidityFee + _marketingFee;
        uint256 marketingTokenBalance = contractTokenBalance.mul(_buyMarketingFee + _marketingFee).div(FeeDivisor);
        uint256 liquidityTokenBalance = contractTokenBalance.sub(
            marketingTokenBalance
        );
        uint256 tokenBalanceToLiquifyAsETH = liquidityTokenBalance.div(2);
        uint256 tokenBalanceToLiquify = liquidityTokenBalance.sub(
            tokenBalanceToLiquifyAsETH
        );
        uint256 initialBalance = address(this).balance;
        uint256 tokensToSwapToETH = tokenBalanceToLiquifyAsETH.add(
            marketingTokenBalance
        );
        swapTokensForEth(tokensToSwapToETH);
        uint256 ETHSwapped = address(this).balance.sub(initialBalance);
        uint256 ETHToLiquify = ETHSwapped.mul(_buyLiquidityFee + _liquidityFee).div(100);
        addLiquidity(tokenBalanceToLiquify, ETHToLiquify);
        emit SwapAndLiquify(
            tokenBalanceToLiquifyAsETH,
            ETHToLiquify,
            tokenBalanceToLiquify
        );
        uint256 marketingETH = ETHSwapped.sub(ETHToLiquify);
        _marketingWallet.transfer(marketingETH);
        emit ToMarketing(marketingETH);
    }

    function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
        require(amountPercentage <= 100);
        uint256 amountETH = address(this).balance;
        payable(_marketingWallet).transfer(
            amountETH.mul(amountPercentage).div(100)
        );
    }

    function clearStuckToken(address to) external onlyOwner {
        uint256 _balance = balanceOf(address(this));
        _transfer(address(this), to, _balance);
    }

    function clearStuckTokens(address _token, address _to) external onlyOwner returns (bool _sent) {
        require(_token != address(0));
        uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
        _sent = IERC20(_token).transfer(_to, _contractBalance);
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // add the liquidity
        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner(),
            block.timestamp
        );
    }

    function transferFrom(address sender,address recipient,uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function launch() internal {
        wenLaunch.launchedAt = block.number;
        wenLaunch.launched = true;
        emit Launch();
    }

    event Launch();

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        require(_isBlacklisted[from] == false, "Hehe");
        require(_isBlacklisted[to] == false, "Hehe");
        if (txSettings.limited) {
            if(from != owner() && to != owner() && to != address(0xdead)) 
            {
                if (from == uniswapV2Pair || to == uniswapV2Pair
                ) {
                    if(!_isExcludedFromFee[to] && !_isExcludedFromFee[from]) {
                        require(amount <= txSettings.maxTxAmount);
                    }
                }
                if(to != address(uniswapV2Router) && to != uniswapV2Pair) {
                    if(!_isExcludedFromFee[to]) {
                        require(balanceOf(to) + amount <= txSettings.maxWalletAmount);
                    }
                }
            }
        }

        if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]
            ) {
                if (cooldownInfo.buycooldownEnabled) {
                    require(buycooldown[to] < block.timestamp);
                    buycooldown[to] = block.timestamp.add(cooldownInfo.cooldown);
                }
            } else if (from != uniswapV2Pair && !_isExcludedFromFee[from]){
                if (cooldownInfo.sellcooldownEnabled) {
                    require(sellcooldown[from] <= block.timestamp);
                    sellcooldown[from] = block.timestamp.add(cooldownInfo.cooldown);
                }
            }
        if (!wenLaunch.launched && to == uniswapV2Pair && from == owner()) {
            launch();
        }

        if (wenLaunch.launchProtection) {
            if (block.number <= (wenLaunch.launchedAt + 2)) {
                if (
                    from == uniswapV2Pair &&
                    to != address(uniswapV2Router) &&
                    !_isExcludedFromFee[to]
                ) {
                    setSniperStatus(to, true); 
                }
            } else {
                wenLaunch.launchProtection = false;
            }
        }
        uint256 contractTokenBalance = balanceOf(address(this));

        bool overMinTokenBalance = contractTokenBalance >= txSettings.numTokensToSwap;
        if (
            overMinTokenBalance &&
            !inSwapAndLiquify &&
            from != uniswapV2Pair &&
            swapAndLiquifyEnabled
        ) {
            swapAndLiquify(txSettings.numTokensToSwap);
        }

        //indicates if fee should be deducted from transfer
        bool takeFee = true;

        //if any account belongs to _isExcludedFromFee account then remove the fee
        if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
            takeFee = false;
        }

        //transfer amount, it will take tax, marketing, liquidity fee
        _tokenTransfer(from, to, amount, takeFee);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    //this method is responsible for taking all fee, if takeFee is true
    function _tokenTransfer(address sender,address recipient,uint256 amount,bool takeFee) private {
        if (!takeFee) removeAllFee();

        if (sender == uniswapV2Pair && recipient != address(uniswapV2Router)) {
            _transferStandardBuy(sender, recipient, amount);
        } else {
            _transferStandard(sender, recipient, amount);
        }

        if (!takeFee) restoreAllFee();
    }

    function _transferStandardBuy(address sender,address recipient,uint256 amount) private {
        uint256 feeAmount = amount.mul(_buyLiquidityFee + _buyMarketingFee).div(100);
        uint256 tAmount = amount - feeAmount;
        _tOwned[sender] -= amount;
        _tOwned[address(this)] += feeAmount;
        emit Transfer(sender, address(this), feeAmount);
        _tOwned[recipient] += tAmount;
        emit Transfer(sender, recipient, tAmount);
    }

    function _transferStandard(address sender,address recipient,uint256 amount) private {
        uint256 feeAmount = amount.mul(_liquidityFee + _marketingFee).div(100);
        uint256 tAmount = amount - feeAmount;
        _tOwned[sender] -= amount;
        _tOwned[address(this)] += feeAmount;
        emit Transfer(sender, address(this), feeAmount);
        _tOwned[recipient] += tAmount;
        emit Transfer(sender, recipient, tAmount);
    }

    function setCooldownEnabled(bool onoff, bool offon) external onlyOwner {
        cooldownInfo.buycooldownEnabled = onoff;
        cooldownInfo.sellcooldownEnabled = offon;
    }
}