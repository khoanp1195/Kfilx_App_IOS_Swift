//
//  DataPersistanceManager.swift
//  netfilxApp
//
//  Created by Nguyen  Khoa on 01/04/2023.
//

import Foundation
import UIKit
import CoreData

 class DataPersistanceManager
{
     enum DatabaseError: Error {
         case failedToSave
         case failedToSaveData
         case failedDeleteData
     }
     
     static let shared = DataPersistanceManager()
     
     func DowloadTitleWith(model: Tittle, completion: @escaping(Result<Void,Error>) -> Void)
     {
         guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else
         {
             return
         }
         let context = appdelegate.persistentContainer.viewContext
         let item = TitleItem(context: context)
         
         item.original_title = model.original_title
         item.id = Int64(model.id)
         item.original_name = model.original_name
         item.overview = model.overview
         item.poster_path = model.poster_path
         item.media_type = model.media_type
         item.release_date = model.release_date
         item.vote_count = Int64(model.vote_count)
         item.vote_average = model.vote_average
         
         do
         {
             try context.save()
             completion(.success(()))
         }
         catch
         {
             completion(.failure(DatabaseError.failedToSave))
         }
          
     }
     func fetchingTitleFromData(completion:@escaping(Result<[TitleItem],Error>) -> Void)
     {
         guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else
         {
             return
         }
         let context = appdelegate.persistentContainer.viewContext
         let request: NSFetchRequest<TitleItem>
         request = TitleItem.fetchRequest()
         
         do{
             let titles = try context.fetch(request)
             completion(.success(titles))
         }
         catch
         {
             completion(.failure(DatabaseError.failedToSaveData))
         }
     }
     
     func DeleteData(model: TitleItem,completion: @escaping(Result<Void,Error>) -> Void)
     {
         guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else
         {
             return
         }
         let context = appdelegate.persistentContainer.viewContext
         context.delete(model)
         
         do
         {
             try context.save()
             completion(.success(()))
         }
         catch
         {
             completion(.failure(DatabaseError.failedDeleteData))
         }
         
     }
     
 }
