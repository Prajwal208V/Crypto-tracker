
import Foundation
import Combine

class CoinDetailDataService{
    
    @Published var coinDetails : CoinDetailModel? = nil
    
    var coinDetailSubscription: AnyCancellable?
    var coin: CoinModel
    
    init(coin:CoinModel){
        self.coin = coin
        getCoinDetails() // in this initializer call getcoins
    }
    
    func getCoinDetails(){
        
        guard let url = URL(string:"https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {return} // downlad the data
        
        coinDetailSubscription = NetworkingManager.download(url:url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder()) // decode the data
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {[weak self] (returnedCoinDetails)in
                self?.coinDetails = returnedCoinDetails // take the data and append to array
                self?.coinDetailSubscription?.cancel()
            })
    }
    
}
