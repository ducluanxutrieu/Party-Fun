import { Component, OnInit } from '@angular/core';
import { HttpHeaders, HttpClient } from '@angular/common/http';
import { api } from '../../../_api/apiUrl';

import { ProductService } from '../../../_services/product.service';
import { UserService } from '../../../_services/user.service';
import { PaymentService } from '../../../_services/payment.service';

@Component({
  selector: 'app-pay',
  templateUrl: './pay.component.html',
  styleUrls: ['./pay.component.css']
})
export class PayComponent implements OnInit {
  bill_info = [];
  haveBill: boolean;
  bill_detail = [];
  headers = new HttpHeaders({
    'Content-type': 'application/x-www-form-urlencoded',
    'Authorization': localStorage.getItem('token')
  })

  constructor(
    public userService: UserService,
    public productService: ProductService,
    public paymentService: PaymentService,
    private http: HttpClient
  ) { }

  ngOnInit() {
  }
  itemClicked(item: any) {
    this.bill_detail = item.lishDishs;
  }

  searchBill(data: {
    username: string
  }) {
    let body = `name=${data.username}`;
    // const option = {
    //   headers: this.headers,
    //   body: {
    //     name: data.username
    //   },
    // }
    this.http.post(api.findbill, body, { headers: this.headers }).subscribe(
      res_data => {
        sessionStorage.setItem('response_body', JSON.stringify(res_data));
        var temp = JSON.parse(sessionStorage.getItem('response_body'));
        this.bill_info = temp.bill;
        // console.log(this.bill_info);
        this.haveBill = true;
      },
      err => {
        alert("Error: " + err.status + " - " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
        this.haveBill = false;
      }
    )
  }
  pay(id: string) {
    if (confirm("Pay this bill?")) {
      let body = `_id=${id}`;
      this.http.post(api.pay, body, { headers: this.headers }).subscribe(
        res_data => {
          sessionStorage.setItem('response_body', JSON.stringify(res_data));
          alert("Paid success!");
        },
        err => {
          alert("Error: " + err.status + " - " + err.error.message);
          sessionStorage.setItem('error', JSON.stringify(err));
        }
      )
    };
  }
  delete_bill(bill_id) {
    if (confirm("Are you sure to delete this bill?")) {
      this.paymentService.delete_bill(bill_id);
      window.location.reload();
    };
  }
}
