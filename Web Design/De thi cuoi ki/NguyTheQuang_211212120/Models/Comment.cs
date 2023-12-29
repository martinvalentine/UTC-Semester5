using System;
using System.Collections.Generic;

namespace NguyTheQuang_211212120.Models
{
    public partial class Comment
    {
        public int Id { get; set; }
        public string ComContent { get; set; } = null!;
        public DateTime? CreateAt { get; set; }
        public string ProductId { get; set; } = null!;
        public int? Rate { get; set; }

        public virtual Product Product { get; set; } = null!;
    }
}
