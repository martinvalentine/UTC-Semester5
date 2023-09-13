using Microsoft.AspNetCore.Mvc;

namespace StudentManagementWeb.Controllers
{
    public class StudentController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
