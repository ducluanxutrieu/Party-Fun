import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { DatePipe } from '@angular/common';
import { Router } from '@angular/router';

import { Item } from '../../../../_models/item.model';
import { ProductService } from '../../../../_services/product.service';
import { api } from '../../../../_api/apiUrl'

@Component({
  selector: 'app-user-checkout',
  templateUrl: './user-checkout.component.html',
  styleUrls: ['./user-checkout.component.css']
})
export class UserCheckoutComponent implements OnInit {
  items: Item[] = [];
  total: number = 0;
  private numOfTable = 1;
  private deliveryDate;
  // private deliveryTime;

  constructor(
    private productService: ProductService,
    private http: HttpClient,
    public datepipe: DatePipe,
    private router: Router
  ) { }

  ngOnInit() {
    this.loadCart();
  }

  order_comfirm() {
    var token = localStorage.getItem('token');
    let headers = new HttpHeaders({
      'Authorization': token,
      'Content-Type': 'application/x-www-form-urlencoded'
    })
    var item_ordered: any[] = [];
    for (var i = 0; i < this.items.length; i++) {
      var item = this.items[i];
      item_ordered.push(
        {
          _id: item.product._id,
          numberDish: item.quantity
        }
      )
    }
    let body = `lishDishs=${JSON.stringify(item_ordered)}&numbertable=${this.numOfTable}&dateParty=${this.deliveryDate}&discount="0"`;
    console.log(body);
    this.http.post(api.orderConfirm, body, { headers: headers, observe: 'response' }).subscribe(res_data => {
      sessionStorage.setItem('response_body', JSON.stringify(res_data.body));
      alert("Order success!");
      localStorage.removeItem('cart');
      this.router.navigate(['/cart']);
    },
      err => {
        alert("Error: " + err.status);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }

  changeOfTable(event: any) {
    this.numOfTable = event.target.value;
  }
  changeOfDate(event: any) {
    this.deliveryDate = event.target.value;
    this.deliveryDate = this.datepipe.transform(this.deliveryDate, 'MM/dd/yyyy HH:mm');
  }
  // changeOfTime(event: any) {
  //   this.deliveryTime = event.target.value;
  // }

  loadCart(): void {
    this.total = 0;
    this.items = [];
    let cart = JSON.parse(localStorage.getItem('cart'));
    for (var i = 0; i < cart.length; i++) {
      let item = cart[i];
      this.items.push({
        product: item.product,
        quantity: item.quantity
      });
      this.total += item.product.price * item.quantity;
    }
  }
}
