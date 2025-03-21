using System;
using BookStoreApi.Models;
using Microsoft.Extensions.Options;
using MongoDB.Driver;

namespace BookStoreApi.Services;

public class BooksService
{
    private readonly IMongoCollection<Book> _booksCollection;

    public BooksService(
        IOptions<BookStoreDatabaseSettings> bookStoreDatabaseSettings)
    {
        var mongoClient = new MongoClient(
            bookStoreDatabaseSettings.Value.ConnectionString);
        
        var mongoDatabase = mongoClient.GetDatabase(
            bookStoreDatabaseSettings.Value.DatabaseName);
        
        _booksCollection = mongoDatabase.GetCollection<Book>(
            bookStoreDatabaseSettings.Value.BooksCollectionName);
    }

    public async Task<List<Book>> GetBooksAsync()
    {
        return await _booksCollection.Find(book => true).ToListAsync();
    }

    public async Task<Book> GetBookAsync(string id)
    {
        return await _booksCollection.Find(book => book.Id == id)
            .FirstOrDefaultAsync();
    }

    public async Task<Book> CreateBookAsync(Book book)
    {
        await _booksCollection.InsertOneAsync(book);
        return book;
    }

    public async Task UpdateBookAsync(string id, Book bookIn)
    {
        await _booksCollection.ReplaceOneAsync(book => book.Id == id, bookIn);
    }

    public async Task DeleteBookAsync(string id)
    {
        await _booksCollection.DeleteOneAsync(book => book.Id == id);
    }
}
