import { Component, OnInit } from '@angular/core';
import { api } from '../../../_api/apiUrl';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { ProductService } from '../../../_services/product.service';
import { UserService } from '../../../_services/user.service';


@Component({
  selector: 'app-products-list',
  templateUrl: './products-list.component.html',
  styleUrls: ['./products-list.component.css']
})
export class ProductsListComponent implements OnInit {
  product_data = [];

  constructor(
    private http: HttpClient,
    private productService: ProductService,
    public userService: UserService
  ) { }

  product_delete(id: string) {
    let headers = new HttpHeaders({
      'Authorization': localStorage.getItem('token')
    })
    const option = {
      headers: headers,
      body: {
        _id: id
      },
    }
    this.http.delete(api.deleteDish, option).subscribe(
      res_data => {
        sessionStorage.setItem('response_body', JSON.stringify(res_data));
        alert("Delete product success!");
        window.location.reload();
      },
      err => {
        alert("Error: " + err.status + " - " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      }
    )
  }
  delete_clicked(id: string, name: string) {
    if (confirm("Are you sure to delete this?\n" + name)) {
      this.product_delete(id);
      console.log(id);
    }
  }
  ngOnInit() {
    //this.product_data = JSON.parse(localStorage.getItem('dish-list'));
    this.product_data = this.productService.findAll();
    this.productService.productList.subscribe(data => this.product_data = data);
  }

}
