using Microsoft.AspNetCore.Mvc;
using NguyTheQuang_211212120.Models;

namespace NguyTheQuang_211212120.ViewComponents
{
    public class ProviderViewComponent:ViewComponent
    {
        public async Task<IViewComponentResult> InvokeAsync()
        {
            NewShopContext db = new NewShopContext();
            var loaihang = db.Providers.ToList();
            return View(loaihang);
        }
    }
}
