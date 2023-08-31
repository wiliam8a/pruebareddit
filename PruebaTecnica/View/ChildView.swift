//
//  ChildView.swift
//  PruebaTecnica
//
//  Created by Wiliam Ochoa on 29/08/23.
//

import SwiftUI

struct ChildView: View {
    let row: Child
    
    var body: some View {
        VStack(alignment: .leading){
            Text("\(row.data.title)")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct ChildView_Previews: PreviewProvider {
    static var previews: some View {
        ChildView(row: .init(kind: "", data: .init(title: "hola")))
            
    }
}
