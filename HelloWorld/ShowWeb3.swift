//
//  ShowWeb3.swift
//  HelloWorld
//
//  Created by yueshu on 2019/6/24.
//  Copyright © 2019 yueshu. All rights reserved.
//

import Foundation
import JSONRPCKit
import APIKit
import BigInt

class ShowWeb3 {
    init(){
        /// 地址
        
        
        /// 示例一：账号余额
//        showAccountBalance()
        
        /// 示例二：交易数量
//        showTradingVolume()
        
        /// 示例三：发起交易
//        sendTransaction()
        
        /// 示例四：查询交易
//        checkTransaction()
        
        /// 示例五：交易收据
        getTransactionReceipt()
        
        /// 示例六：创建合约
        createERC20Contract()
        
        /// 示例七：合约收据
//        contractRecepit()
        
        /// 示例八：代币余额
//        balanceOf()
        
        /// 示例九：转发代币
//        transferToken()
        
        /// 示例十：代币日志
//        tokenRecord()
        
        /// 示例十一：发行总量
//        totalSupply()
        
        /// 示例十二：区块高度
//        block()
    }
    
    /// 示例一：账号余额    通过查询余额获得地址对应账户的以太币数量
    func showAccountBalance() {
        let address = "0x613C023F95f8DDB694AE43Ea989E9C82c0325D3A"
        let batchFactory = BatchFactory(version: "2.0", idGenerator: NumberIdGenerator())
        let balanceRes = BalanceRequest(address: address)
        let batch = batchFactory.create(balanceRes)
        let request = EtherServiceRequest(batch: batch)
        
        Session.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
//                if let value = BigInt(response.drop0x, radix: 16) {
//                    print(value)
//                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// 示例二：交易数量    通过查询该地址发起已经挖矿的交易笔数，用于下一个交易的nonce值
    func showTradingVolume() {
        let address = "0x613C023F95f8DDB694AE43Ea989E9C82c0325D3A"
        let batch = BatchFactory().create(GetTransactionCountRequest.init(address: address, state: "latest"))
        let request = EtherServiceRequest(batch: batch)
        Session.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// 示例三：发起交易    发起以太币支付，需先获得交易数量，count = nonce，最好先获取账号余额，余额不足可以提示
    func sendTransaction() {
        let signedTransaction = "0xf86d018502540be4008302328094405a35e1444299943667d47b2bab7787cbeb61fd88016345785d8a0000801ca0961ef9784a087ccbd0bb61ccbdcd1ce214db1a045555f70b0ae6d1ad441a76faa07fe4c3cb63c730965a7a642c152f8b13b893a6c58f1cdf82f04af285043f180b"
        
        let batch = BatchFactory().create(SendRawTransactionRequest.init(signedTransaction: signedTransaction))
        let request = EtherServiceRequest(batch: batch)
        Session.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    /// 示例四：查询交易    查询交易信息，可以确认发起交易的输入数据，还可以简单
    func checkTransaction() {
        let tranactionHash = "0x8595abd24f1f8590681064e3718fd559db3f50e0342e75b3382a3ec1cc57ce25"
        let batch = BatchFactory().create(GetTransactionRequest.init(hash: tranactionHash))
        let request = EtherServiceRequest(batch: batch)
        Session.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// 示例五：交易收据    如果交易被挖矿，则存在交易收据，收据有详细交易是否成功信息
    func getTransactionReceipt() {
        let tranactionHash = "0x8595abd24f1f8590681064e3718fd559db3f50e0342e75b3382a3ec1cc57ce25"
        let batch = BatchFactory().create(GetTransactionReceiptRequest.init(hash: tranactionHash))
        let request = EtherServiceRequest(batch: batch)
        Session.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// 示例六：创建合约
    func createERC20Contract() {
        let signedTransaction = "0xf90b518204bb850165a0bc00830dbba08080b90afc60606040526002805460ff19166012179055341561001c57600080fd5b604051610a1c380380610a1c833981016040528080519190602001805182019190602001805160025460ff16600a0a85026003819055600160a060020a03331660009081526004602052604081209190915592019190508280516100849291602001906100a1565b5060018180516100989291602001906100a1565b5050505061013c565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f106100e257805160ff191683800117855561010f565b8280016001018555821561010f579182015b8281111561010f5782518255916020019190600101906100f4565b5061011b92915061011f565b5090565b61013991905b8082111561011b5760008155600101610125565b90565b6108d18061014b6000396000f3006060604052600436106100b95763ffffffff7c010000000000000000000000000000000000000000000000000000000060003504166306fdde0381146100be578063095ea7b31461014857806318160ddd1461017e57806323b872dd146101a3578063313ce567146101cb57806342966c68146101f457806370a082311461020a57806379cc67901461022957806395d89b411461024b578063a9059cbb1461025e578063cae9ca5114610282578063dd62ed3e146102e7575b600080fd5b34156100c957600080fd5b6100d161030c565b60405160208082528190810183818151815260200191508051906020019080838360005b8381101561010d5780820151838201526020016100f5565b50505050905090810190601f16801561013a5780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b341561015357600080fd5b61016a600160a060020a03600435166024356103aa565b604051901515815260200160405180910390f35b341561018957600080fd5b6101916103da565b60405190815260200160405180910390f35b34156101ae57600080fd5b61016a600160a060020a03600435811690602435166044356103e0565b34156101d657600080fd5b6101de610457565b60405160ff909116815260200160405180910390f35b34156101ff57600080fd5b61016a600435610460565b341561021557600080fd5b610191600160a060020a03600435166104eb565b341561023457600080fd5b61016a600160a060020a03600435166024356104fd565b341561025657600080fd5b6100d16105d9565b341561026957600080fd5b610280600160a060020a0360043516602435610644565b005b341561028d57600080fd5b61016a60048035600160a060020a03169060248035919060649060443590810190830135806020601f8201819004810201604051908101604052818152929190602084018383808284375094965061065395505050505050565b34156102f257600080fd5b610191600160a060020a0360043581169060243516610781565b60008054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156103a25780601f10610377576101008083540402835291602001916103a2565b820191906000526020600020905b81548152906001019060200180831161038557829003601f168201915b505050505081565b600160a060020a033381166000908152600560209081526040808320938616835292905220819055600192915050565b60035481565b600160a060020a0380841660009081526005602090815260408083203390941683529290529081205482111561041557600080fd5b600160a060020a038085166000908152600560209081526040808320339094168352929052208054839003905561044d84848461079e565b5060019392505050565b60025460ff1681565b600160a060020a0333166000908152600460205260408120548290101561048657600080fd5b600160a060020a03331660008181526004602052604090819020805485900390556003805485900390557fcc16f5dbb4873280815c1ee09dbd06736cffcc184412cf7a71a0fdb75d397ca59084905190815260200160405180910390a2506001919050565b60046020526000908152604090205481565b600160a060020a0382166000908152600460205260408120548290101561052357600080fd5b600160a060020a038084166000908152600560209081526040808320339094168352929052205482111561055657600080fd5b600160a060020a038084166000818152600460209081526040808320805488900390556005825280832033909516835293905282902080548590039055600380548590039055907fcc16f5dbb4873280815c1ee09dbd06736cffcc184412cf7a71a0fdb75d397ca59084905190815260200160405180910390a250600192915050565b60018054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156103a25780601f10610377576101008083540402835291602001916103a2565b61064f33838361079e565b5050565b60008361066081856103aa565b156107795780600160a060020a0316638f4ffcb1338630876040518563ffffffff167c01000000000000000000000000000000000000000000000000000000000281526004018085600160a060020a0316600160a060020a0316815260200184815260200183600160a060020a0316600160a060020a0316815260200180602001828103825283818151815260200191508051906020019080838360005b838110156107165780820151838201526020016106fe565b50505050905090810190601f1680156107435780820380516001836020036101000a031916815260200191505b5095505050505050600060405180830381600087803b151561076457600080fd5b5af1151561077157600080fd5b505050600191505b509392505050565b600560209081526000928352604080842090915290825290205481565b6000600160a060020a03831615156107b557600080fd5b600160a060020a038416600090815260046020526040902054829010156107db57600080fd5b600160a060020a038316600090815260046020526040902054828101101561080257600080fd5b50600160a060020a0380831660008181526004602052604080822080549488168084528284208054888103909155938590528154870190915591909301927fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef9085905190815260200160405180910390a3600160a060020a0380841660009081526004602052604080822054928716825290205401811461089f57fe5b505050505600a165627a7a72305820716da1fe3419571a3c3fa845a628d9f1ec18c456f298161c22d2fbe6b6ea7026002900000000000000000000000000000000000000000000000000000002540be400000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000000c4269742042697420436f696e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000342424300000000000000000000000000000000000000000000000000000000001ca0eb1025398d207eac0345de22908e6a7114955b5a395e679591d67df4af17dfeca03ad28bb50847bf740ea65693d73428938e55d77e157644e534deb35700ae2b20"
        
        let batch = BatchFactory().create(SendRawTransactionRequest.init(signedTransaction: signedTransaction))
        let request = EtherServiceRequest(batch: batch)
        Session.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    /// 示例七：合约收据
    func contractRecepit() {
        let hash = "0x75ca0ef5c43c8556d2cd77aa3aa0da6946a2e4e5ce4a62a86c7e24a9e28c55a5"
        let batch = BatchFactory().create(GetTransactionReceiptRequest.init(hash: hash))
        let request = EtherServiceRequest(batch: batch)
        Session.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// 示例八：代币余额
    func balanceOf() {
        let data = "0x70a08231000000000000000000000000030e37ddd7df1b43db172b23916d523f1599c6cb"
        let to = "0xB8c77482e45F1F44dE1745F52C74426C631bDD52"
        
        let batch = BatchFactory().create(CallRequest.init(to: to, data: data))
        let request = EtherServiceRequest(batch: batch)
        Session.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    /// 示例九：转发代币
    func transferToken() {
        let signedTransaction = "0xf8ac8204bc850165a0bc0083013880945949f052e5f26f5822ebc0c48b795b98a465cf5880b844a9059cbb000000000000000000000000405a35e1444299943667d47b2bab7787cbeb61fd00000000000000000000000000000000000000000000003635c9adc5dea000001ba0f19020f5df4cfd612a256021e99388a22d6b8b50d58584fc5652c789a621da2aa048275196184c67f4206b94b348ee52a4b9b8d89054586e329b5754ba78973f8a"
        
        let batch = BatchFactory().create(SendRawTransactionRequest.init(signedTransaction: signedTransaction))
        let request = EtherServiceRequest(batch: batch)
        Session.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    /// 示例十：代币日志
    func tokenRecord() {
        let token = "0x30459fc2ee1bc4adf2ba26ca1a0ca78f4e0cbe14195af76352e9f84aa4866085"
        
        let batch = BatchFactory().create(GetTransactionReceiptRequest.init(hash: token))
        let request = EtherServiceRequest(batch: batch)
        Session.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// 示例十一：发行总量    查询代币totalSupply方法
    func totalSupply() {
        let data = "0x6b5c5f39"
        let to = "0xD1CEeeeee83F8bCF3BEDad437202b6154E9F5405"
        
        let batch = BatchFactory().create(CallRequest.init(to: to, data: data))
        let request = EtherServiceRequest(batch: batch)
        Session.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// 示例十二：区块高度
    func block() {
        blockNumber()
        
        blockByHash()
        
        blockByNumber()
    }
    
    func blockNumber() {
        let batch = BatchFactory().create(BlockNumberRequest.init())
        let request = EtherServiceRequest(batch: batch)
        Session.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func blockByHash() {
        let hash = "0x8992e4a540f566480d301bff70eeb46a4e25731e2d959dd406a4fefc95c3ad04"
        let batch = BatchFactory().create(GetBlockByHashRequest.init(hash: hash))
        let request = EtherServiceRequest(batch: batch)
        Session.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func blockByNumber() {
        let data = "0x656CE2"
        let batch = BatchFactory().create(GetBlockByNumberRequest.init(data: data))
        let request = EtherServiceRequest(batch: batch)
        Session.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
}

///
struct EtherServiceRequest<Batch: JSONRPCKit.Batch>: APIKit.Request {
    let batch: Batch
    
    typealias Response = Batch.Responses
    
    var baseURL: URL {
        return URL(string: "https://mainnet.infura.io/1f77b2f5344c42238d190c21869681b7")!
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/"
    }
    
    var parameters: Any? {
        return batch.requestObject
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Batch.Responses {
        print(object)
        return try batch.responses(from: object)
    }
}

extension BigInt {
    var hexEncoded: String {
        return "0x" + String(self, radix: 16)
    }
}
