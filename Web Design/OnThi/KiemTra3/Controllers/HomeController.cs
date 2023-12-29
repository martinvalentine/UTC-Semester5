using KiemTra3.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics;

namespace KiemTra3.Controllers
{
    
    public class HomeController : Controller
    {
        QLHangHoaContext db = new QLHangHoaContext();
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            var hanghoa = db.HangHoas.ToList();
            return View(hanghoa);
        }

        // Phan loai
        public IActionResult HangHoaTheoLoai(int? maloaihang)
        {
            if (maloaihang == null)
            {
                var hanghoa = db.HangHoas.ToList();
                return PartialView("HangHoaTheoLoai", hanghoa);
            }
            else
            {
                var hanghoa = db.HangHoas.Where(p => p.MaLoai == maloaihang).ToList();
                return PartialView("HangHoaTheoLoai", hanghoa);
            }

        }

        // Phan loai Combobox
        public IActionResult LoaiHangSelect(int? mid)
        {
            QLHangHoaContext db = new QLHangHoaContext();
            var midValue = mid ?? 0; // hoặc giá trị mặc định khác phù hợp với logic của bạn
            ViewBag.MidValue = midValue;
            IQueryable<HangHoa> booksQuery = db.HangHoas.Include(b => b.MaLoaiNavigation);

            if (mid != null)
            {
                booksQuery = booksQuery.Where(book => book.MaLoai == midValue);
            }
            return PartialView("HangHoaTheoLoai", booksQuery);
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
