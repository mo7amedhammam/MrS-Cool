//
//  PartialState.swift
//  MrS-Cool
//
//  Created by wecancity on 24/11/2024.
//

import SwiftUI

@propertyWrapper
struct PartialState<Value: Equatable> {
    class Storage: ObservableObject {
        var value: Value {
            didSet {
                if oldValue != value {
                    objectWillChange.send()
                }
            }
        }
        
        init(value: Value) {
            self.value = value
        }
    }
    
    @StateObject var storage: Storage
    
    var wrappedValue: Value {
        get { storage.value }
        nonmutating set { storage.value = newValue }
    }
    
    var projectedValue: Binding<Value> {
        Binding(
            get: { storage.value },
            set: { storage.value = $0 }
        )
    }
    
    init(wrappedValue: Value) {
        _storage = StateObject(wrappedValue: Storage(value: wrappedValue))
    }
    
    struct Key: Hashable {
        let id: ObjectIdentifier
        let keyPath: AnyKeyPath
    }
}

extension View {
    func onPartialChange<Value: Equatable>(
        of state: PartialState<Value>,
        at keyPath: KeyPath<Value, some Equatable>,
        perform action: @escaping (Value) -> Void
    ) -> some View {
        let key = PartialState<Value>.Key(id: ObjectIdentifier(state.storage), keyPath: keyPath)
        return onChange(of: state.wrappedValue[keyPath: keyPath]) { _ in
            action(state.wrappedValue)
        }
        .id(key)
    }
}

/* Usage:
 To better understand how @PartialState prevents unnecessary redraws compared to @State, let's examine our ComplexView example:
 */

struct ComplexState: Equatable {
    var name: String
    var age: Int
    var address: Address
}

struct Address: Equatable {
    var street: String
    var city: String
    var country: String
}

struct ComplexView: View {
    @PartialState var state: ComplexState
    
    var body: some View {
        VStack {
            TextField("Name", text: $state.name)
                .onPartialChange(of: _state, at: \.name) { newState in
                    print("Name changed to: \(newState.name)")
                }
            
            TextField("Age", value: $state.age, formatter: NumberFormatter())
                .onPartialChange(of: _state, at: \.age) { newState in
                    print("Age changed to: \(newState.age)")
                }
            
            TextField("Street", text: $state.address.street)
                .onPartialChange(of: _state, at: \.address.street) { newState in
                    print("Street changed to: \(newState.address.street)")
                }
        }
    }
}
