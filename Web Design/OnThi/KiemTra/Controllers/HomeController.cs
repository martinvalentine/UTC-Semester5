using KiemTra.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics;

namespace KiemTra.Controllers
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

        // Create
        public async Task<IActionResult> Create()
        {
            ViewBag.MaLoai = new SelectList(db.LoaiHangs, "MaLoai", "TenLoai"); // Tuong tu combobox lay tu database
            return View();
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("MaLoai", "TenHang", "Gia", "Anh")] HangHoa hanghoa)
        {
            if (ModelState.IsValid)
            {
                db.Add(hanghoa);
                await db.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewBag.MaLoai = new SelectList(db.LoaiHangs, "MaLoai", "TenLoai");
            return View();
        }


        // Edit
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null || db.HangHoas == null)
            {
                return NotFound();
            }

            var hangHoa = await db.HangHoas.FindAsync(id);
            if (hangHoa == null)
            {
                return NotFound();
            }
            ViewData["MaLoai"] = new SelectList(db.LoaiHangs, "MaLoai", "MaLoai", hangHoa.MaLoai);
            return View(hangHoa);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("MaHang,MaLoai,TenHang,Gia,Anh")] HangHoa hangHoa)
        {
            if (id != hangHoa.MaHang)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    db.Update(hangHoa);
                    await db.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!HangHoaExists(hangHoa.MaHang))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["MaLoai"] = new SelectList(db.LoaiHangs, "MaLoai", "MaLoai", hangHoa.MaLoai);
            return View(hangHoa);
        }

        // Delete
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null || db.HangHoas == null)
            {
                return NotFound();
            }

            var hangHoa = await db.HangHoas
                .Include(h => h.MaLoaiNavigation)
                .FirstOrDefaultAsync(m => m.MaHang == id);
            if (hangHoa == null)
            {
                return NotFound();
            }

            return View(hangHoa);
        }

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            if (db.HangHoas == null)
            {
                return Problem("Entity set 'QLHangHoaContext.HangHoas'  is null.");
            }
            var hangHoa = await db.HangHoas.FindAsync(id);
            if (hangHoa != null)
            {
                db.HangHoas.Remove(hangHoa);
            }

            await db.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        // Function to check if HangHoa is exis
        private bool HangHoaExists(int id)
        {
            return (db.HangHoas?.Any(e => e.MaHang == id)).GetValueOrDefault();
        }

        // Privacy
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
