import SwiftUI

struct CreateView: View {
    
    @StateObject var viewModel = CreateChallengeViewModel()
    
    var dropdownList: some View {
        Group {
            DropdownView(viewModel: $viewModel.exerciseDropdowns)
            DropdownView(viewModel: $viewModel.startAmountDropdowns)
            DropdownView(viewModel: $viewModel.increaseDropdowns)
            DropdownView(viewModel: $viewModel.lengthDropdowns)
        }
    }
    
    var mainContentView: some View {
        ScrollView {
            VStack {
                dropdownList
                Spacer()
                NavigationLink(
                    destination: RemindView()) {
                    Button(action: {
                        viewModel.send(action: .createChallenge)
                    }) {
                        Text("Next")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.primary)
                    }
                }
                
            }

        }
    }
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                mainContentView
            }
        }
        .alert(isPresented: Binding<Bool>.constant($viewModel.error.wrappedValue != nil)) {
            Alert(
                title: Text("Error!"),
                message: Text($viewModel.error.wrappedValue?.localizedDescription ?? ""),
                dismissButton: .default(Text("Ok"), action: {
                    viewModel.error = nil
                })
            )
        }
        .navigationTitle("Create")
        .navigationBarBackButtonHidden(true)
        .padding(.bottom, 15)
    }
    
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
