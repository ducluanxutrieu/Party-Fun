import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
// Services
import { ProductService } from '../../_services/product.service';
// Models
import { Product } from '../../_models/product.model';

@Component({
  selector: 'app-mainpage',
  templateUrl: './mainpage.component.html',
  styleUrls: ['./mainpage.component.css']
})
export class MainpageComponent implements OnInit {
  dishes_Data: Product[] = [];
  // pageOfItems: Array<any>;
  category_list = [
    "First Dishes",
    "Main Dishes",
    "Seafood",
    "Drinks",
    "Dessert"
  ];
  filterred_list = [];
  new_products = [];

  constructor(
    private http: HttpClient,
    private productService: ProductService
  ) { }

  get_DishList() {
    this.productService.get_DishList().subscribe(
      res => {
        this.dishes_Data = res.data as Product[];
        this.get_newProducts();
        localStorage.setItem('dish_list', JSON.stringify(res.data)); // Sẽ bỏ trong tương lai
      },
      err => {
        console.log("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      }
    )
  }

  get_newProducts() {
    let temp_product_list = this.dishes_Data;
    for (var i = temp_product_list.length - 1; i > temp_product_list.length - 4; i--) {
      this.new_products.push(temp_product_list[i]);
    }
    // console.log(this.new_products);
  }

  addCart_clicked(id: string) {
    this.productService.addCartItem(id, 1);
  }

  // onChangePage(pageOfItems: Array<any>) {
  //   // update current page of items
  //   this.pageOfItems = pageOfItems;
  // }

  product_filter(filter: string): any[] {
    this.filterred_list = [];
    for (var i = 0; i < this.dishes_Data.length; i++) {
      if (this.dishes_Data[i].categories == filter) {
        this.filterred_list.push(this.dishes_Data[i]);
      }
    }
    return this.filterred_list;
  }

  ngOnInit() {
    this.get_DishList();
  }
}
