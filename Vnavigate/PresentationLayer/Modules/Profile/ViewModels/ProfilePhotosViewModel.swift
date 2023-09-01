//
//  ProfilePhotosViewModel.swift
//  Vnavigate
//
//  Created by Евгений Стафеев on 22.06.2023.
//

final class ProfilePhotosViewModel {

    let author: Author
    var photos: [Photo] = []

    init(author: Author) {
        self.author = author
    }

    func fetch() {
        photos = CoreDataManager.shared.fetchWithAuthor(Photo.self, author: author, sortDescriptors: nil)
    }
}
