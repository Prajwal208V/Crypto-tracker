
import SwiftUI

struct HomeView: View {
    @State private var showPortfolio: Bool = false
    @EnvironmentObject private var vm: HomeViewModel // pull-out from Environment
    @State private var showPortfolioView: Bool = false // new sheet
    @State private var showSettingsView: Bool = false // new sheet
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    
   
        
    var body: some View {
        ZStack{
            // background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented:$showPortfolioView ,content: {
                    PortfolioView()
                        .environmentObject(vm)
                })
            // content layer
            VStack{
                homeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchText)
                
                columnTitles
                
                if !showPortfolio{
                    allCoinsList
                      .transition(.move(edge: .leading))
                }
                if showPortfolio{
                    portfolioCoinList
                        .transition(.move(edge: .trailing))
                }
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            }
            .sheet(isPresented:$showSettingsView ,content: {
                SettingsView()
                    .environmentObject(vm)
            })
        }
        .background(
            NavigationLink(
                destination: DetailLoadingView(coin: $selectedCoin),
                isActive: $showDetailView,
                label:{EmptyView()}
            )
        )
    }
            
}

#Preview {
    NavigationView{
        HomeView()
            .navigationBarHidden(true)
    }
    .environmentObject(DeveloperPreview.instance.homeVM)
}

extension HomeView{
    
    private var homeHeader : some View{
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .rotationEffect(Angle(degrees: showPortfolio ? -360 : 0))
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
                .onTapGesture {
                    if showPortfolio{
                        showPortfolioView.toggle()
                    }
                    else {
                        showSettingsView.toggle()
                    }
                }
            Spacer()
            Text(!showPortfolio ? "Live Prices" : "Portfolio")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? -180 : 0))
                .onTapGesture {
                    withAnimation(.spring()){
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View{
        List{
            ForEach(vm.allCoins){ coin in
//                NavigationLink(destination: DetailView(coin:coin),
//                               label:{
//                    CoinRowView(coin:coin, showHoldingsColumn: false)
//                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
//                })
                CoinRowView(coin:coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        seque(coin:coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func seque(coin:CoinModel){
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var portfolioCoinList: some View{
        List{
            ForEach(vm.portfolioCoins){ coin in
                CoinRowView(coin:coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        seque(coin:coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var columnTitles: some View{
        HStack{
            HStack(spacing:4){
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(
                        (vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0
                    )
                    .rotationEffect(Angle(
                        degrees: vm.sortOption == .rank ? 0 : 180
                    ))
            }
            .onTapGesture {
//                withAnimation(.default)
                vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
            }
            Spacer()
            if showPortfolio{
                HStack(spacing:4){
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(
                            (vm.sortOption == .hodlings || vm.sortOption == .hodlingsReversed) ? 1.0 : 0
                        )
                        .rotationEffect(Angle(
                            degrees: vm.sortOption == .hodlings ? 0 : 180
                        ))
                }
                .onTapGesture {
//                    withAnimation(.default)
                    vm.sortOption = vm.sortOption == .hodlings ? .hodlingsReversed : .hodlings
                }
            }
            HStack(spacing:4){
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(
                        (vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0
                    )
                    .rotationEffect(Angle(
                        degrees: vm.sortOption == .price ? 0 : 180
                    ))
            }.frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
                .onTapGesture {
//                    withAnimation(.default)
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            
            Button(action: {
                withAnimation(.linear(duration: 2.0)){
                    vm.reloadData()
                }
            }, label: {
                Image(systemName: "goforward")
            })
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
        }
        .font(.caption)
        .foregroundColor(Color.theme.SecondaryText)
        .padding(.horizontal)
    }
}
