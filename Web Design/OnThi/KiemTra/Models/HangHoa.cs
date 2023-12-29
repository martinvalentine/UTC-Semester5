using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Runtime.InteropServices;

namespace KiemTra.Models
{
    public partial class HangHoa
    {
        public int MaHang { get; set; }
        public int MaLoai { get; set; }
        public string TenHang { get; set; } = null!;

        [Range(100, 5000, ErrorMessage = "Phải nằm trong khoảng 100 đến 5000")]
        [RegularExpression(@"^\d*\.?\d+$", ErrorMessage = "Vui lòng nhập một số hợp lệ")]
        public decimal? Gia { get; set; }

        [RegularExpression(@"^[A-Za-z0-9.?%+-_]+\.(jpg|png|gif|tiff)$", ErrorMessage = "Định dạng ảnh phải là .jpg, .gif, .png, .tiff")]
        public string? Anh { get; set; }

        public virtual LoaiHang? MaLoaiNavigation { get; set; } = null!;
    }
}
