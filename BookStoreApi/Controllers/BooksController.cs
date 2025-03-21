using BookStoreApi.Models;
using BookStoreApi.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace BookStoreApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BooksController : ControllerBase
    {
        private readonly BooksService _booksService;
        
        public BooksController(BooksService booksService)
        {
            _booksService = booksService;
        }

        [HttpGet]
        public async Task<ActionResult<List<Book>>> GetAllBooks()
        {
            return await _booksService.GetBooksAsync();
        }

        [HttpGet("{id:length(24)}")]
        public async Task<ActionResult<Book>> GetBookById(string id)
        {
            var book = await _booksService.GetBookAsync(id);
            if (book == null)
            {
                return NotFound();
            }
            return book;
        }

        [HttpPost]
        public async Task<ActionResult<Book>> PostBook(Book book)
        {
            await _booksService.CreateBookAsync(book);
            return CreatedAtAction(nameof(GetBookById), new { id = book.Id }, book);
        }

        [HttpPut("{id:length(24)}")]
        public async Task<IActionResult> PutBook(string id, Book bookIn)
        {
            var book = await _booksService.GetBookAsync(id);
            if (book == null)
            {
                return NotFound();
            }
            await _booksService.UpdateBookAsync(id, bookIn);
            return NoContent();
        }

        [HttpDelete("{id:length(24)}")]
        public async Task<IActionResult> DeleteBook(string id)
        {
            var book = await _booksService.GetBookAsync(id);
            if (book == null)
            {
                return NotFound();
            }
            await _booksService.DeleteBookAsync(id);
            return NoContent();
        }

    }
}
