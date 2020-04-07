import { Component, OnInit } from '@angular/core';

import { api } from '../../../_api/apiUrl';

import { StatisticalService } from '../../../_services/statistical.service';
import { UserService } from '../../../_services/user.service';
import { PaymentService } from '../../../_services/payment.service';
import { ProductService } from '../../../_services/product.service';
import { Subject } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';

// declare jquery;
declare var $: any;

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

  // dtTrigger: Subject<any> = new Subject();

  headers = new HttpHeaders({
    'Authorization': localStorage.getItem('token')
  })

  constructor(
    public userService: UserService,
    public statisticalService: StatisticalService,
    public paymentService: PaymentService,
    public productService: ProductService,
    private http: HttpClient,
  ) { }

  ngOnInit() {
    // this.recent_billList = this.statisticalService.get_billData();
    this.get_recentBills();
  }

  //Generate datatable 
  datatable_generate() {
    var recentbillTable = $('#recentbillTable').DataTable();
    var recentbillTable_info = recentbillTable.page.info();

    if (recentbillTable_info.pages == 1) {
      recentbillTable.destroy();
      $('#recentbillTable').DataTable({
        "paging": false
      });
    }
  }

  itemClicked(item: any) {
    if ($('#CartDetailModal').hasClass('show')) {
      $('#CartDetailModal').modal('hide');
    }
    else {
      this.current_bill = item;
      this.bill_detail = item.lishDishs;
    }
  }

  pay(bill_id: string) {
    if (confirm("Pay this bill?")) {
      this.paymentService.pay_bill(bill_id);
    };
  }

  delete_bill(bill_id) {
    if (confirm("Are you sure to delete this bill?")) {
      this.paymentService.delete_bill(bill_id);
    };
  }

  get_recentBills() {
    this.http.get(api.billStatistics, { headers: this.headers, observe: 'response' }).subscribe(
      res_data => {
        sessionStorage.setItem('recent_bills', JSON.stringify(res_data.body));
        this.recent_billList = JSON.parse(sessionStorage.getItem('recent_bills'));
        // this.dtTrigger.next();
        setTimeout(() => {
          this.datatable_generate();
        }, 1000)
      },
      err => {
        console.log("Error: " + err.status + " " + err.error.text);
        sessionStorage.setItem('error', JSON.stringify(err));
      }
    )
  }
}
