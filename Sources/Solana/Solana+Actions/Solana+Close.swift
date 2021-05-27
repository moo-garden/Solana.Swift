//
//  SolanaSDK+Close.swift
//  SolanaSwift
//
//  Created by Chung Tran on 24/02/2021.
//

import Foundation
import RxSwift

extension Solana {
    public func closeTokenAccount(
        account: Solana.Account? = nil,
        tokenPubkey: String
    ) -> Single<TransactionID> {
        guard let account = account ?? accountStorage.account else {
            return .error(Error.unauthorized)
        }
        do {
            let tokenPubkey = try PublicKey(string: tokenPubkey)

            let instruction = TokenProgram.closeAccountInstruction(
                account: tokenPubkey,
                destination: account.publicKey,
                owner: account.publicKey
            )

            return serializeAndSendWithFee(instructions: [instruction], signers: [account])
        } catch {
            return .error(error)
        }
    }
}