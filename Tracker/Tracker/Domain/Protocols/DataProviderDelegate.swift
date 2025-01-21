protocol DataProviderDelegate: AnyObject {
    func didUpdate(_ update: StoreUpdate)
}
