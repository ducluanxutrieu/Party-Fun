import { Component, OnInit } from '@angular/core';
import { api } from '../../../_api/apiUrl';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { ProductService } from '../../../_services/product.service'


@Component({
  selector: 'app-products-list',
  templateUrl: './products-list.component.html',
  styleUrls: ['./products-list.component.css']
})
export class ProductsListComponent implements OnInit {
  product_data = [];

  constructor(
    private http: HttpClient,
    private productService: ProductService
  ) { }

  ngOnInit() {
    this.product_data = JSON.parse(localStorage.getItem('dish-list'));
    //this.product_data = this.productService.getDishList();
  }

}
