//
//  Interactor.swift
//  BasicCrypto-Viper
//
//  Created by Hakan Baran on 5.12.2022.
//

import Foundation

// Class, Protocol
// talk to -> Presenter

protocol AnyInteractor {
    
    var presenter : AnyPresenter? {get set}
    
    func downloadCryptos()
    
}

class CryptoInteractor : AnyInteractor {
    
    var presenter: AnyPresenter?
    
    
    func downloadCryptos() {
        guard let url = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json") else {
            return print("Error 1")
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                self.presenter?.interactorDidDownloadCrypto(result: .failure(NetworkError.NetworkFailed))
                return
            }
            
            do {
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                self.presenter?.interactorDidDownloadCrypto(result: .success(cryptos))
                
            } catch {
                
                self.presenter?.interactorDidDownloadCrypto(result: .failure(NetworkError.ParsingFailed))
                
            }
            
        }
        
        task.resume()
        
        
    }
    
    
    
    
    
}
