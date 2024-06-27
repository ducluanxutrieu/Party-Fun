import { Component, OnInit, Input } from '@angular/core';
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
  @Input('data') filtered_products: Product[] = [];
  page: number = 1;
  total_pages: number;

  cat_filter: string;
  // pageOfItems: Array<any>;

  constructor(
    private productService: ProductService,
    private activatedRoute: ActivatedRoute,
  ) { }

  // Thêm vào giỏ hàng
  addCart(id: string) {
    this.productService.addCartItem(id, 1);
  }

  get_page(page: number) {
    this.get_dishes_byCate(this.cat_filter, page);
  }

  // Lấy danh sách món ăn theo category
  get_dishes_byCate(category: string, page: number) {
    this.productService.get_dish_by_category(category, page).subscribe(
      res => {
        this.filtered_products = res.data.value as Product[];
        this.total_pages = res.data.total_page;
        this.page = page;
      },
      err => {
        console.log("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      }
    )
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
