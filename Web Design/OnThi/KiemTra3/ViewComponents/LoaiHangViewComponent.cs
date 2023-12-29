using KiemTra3.Models;
using Microsoft.AspNetCore.Mvc;

namespace KiemTra3.ViewComponents
{
    public class LoaiHangViewComponent:ViewComponent
    {
        public async Task<IViewComponentResult> InvokeAsync()
        {
            QLHangHoaContext db = new QLHangHoaContext();
            var loaihang = db.LoaiHangs.ToList();
            return View(loaihang);
        }
    }
}
