import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

// Services
import { api } from '../../../_api/apiUrl';
import { StatisticalService } from '../../../_services/statistical.service';
import { PaymentService } from '../../../_services/payment.service';
import { ProductService } from '../../../_services/product.service';
// Models
import { Bill, Bill_item } from '../../../_models/bill.model';

// declare jquery;
declare var $: any;

@Component({
  selector: 'app-recent-bills',
  templateUrl: './recent-bills.component.html',
  styleUrls: ['./recent-bills.component.css']
})

export class RecentBillsComponent implements OnInit {
  recent_bills: Bill[] = [];
  bill_detail: Bill_item[] = [];
  current_bill: Bill;

  // dtTrigger: Subject<any> = new Subject();

  headers = new HttpHeaders({
    'Authorization': localStorage.getItem('token')
  })

  constructor(
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

  // Khi click vào bill trong list
  itemClicked(item: Bill) {
    if ($('#CartDetailModal').hasClass('show')) {
      $('#CartDetailModal').modal('hide');
    }
    else {
      this.current_bill = item;
      this.bill_detail = item.dishes;
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

  // Lấy danh sách bill và tạo datatable
  get_recentBills() {
    // this.http.get(api.get_bills_list, { headers: this.headers, observe: 'response' }).subscribe(
    //   res_data => {
    //     sessionStorage.setItem('recent_bills', JSON.stringify(res_data.body));
    //     this.recent_bills = JSON.parse(sessionStorage.getItem('recent_bills'));
    //     // this.dtTrigger.next();
    //     // setTimeout(() => {
    //     //   this.datatable_generate();
    //     // }, 1000)
    //   },
    //   err => {
    //     console.log("Error: " + err.status + " " + err.error.text);
    //     sessionStorage.setItem('error', JSON.stringify(err));
    //   },
    //   () => {
    //     setTimeout(() => {
    //       this.datatable_generate();
    //     })
    //   }
    // )
    this.paymentService.get_bills_list(1).subscribe(
      res => {
        this.recent_bills = res.data.value as Bill[];
      },
      err => {
        console.log("Error: " + err.error.text);
        sessionStorage.setItem('error', JSON.stringify(err));
      },
      () => {
        setTimeout(() => {
          this.datatable_generate();
        })
      }
    )
  }
}
