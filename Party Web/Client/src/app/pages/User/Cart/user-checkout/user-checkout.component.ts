import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { DatePipe } from '@angular/common';
import { Router } from '@angular/router';
// Services
import { api } from '../../../../_api/apiUrl';
// Models
import { Item } from '../../../../_models/item.model';
import { Bill } from '../../../../_models/bill.model';
import { ApiResponse } from '../../../../_models/response.model';

declare var toastr;

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
    private http: HttpClient,
    public datepipe: DatePipe,
    private router: Router
  ) { }

  ngOnInit() {
    this.loadCart();
  }

  order_comfirm() {
    let headers = new HttpHeaders({
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': localStorage.getItem('token'),
    })
    var item_ordered: any[] = [];
    for (var i = 0; i < this.items.length; i++) {
      var item = this.items[i];
      item_ordered.push(
        {
          _id: item.product._id,
          count: item.quantity
        }
      )
    }
    let body = `dishes=${JSON.stringify(item_ordered)}&table=${this.numOfTable}&date_party=${this.deliveryDate}&count_customer=1`;
    this.http.post<ApiResponse>(api.book, body, { headers: headers }).subscribe(
      res => {
        let receipt = res.data as Bill;
        sessionStorage.setItem('response', JSON.stringify(res));
        toastr.success("Order success!");
        localStorage.removeItem('cart');
        sessionStorage.setItem('current_receipt', JSON.stringify({
          items: this.items,
          numOfTable: this.numOfTable,
          dateParty: this.deliveryDate,
          total_price: this.total
        }))
        this.router.navigate(['/receipt/' + receipt._id]);
      },
      err => {
        // console.log(err);
        // if (err.status == 400) {
        //   toastr.warning('Please fill all the field with valid value!');
        // } else {
        //   toastr.error("Error: " + err.status + " " + err.error.message);
        // }
        toastr.error("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }

  changeOfTable(event: any) {
    this.numOfTable = event.target.value;
  }
  changeOfDate(event: any) {
    this.deliveryDate = event.target.value;
    this.deliveryDate = this.datepipe.transform(this.deliveryDate, 'MM/dd/yyyy HH:mm');

    // let today = new Date();
    // if (this.deliveryDate < this.datepipe.transform(today), 'MM/dd/yyyy HH:mm') {
    //   toastr.error("Cannot choose day smaller than current date!");
    //   $('#deliveryDate').val('');
    // }
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
