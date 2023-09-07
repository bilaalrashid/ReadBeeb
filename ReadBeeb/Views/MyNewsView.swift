//
//  MyNewsView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI

struct MyNewsView: View {
    var body: some View {
        List {

        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Constants.primaryColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

struct MyNewsView_Previews: PreviewProvider {
    static var previews: some View {
        MyNewsView()
    }
}
