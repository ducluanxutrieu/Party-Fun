import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

// Services
import { ProductService } from '../../../_services/product.service';
// Models
import { Product } from '../../../_models/product.model';

@Component({
  selector: 'app-product-category',
  templateUrl: './product-category.component.html',
  styleUrls: ['./product-category.component.css']
})
export class ProductCategoryComponent implements OnInit {
  // products_data: Product[] = [];
  filtered_products: Product[] = [];
  cat_filter: string;
  total_pages: number;
  current_index: number = 1;
  // pageOfItems: Array<any>;

  constructor(
    private productService: ProductService,
    private activatedRoute: ActivatedRoute,
  ) { }

  // Thêm vào giỏ hàng
  addCart(id: string) {
    this.productService.addCartItem(id, 1);
  }

  // Lấy danh sách món ăn theo category
  get_dishes_byCate(category: string, page: number) {
    this.productService.get_dish_by_category(category, page).subscribe(
      res => {
        this.filtered_products = res.data.value as Product[];
        this.total_pages = res.data.total_page;
      },
      err => {
        console.log("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      }
    )
  }

  // Đổi trang
  change_page(page: number) {
    if (page > 0 && page <= this.total_pages) {
      this.get_dishes_byCate(this.cat_filter, page);
      this.current_index = page;
    }
  }
  // onChangePage(pageOfItems: Array<any>) {
  //   this.pageOfItems = pageOfItems;
  // }

  // product_filter(filter: string) {
  //   for (var i = 0; i < this.products_data.length; i++) {
  //     if (this.products_data[i].categories == filter) {
  //       this.filtered_products.push(this.products_data[i]);
  //     }
  //   }
  // }

  ngOnInit() {
    // this.products_data = JSON.parse(localStorage.getItem('dish_list'));
    this.activatedRoute.params.subscribe(params => {
      this.cat_filter = params['filter'];
      this.get_dishes_byCate(this.cat_filter, 1);
    })
  }
}
