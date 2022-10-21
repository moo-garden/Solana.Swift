import Foundation

public extension Api {
    /// Returns the fee calculator associated with the query blockhash, or null if the blockhash has expired
    /// 
    /// - Parameters:
    ///   - blockhash: query blockhash as a Base58 encoded string
    ///   - commitment: The commitment describes how finalized a block is at that point in time. (finalized, confirmed, processed)
    ///   - onComplete: The result will be Fee (feeCalculator: FeeCalculator?, feeRateGovernor: FeeRateGovernor?, blockhash: String?, lastValidSlot: UInt64?)
    func getFeeCalculatorForBlockhash(blockhash: String, commitment: Commitment? = nil, onComplete: @escaping (Result<Fee, Error>) -> Void) {
        router.request(parameters: [blockhash, RequestConfiguration(commitment: commitment)]) { (result: Result<Rpc<Fee?>, Error>) in
            switch result {
            case .success(let rpc):
                guard let value = rpc.value else {
                    onComplete(.failure(SolanaError.nullValue))
                    return
                }
                onComplete(.success(value))
            case .failure(let error):
                onComplete(.failure(error))
            }
        }
    }
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public extension Api {
    /// Returns the fee calculator associated with the query blockhash, or null if the blockhash has expired
    /// 
    /// - Parameters:
    ///   - blockhash: query blockhash as a Base58 encoded string
    ///   - commitment: The commitment describes how finalized a block is at that point in time. (finalized, confirmed, processed)
    /// - Returns: The result will be Fee (feeCalculator: FeeCalculator?, feeRateGovernor: FeeRateGovernor?, blockhash: String?, lastValidSlot: UInt64?)
    func getFeeCalculatorForBlockhash(blockhash: String, commitment: Commitment? = nil) async throws -> Fee {
        try await withCheckedThrowingContinuation { c in
            self.getFeeCalculatorForBlockhash(blockhash: blockhash, commitment: commitment, onComplete: c.resume(with:))
        }
    }
}

public extension ApiTemplates {
    struct GetFeeCalculatorForBlockhash: ApiTemplate {
        public init(blockhash: String, commitment: Commitment? = nil) {
            self.blockhash = blockhash
            self.commitment = commitment
        }
        
        public let blockhash: String
        public let commitment: Commitment?
        
        public typealias Success = Fee
        
        public func perform(withConfigurationFrom apiClass: Api, completion: @escaping (Result<Success, Error>) -> Void) {
            apiClass.getFeeCalculatorForBlockhash(blockhash: blockhash, commitment: commitment, onComplete: completion)
        }
    }
}
