import { Component, OnInit } from '@angular/core';

// Services
import { StatisticalService } from '../../../_services/statistical.service';
import { PaymentService } from '../../../_services/payment.service';
import { ProductService } from '../../../_services/product.service';
// Models
import { Bill, Bill_item } from '../../../_models/bill.model';
import { Subject } from 'rxjs';

// declare jquery;
declare var $: any;

@Component({
  selector: 'app-recent-bills',
  templateUrl: './recent-bills.component.html',
  styleUrls: ['./recent-bills.component.css']
})

export class RecentBillsComponent implements OnInit {
  dtOptions: DataTables.Settings = {};
  total_pages: number;
  recent_bills: Bill[] = [];
  bill_detail: Bill_item[] = [];
  current_bill: Bill;

  dtTrigger: Subject<any> = new Subject(); 

  constructor(
    public statisticalService: StatisticalService,
    public paymentService: PaymentService,
    public productService: ProductService,
  ) { }

  ngOnInit() {
    // this.recent_billList = this.statisticalService.get_billData();
    this.get_recentBills(1);
    this.dtOptions = {
      "paging": false,
    }
  }

  //Generate datatable 
  datatable_generate() {
    if ($.fn.DataTable.isDataTable('#recentbillTable')) {
      console.log(1);
      $('#recentbillTable').DataTable().fnDraw();
    }

    $('#recentbillTable').DataTable({
      "paging": false,
      "bInfo": false,
    });
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

  // Thanh toán bill
  pay(bill_id: string) {
    if (confirm("Pay this bill?")) {
      this.paymentService.pay_bill(bill_id);
    };
  }

  // Xóa bill
  delete_bill(bill_id) {
    if (confirm("Are you sure to delete this bill?")) {
      this.paymentService.delete_bill(bill_id);
    };
  }

  // Lấy danh sách bill và tạo datatable
  get_recentBills(page: number) {
    this.paymentService.get_bills_list(page).subscribe(
      res => {
        this.recent_bills = res.data.value as Bill[];
        this.total_pages = res.data.total_page;
        this.dtTrigger.next();
      },
      err => {
        console.log("Error: " + err.error.text);
        sessionStorage.setItem('error', JSON.stringify(err));
      },
      // () => {
      //   setTimeout(() => {
      //     this.datatable_generate();
      //   }, 1000)
      // }
    )
  }
}