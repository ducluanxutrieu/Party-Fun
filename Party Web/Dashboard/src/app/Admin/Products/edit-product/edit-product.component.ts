import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { api } from '../../../_api/apiUrl';
import { UserService } from '../../../_services/user.service';
import { ProductService } from '../../../_services/product.service';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-edit-product',
  templateUrl: './edit-product.component.html',
  styleUrls: ['./edit-product.component.css']
})
export class EditProductComponent implements OnInit {
  product_data;

  constructor(
    private http: HttpClient,
    public userService: UserService,
    private activatedRoute: ActivatedRoute,
    private productService: ProductService,
    private router: Router
  ) { }

  ngOnInit() {
    this.activatedRoute.params.subscribe(params => {
      var product_id = params['id'];
      this.product_data = this.productService.find(product_id);
    })
  }

  onClickSubmit(data: {
    name: string;
    description: string;
    type: string;
    price: number;
    promotion: number;
    // image1: File;
  }) {
    let body = `_id=${this.product_data._id}&name=${data.name}&description=${data.description}&price=${data.price}&discount=0&type=${data.type}`;
    // this.createFormData(body, 'image', this.imgArr);
    // body.append('image', this.imgArr[0]);
    let headers = new HttpHeaders({
      'Content-type': 'application/x-www-form-urlencoded',
      'Authorization': localStorage.getItem('token')
    })
    this.http.post(api.updateDish, body, { headers: headers, observe: 'response' }).subscribe(res_data => {
      sessionStorage.setItem('response_body', JSON.stringify(res_data.body));
      alert("Edit product success");
      this.router.navigate(['/products/list']);
    },
      err => {
        alert("Error: " + err.status + " " + err.statusText + "\n" + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }
  // fileChanged(event: any) {
  //   // this.imgArr.push(event.target.files);
  //   this.imgArr = event.target.files;
  // }
}
