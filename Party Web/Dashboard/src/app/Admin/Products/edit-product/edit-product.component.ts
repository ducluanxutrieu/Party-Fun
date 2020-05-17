import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
// Services
import { ProductService } from '../../../_services/product.service';
import { CommonService } from '../../../_services/common.service';
// Models
import { Product } from '../../../_models/product.model';

@Component({
  selector: 'app-edit-product',
  templateUrl: './edit-product.component.html',
  styleUrls: ['./edit-product.component.css']
})
export class EditProductComponent implements OnInit {
  product_id: string;
  product_data: Product;
  product_imgs_files = [];
  product_imgs_url: string[] = [];  // Mảng chứa url hình server trả về sau khi upload ảnh
  product_categories: string[] = []; // Mảng chứa dish category
  constructor(
    private activatedRoute: ActivatedRoute,
    private productService: ProductService,
    private commonService: CommonService,
    private router: Router
  ) { }

  ngOnInit() {
    this.activatedRoute.params.subscribe(params => {
      this.product_id = params['id'];
      this.product_data = this.productService.find(this.product_id);
    })
  }
  // Xác nhận cập nhật món ăn
  update_confirm(data: {
    name: string;
    description: string;
    type: string;
    price: number;
    discount: number;
  }) {
    this.product_categories.push(data.type); // Push category vào mảng
    // Upload image lên server trước
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
        let body = `_id=${this.product_id}&name=${data.name}&description=${data.description}&price=${data.price}&discount=${data.discount}&currency=vnd&categories=${JSON.stringify(data.type)}&image=${JSON.stringify(this.product_imgs_url)}&feature_image=${this.product_imgs_url[0]}`;
        this.productService.update_dish(body).subscribe(
          res => {
            sessionStorage.setItem('response', JSON.stringify(res));
            console.log(res);
            alert("Edit product success");
            this.router.navigate(['/products/list']);
          },
          err => {
            alert("Error: " + err.error.message);
            sessionStorage.setItem('error', JSON.stringify(err));
          }
        )
      }
    )
  }
  // Lưu ảnh vào mảng
  fileChanged(event: any) {
    this.product_imgs_files = event.target.files;
  }
  // fileChanged(event: any) {
  //   // this.imgArr.push(event.target.files);
  //   this.imgArr = event.target.files;
  // }
}
