using Microsoft.SqlServer.Server;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ListView_Example
{
    internal class Product
    {
        string id, name;
        int quantity;

        public Product(string id = "", string name = "", int quantity = 0)
        {
            this.id = id;
            this.name = name;
            this.quantity = quantity;
        }
    }
}
