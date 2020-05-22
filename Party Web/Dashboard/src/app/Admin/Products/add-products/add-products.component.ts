import { Component, OnInit, ViewChild } from '@angular/core';
import { NgForm } from '@angular/forms';
// Services
import { CommonService } from '../../../_services/common.service';
import { ProductService } from '../../../_services/product.service';

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
  constructor(
    private commonService: CommonService,
    private productService: ProductService,
  ) { }

  ngOnInit() { }
  onClickSubmit(data: {
    name: string;
    description: string;
    type: string;
    price: string;
    discount: string;
  }) {
    this.commonService.upload_image(this.product_imgs_files).subscribe(
      res => {
        this.product_imgs_urls = res.data;
      },
      err => {
        alert("Error: Upload image error!");
        sessionStorage.setItem('error', JSON.stringify(err));
        return;
      },
      () => {
        this.product_categories.push(data.type);
        let body = `name=${data.name}&description=${data.description}&price=${data.price}&categories=${JSON.stringify(this.product_categories)}&discount=${data.discount}&image=${JSON.stringify(this.product_imgs_urls)}&feature_image=${this.product_imgs_urls[0]}&currency=vnd`;
        this.productService.add_dish(body).subscribe(
          res => {
            sessionStorage.setItem('response', JSON.stringify(res));
            alert("Add product success");
            this.product_form.reset();
          },
          err => {
            alert("Error: " + err.error.message);
            sessionStorage.setItem('error', JSON.stringify(err));
          }
        )
      }
    )
  }
  fileChanged(event: any) {
    this.product_imgs_files = event.target.files;
  }
}