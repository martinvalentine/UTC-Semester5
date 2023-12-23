using KiemTra_Lan2.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.CodeAnalysis.QuickInfo;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics;
using System.Drawing.Printing;

namespace KiemTra_Lan2.Controllers
{
    public class HomeController : Controller
    {
        QLHangHoaContext db = new QLHangHoaContext();
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        private int pageSize = 4;
        public IActionResult Index(int? id)
        {
            var hanghoa = (IQueryable<HangHoa>)db.HangHoas.Include(l => l.MaLoaiNavigation).Where(p => p.Gia >= 100);
            if (id != null) // Neu co id
            {
                hanghoa = (IQueryable<HangHoa>)db.HangHoas.Include(l => l.MaLoaiNavigation).Where(p => p.MaLoai == id);
            }
            int pageNum = (int)Math.Ceiling(hanghoa.Count() / (float)pageSize);
            ViewBag.PageNum = pageNum;
            var res = hanghoa.Take(pageSize).ToList();
            return View(res);
        }

        // Paging
        public IActionResult Paging(int? id, int? pageIndex)
        {
            QLHangHoaContext db = new QLHangHoaContext();
            var learners = (IQueryable<HangHoa>)db.HangHoas.Include(m => m.MaLoaiNavigation);
            int page = (int)(pageIndex == null || pageIndex <= 0 ? 1 : pageIndex);
            if (id != null)
            {
                learners = learners.Where(m => m.MaLoai == id);
                ViewBag.Mid = id;
            }
            int pageNum = (int)Math.Ceiling(learners.Count() / (float)pageSize);
            ViewBag.PageNum = pageNum;
            var res = learners.Skip(pageSize * (page - 1)).Take(pageSize).Include(m => m.MaLoaiNavigation);
            return PartialView("HangHoaTheoLoai", res);
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

        // Function to check if HangHoa is exist
        private bool HangHoaExists(int id)
        {
            return (db.HangHoas?.Any(e => e.MaHang == id)).GetValueOrDefault();
        }

        // Search
        public IActionResult SearchByName(string keyword)
        {
            var hanghoa = db.HangHoas.Where(l => l.TenHang.ToLower().Contains(keyword.ToLower())); ;

            return PartialView("HangHoaTheoLoai", hanghoa);
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
