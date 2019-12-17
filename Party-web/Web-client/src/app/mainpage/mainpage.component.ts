import { Component, OnInit } from '@angular/core';
import { api } from '../_api/apiUrl';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';
import { ProductService } from '../_services/product.service';

@Component({
  selector: 'app-mainpage',
  templateUrl: './mainpage.component.html',
  styleUrls: ['./mainpage.component.css']
})
export class MainpageComponent implements OnInit {
  dishes_Data = [];
  pageOfItems: Array<any>;
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
    private router: Router,
    private productService: ProductService
  ) { }

  getDishList() {
    this.http.get(api.getdishlist, { observe: 'response' }).subscribe(
      res_data => {
        sessionStorage.setItem('response_body', JSON.stringify(res_data.body));
        var response_body = JSON.parse(sessionStorage.getItem('response_body'));
        this.dishes_Data = response_body.lishDishs;
        this.getNewProducts();
        // console.log(res_data.body);
      },
      err => {
        console.log("Lỗi: " + err.status + " " + err.statusText);
        sessionStorage.setItem('error', JSON.stringify(err));
      }
    );
  }
  getNewProducts() {
    let temp_product_list = this.productService.findAll();
    // let temp_product_list = JSON.parse(localStorage.getItem('dish-list'));
    for (var i = temp_product_list.length - 1; i > temp_product_list.length - 4; i--) {
      this.new_products.push(temp_product_list[i]);
    }
    console.log(this.new_products);
  }
  addCart_clicked(id: string) {
    // this.router.navigate(['/cart', { id: id }]);
    this.productService.addCartItem(id, 1);
  }

  onChangePage(pageOfItems: Array<any>) {
    // update current page of items
    this.pageOfItems = pageOfItems;
  }
  // category_clicked(filter: string) {
  //   this.router.navigate(['/category', filter]);
  // }
  product_filter(filter: string): any[] {
    this.filterred_list = [];
    for (var i = 0; i < this.dishes_Data.length; i++) {
      if (this.dishes_Data[i].type == filter) {
        this.filterred_list.push(this.dishes_Data[i]);
      }
    }
    return this.filterred_list;
  }
  ngOnInit() {
    this.getDishList();
    // this.dishes_Data = JSON.parse(localStorage.getItem('dish-list'));
    // this.getNewProducts();
  }
}
