import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
// Services
import { ProductService } from '../../../_services/product.service';
import { CommonService } from '../../../_services/common.service';
// Models
import { Product } from '../../../_models/product.model';
import { Select2OptionData } from 'ng-select2';

@Component({
  selector: 'app-edit-product',
  templateUrl: './edit-product.component.html',
  styleUrls: ['./edit-product.component.css']
})
export class EditProductComponent implements OnInit {
  product_id: string;
  product_data: Product = new Product;
  product_imgs_files: any[];
  product_imgs_url: string[] = [];  // Mảng chứa url hình server trả về sau khi upload ảnh
  product_categories: string[] = []; // Mảng chứa dish category

  dish_categories: Array<Select2OptionData>;
  select2_options = {
    multiple: true,
    width: '300',
    tags: true
  };
  constructor(
    private activatedRoute: ActivatedRoute,
    private productService: ProductService,
    private commonService: CommonService,
  ) { }

  ngOnInit() {
    this.activatedRoute.params.subscribe(params => {
      this.product_id = params['id'];
      this.get_dish(this.product_id);
    });
    this.dish_categories = [
      {
        id: 'Holiday Offers',
        text: 'Holiday Offers'
      },
      {
        id: 'First Dishes',
        text: 'First Dishes'
      },
      {
        id: 'Main Dishes',
        text: 'Main Dishes'
      },
      {
        id: 'Seafood',
        text: 'Seafood'
      },
      {
        id: 'Dessert',
        text: 'Dessert'
      },
      {
        id: 'Drinks',
        text: 'Drinks'
      }
    ]
  }

  // Lấy thông tin món ăn
  get_dish(dish_id: string) {
    this.productService.get_dish(dish_id).subscribe(
      res => {
        this.product_data = res.data as Product;
        this.product_imgs_url = this.product_data.image;
      },
      err => {
        console.log("Error: " + err.error.message);
        alert("Error while getting dish info!");
      }
    )
  }
  // Xác nhận cập nhật món ăn
  update_confirm(data: {
    name: string;
    description: string;
    categories: string;
    price: number;
    discount: number;
  }) {
    console.log(data.categories);
    // Upload image lên server trước
    if (this.product_imgs_files) {
      this.commonService.upload_image(this.product_imgs_files).subscribe(
        res => {
          this.product_imgs_url = res.data;
        },
        err => {
          alert("Error: Upload image error!");
          sessionStorage.setItem('error', JSON.stringify(err));
          return;
        },
        // Sau khi upload hoàn tất, gửi request cập nhật món ăn
        () => {
          this.update_dish(data);
        }
      )
    }
    else {
      this.update_dish(data);
    }
  }

  // Update dish
  update_dish(data: {
    name: string;
    description: string;
    categories: string;
    price: number;
    discount: number;
  }) {
    // this.product_categories.push(data.categories); // Push category vào mảng
    let body = `_id=${this.product_id}&name=${data.name}&description=${data.description}&price=${data.price}&discount=${data.discount}&currency=vnd&categories=${JSON.stringify(data.categories)}&image=${JSON.stringify(this.product_imgs_url)}&feature_image=${this.product_imgs_url[0]}`;
    this.productService.update_dish(body).subscribe(
      res => {
        alert("Edit product success");
        // window.location.reload();
      },
      err => {
        alert("Error while update dish!");
        console.log(`Error + ${err.error.message}`);
      }
    )
  }
  // Lưu ảnh vào mảng
  fileChanged(event: any) {
    this.product_imgs_files = event.target.files;
  }
}
