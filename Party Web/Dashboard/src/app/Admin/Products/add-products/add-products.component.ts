import { Component, OnInit, ViewChild } from '@angular/core';
import { NgForm } from '@angular/forms';
// Services
import { CommonService } from '../../../_services/common.service';
import { ProductService } from '../../../_services/product.service';
import { Select2OptionData } from 'ng-select2';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-add-products',
  templateUrl: './add-products.component.html',
  styleUrls: ['./add-products.component.css']
})
export class AddProductsComponent implements OnInit {
  @ViewChild('adddishForm', null) product_form: NgForm;

  product_imgs_files = [];
  product_imgs_urls: string[] = []; // Mảng chứa url hình server trả về sau khi upload ảnh
  product_categories: string[] = []; // Mảng chứa dish category

  dish_categories: Array<Select2OptionData>;
  select2_options = {
    multiple: true,
    width: '300',
    tags: true
  };
  constructor(
    private commonService: CommonService,
    private productService: ProductService,
    private toastr: ToastrService
  ) { }

  ngOnInit() {
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
  onClickSubmit(data: {
    name: string;
    description: string;
    price: string;
    discount: string;
    categories: string[];
  }) {
    this.commonService.upload_image(this.product_imgs_files).subscribe(
      res => {
        this.product_imgs_urls = res.data;
      },
      err => {
        this.toastr.error("Error: Upload image error!");
        console.log("Error: " + err.error.message);
        return;
      },
      () => {
        // this.product_categories.push(data.type);
        let body = `name=${data.name}&description=${data.description}&price=${data.price}&categories=${JSON.stringify(data.categories)}&discount=${data.discount}&image=${JSON.stringify(this.product_imgs_urls)}&feature_image=${this.product_imgs_urls[0]}&currency=vnd`;
        this.productService.add_dish(body).subscribe(
          res => {
            sessionStorage.setItem('response', JSON.stringify(res));
            this.toastr.success("Add product success");
            this.product_form.reset();
          },
          err => {
            this.toastr.error("Error while adding dish!");
            console.log("Error: " + err.error.message);
          }
        )
      }
    )
  }
  fileChanged(event: any) {
    this.product_imgs_files = event.target.files;
  }
}