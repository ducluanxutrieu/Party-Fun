import { Component, OnInit } from '@angular/core';

import { ProductService } from '../../_services/product.service';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-product-detail',
  templateUrl: './product-detail.component.html',
  styleUrls: ['./product-detail.component.css']
})
export class ProductDetailComponent implements OnInit {
  product_data;
  products_list = [];
  suggest_list = [];
  item_quantity = 1;

  constructor(
    private productService: ProductService,
    private activatedRoute: ActivatedRoute,
  ) { }

  ngOnInit() {
    this.products_list = JSON.parse(localStorage.getItem('dish_list'));
    this.activatedRoute.params.subscribe(params => {
      var product_id = params['id'];
      this.product_data = this.productService.find(product_id);
    })
    // console.log(this.product_data);
    this.product_filter(this.product_data.type);
  }

  quantityChanged(event: any) {
    this.item_quantity = event.target.value;
  }
  addToCart() {
    this.productService.addCartItem(this.product_data._id, this.item_quantity);
  }

  product_filter(filter: string) {
    for (var i = 0; i < this.products_list.length; i++) {
      if (this.products_list[i].type == filter && this.products_list[i]._id != this.product_data._id) {
        this.suggest_list.push(this.products_list[i]);
      }
    }
  }
  scroll(el: HTMLElement) {
    el.scrollIntoView();
  }
}
