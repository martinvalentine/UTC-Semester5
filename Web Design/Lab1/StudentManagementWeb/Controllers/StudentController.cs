using Microsoft.AspNetCore.Mvc;
using StudentManagementWeb.Models;
using System.Collections.Generic;
using System.Reflection;

namespace StudentManagementWeb.Controllers
{
    public class StudentController : Controller
    {
        private List<Student> listStudents = new List<Student>();

        public StudentController() 
        {
            // Create a list of students with 4 sample data
            listStudents = new List<Student>() 
            {
                new Student() { Id = 101, Name = "Marc Levy", Branch = Branch.IT,
                Gender = Gender.Male, IsRegular=true,
                Address = "A1-2018", Email = "marclevy@g.com" },

                new Student() { Id = 102, Name = "Justin Bieber", Branch = Branch.BE,
                Gender = Gender.Female, IsRegular=true,
                Address = "A1-2019", Email = "JBieber@g.com" },

                new Student() { Id = 103, Name = "Kendrick Lamar", Branch = Branch.CE,
                Gender = Gender.Male, IsRegular=false,
                Address = "A1-2020", Email = "kendricklamar@g.com" },

                new Student() { Id = 104, Name = "Xuân Mai", Branch = Branch.EE,
                Gender = Gender.Female, IsRegular = false,
                Address = "A1-2021", Email = "mai@g.com" }
            };
        }

        public IActionResult Index()
        {
            // Returns View Index.cshtml with Model as a list of sv listStudents
            return View(listStudents);
        }
    }
}
