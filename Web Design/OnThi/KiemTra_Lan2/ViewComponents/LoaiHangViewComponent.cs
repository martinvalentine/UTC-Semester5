using KiemTra_Lan2.Models;
using Microsoft.AspNetCore.Mvc;

namespace KiemTra_Lan2.ViewComponents
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
