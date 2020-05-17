import { Component, OnInit, ViewChild } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { NgForm } from '@angular/forms';
// Services
import { api } from '../../../_api/apiUrl';
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
    private http: HttpClient,
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
    // var body = new FormData();
    // body.append('name', data.name);
    // body.append('description', data.description);
    // body.append('price', data.price);
    // body.append('discount', "0"); //discount temp disable
    // body.append('type', data.type);
    // //   this.createFormData(body, 'image', this.product_imgs);
    // body.append('image', this.product_imgs[0]);
    // let headers = new HttpHeaders({
    //   'Authorization': localStorage.getItem('token')
    // })
    // this.http.post(api.add_dish, body, { headers: headers, observe: 'response' }).subscribe(res_data => {
    //   sessionStorage.setItem('response_body', JSON.stringify(res_data.body));
    //   alert("Add product success");
    //   this.product_form.reset();
    // },
    //   err => {
    //     alert("Error: " + err.status + " " + err.statusText + "\n" + err.error.message);
    //     sessionStorage.setItem('error', JSON.stringify(err));
    //   })
    this.commonService.upload_image(this.product_imgs_files).subscribe(
      res => {
        this.product_imgs_urls = res.data;
        console.log(this.product_imgs_urls);
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
    // this.product_imgs.push(event.target.files);
    this.product_imgs_files = event.target.files;
  }
}