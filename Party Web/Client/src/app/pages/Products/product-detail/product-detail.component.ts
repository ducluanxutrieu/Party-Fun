import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
// Services
import { ProductService } from '../../../_services/product.service';
// Models
import { Product } from '../../../_models/product.model';
import { Rating } from '../../../_models/rating.model';

interface Dish_rating {
  count_rate: number;
  avg_rate: number;
  list_rate: Rating[];
}
@Component({
  selector: 'app-product-detail',
  templateUrl: './product-detail.component.html',
  styleUrls: ['./product-detail.component.css']
})
export class ProductDetailComponent implements OnInit {
  product_data: Product; // Thông tin về món ăn được gọi
  product_ratings: Dish_rating;
  suggest_list = [];     // Danh sách các món tương tự

  products_list = []; // Tạm thời
  item_quantity = 1;

  constructor(
    private productService: ProductService,
    private activatedRoute: ActivatedRoute,
  ) { }

  ngOnInit() {
    this.products_list = JSON.parse(localStorage.getItem('dish_list')); // Tạm thời
    // Gọi api lấy thông tin món ăn
    this.activatedRoute.params.subscribe(params => {
      let product_id = params['id'];
      this.productService.get_dish(product_id).subscribe(
        res => {
          this.product_data = res.data as Product;
          this.get_suggestList(this.product_data.categories);
          // this.product_filter(this.product_data.categories); // tạm thời
        },
        err => {
          console.log("Error: " + err.error.message);
          sessionStorage.setItem('error', JSON.stringify(err));
        }
      );
      this.get_dishRating(product_id);
    })
  }
  // Lấy thông tin rating của món ăn
  get_dishRating(dish_id: string) {
    this.productService.get_dishRating(dish_id, 1).subscribe(
      res => {
        this.product_ratings = res.data as Dish_rating;
      },
      err => {
        console.log("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      }
    )
  }
  // Lấy danh sách sản phẩm tương tự
  get_suggestList(category: string) {
    this.productService.get_dish_by_category(category, 1).subscribe(
      res => {
        this.suggest_list = res.data.value as Product[];
      },
      err => {
        console.log("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      }
    )
  }

  // Tạm thời
  product_filter(filter: string) {
    for (var i = 0; i < this.products_list.length; i++) {
      if (this.products_list[i].categories == filter && this.products_list[i]._id != this.product_data._id) {
        this.suggest_list.push(this.products_list[i]);
      }
    }
  }

  // Thay đổi số lượng sản phẩm
  quantityChanged(event: any) {
    this.item_quantity = event.target.value;
  }
  // Thêm sản phẩm vào giỏ hàng
  addToCart() {
    this.productService.addCartItem(this.product_data._id, this.item_quantity);
  }
  // Lăn đến element
  scroll(el: HTMLElement) {
    el.scrollIntoView();
  }
}
