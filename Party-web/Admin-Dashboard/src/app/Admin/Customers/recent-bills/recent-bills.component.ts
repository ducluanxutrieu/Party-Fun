import { Component, OnInit } from '@angular/core';

import { api } from '../../../_api/apiUrl';

import { StatisticalService } from '../../../_services/statistical.service';
import { UserService } from '../../../_services/user.service';
import { PaymentService } from '../../../_services/payment.service';
import { ProductService } from '../../../_services/product.service';

// declare var jquery: any;
// declare var $: any;

interface RecentBill {
  _id: string;
  lishDishs: [];
  dateParty: string;
  numbertable: number;
  username: string;
  createAt: string;
  paymentstatus: boolean;
  totalMoney: number;
  userpayment;
  paymentAt: string;
  phoneNumber: number;
  email: string;
}
@Component({
  selector: 'app-recent-bills',
  templateUrl: './recent-bills.component.html',
  styleUrls: ['./recent-bills.component.css']
})
export class RecentBillsComponent implements OnInit {
  recent_billList = [];
  bill_detail = [];
  current_bill: RecentBill;

  constructor(
    public userService: UserService,
    public statisticalService: StatisticalService,
    public paymentService: PaymentService,
    public productService: ProductService
  ) { }

  ngOnInit() {
    this.recent_billList = this.statisticalService.get_billData();
  }

  itemClicked(item: any) {
    this.current_bill = item;
    this.bill_detail = item.lishDishs;
  }
  pay(bill_id: string) {
    if (confirm("Pay this bill?")) {
      this.paymentService.pay_bill(bill_id);
      // window.location.reload();
    };
  }
  delete_bill(bill_id) {
    if (confirm("Are you sure to delete this bill?")) {
      this.paymentService.delete_bill(bill_id);
      // window.location.reload();
    };
  }
}
