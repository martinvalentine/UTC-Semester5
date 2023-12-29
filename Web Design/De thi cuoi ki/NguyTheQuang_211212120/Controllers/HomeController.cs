using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using NguyTheQuang_211212120.Models;
using System.Diagnostics;

namespace NguyTheQuang_211212120.Controllers
{
    public class HomeController : Controller
    {
        NewShopContext db = new NewShopContext();
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            var hanghoa = db.Products.ToList();
            return View(hanghoa);
        }

        // Phan loai
        public IActionResult HangHoaTheoLoai(int? maloaihang)
        {
            if (maloaihang == null)
            {
				var hanghoa = db.Products.Take(6).ToList();
				return PartialView("HangHoaTheoLoai", hanghoa);
            }
            else
            {
                var hanghoa = db.Products.Where(p => p.ProviderId == maloaihang).OrderByDescending(p => p.Name).ToList();
                return PartialView("HangHoaTheoLoai", hanghoa);
            }

        }

		// GET: Products/Create
		public IActionResult Create()
		{
			ViewData["CategoryId"] = new SelectList(db.Categories, "Id", "Id");
			ViewData["ProviderId"] = new SelectList(db.Providers, "Id", "Id");
			return View();
		}

		// POST: Products/Create
		// To protect from overposting attacks, enable the specific properties you want to bind to.
		// For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
		[HttpPost]
		[ValidateAntiForgeryToken]
		public async Task<IActionResult> Create([Bind("Id,Name,UnitPrice,Image,Available,CategoryId,Description,ProviderId")] Product product)
		{
			if (ModelState.IsValid)
			{
				db.Add(product);
				await db.SaveChangesAsync();
				return RedirectToAction(nameof(Index));
			}
			ViewData["CategoryId"] = new SelectList(db.Categories, "Id", "Id", product.CategoryId);
			ViewData["ProviderId"] = new SelectList(db.Providers, "Id", "Id", product.ProviderId);
			return View(product);
		}


		public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}