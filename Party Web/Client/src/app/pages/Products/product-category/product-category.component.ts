import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { ActivatedRoute } from '@angular/router';
import { Router } from '@angular/router';

import { ProductService } from '../../../_services/product.service';


@Component({
  selector: 'app-product-category',
  templateUrl: './product-category.component.html',
  styleUrls: ['./product-category.component.css']
})
export class ProductCategoryComponent implements OnInit {
  products_data = [];
  filtered_products = [];
  cat_filter: string;
  pageOfItems: Array<any>;

  constructor(
    private http: HttpClient,
    private router: Router,
    private productService: ProductService,
    private activatedRoute: ActivatedRoute,
  ) { }

  addCart_clicked(id: string) {
    this.productService.addCartItem(id, 1);
  }

  onChangePage(pageOfItems: Array<any>) {
    this.pageOfItems = pageOfItems;
  }

  product_filter(filter: string) {
    for (var i = 0; i < this.products_data.length; i++) {
      if (this.products_data[i].type == filter) {
        this.filtered_products.push(this.products_data[i]);
      }
    }
  }

  ngOnInit() {
    this.products_data = JSON.parse(localStorage.getItem('dish_list'));
    this.activatedRoute.params.subscribe(params => {
      this.cat_filter = params['filter'];
      this.product_filter(this.cat_filter);
    })
  }

}
