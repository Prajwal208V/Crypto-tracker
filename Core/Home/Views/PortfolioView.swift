
import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin : CoinModel? = nil
    @State private var quantityText : String = ""
    @State private var showCheckmark: Bool = false
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 0,content: {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    if selectedCoin != nil{
                        portfolioInputSection
                    }
                })
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading){
                    XMarkButton()
                }
                ToolbarItem(placement: .navigationBarTrailing)  {
                    trailingNavBarButton
                }
            })
            .onChange(of: vm.searchText, {
                if vm.searchText == ""{
                    removeSelectedCoin()
                }
            })
        }
    }
}

#Preview {
    PortfolioView()
}

extension PortfolioView{
    private var coinLogoList:some View{
        ScrollView(.horizontal,showsIndicators: false, content: {
            LazyHStack(spacing:10){
                ForEach(vm.allCoins){ coin in
                    VStack{
                        if let url = URL(string: coin.image){
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                } else if phase.error != nil {
                                    Text("Failed to load image")
                                } else {
                                    ProgressView()
                                }
                            }
                            .frame(width: 45,height: 45)
                            
                        }else {
                            Text("Invalid URL")
                        }
                        Text(coin.symbol.uppercased())
                            .font(.title)
                            .foregroundColor(Color.theme.accent)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Text(coin.name)
                            .font(.headline)
                            .foregroundColor(Color.theme.SecondaryText)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 56,height: 78)
                    .onTapGesture{
                        withAnimation(.easeIn){
                            selectedCoin = coin
                        }
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth:1)
                    )
                }
            }
            .padding(.vertical, 8)
        })
    }
    
    private var portfolioInputSection:some View{
        VStack(spacing:20){
            HStack{
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack{
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4",text:$quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack{
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }
    private var trailingNavBarButton:some View{
        HStack(spacing:10){
            Image(systemName:"checkmark")
                .opacity(showCheckmark ? 1.0 : 0.0)
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("Save".uppercased())
            })
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHolding != Double(quantityText)) ? 1.0 : 0.0
            )
        }
    }
    private func getCurrentValue()-> Double{
        if let quantity = Double(quantityText){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private func saveButtonPressed(){
        guard 
              let coin = selectedCoin
              else { return }
        guard
            let amount = Double(quantityText)
            else { return }
        
        // save to portfolio
       //  vm.updatePortfolio(coin: coin, amount: amount)
        vm.updatePortfolio(coin: coin, amount: amount)
        
        
       // show checkmark
        withAnimation(.easeIn){
            showCheckmark = true
            removeSelectedCoin()
            quantityText = ""
        }
        
        //hide keyboard
        UIApplication.shared.endEditing()
        
        //hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            withAnimation(.easeOut){
                showCheckmark = false
            }
        }
    }
    
    private func removeSelectedCoin(){
        selectedCoin = nil
        vm.searchText = ""
    }
}
