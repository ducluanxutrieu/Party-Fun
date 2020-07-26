import { Component, OnInit, Input } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { ActivatedRoute, Router } from '@angular/router';

// Models
import { Bill, Bill_item } from '../../../_models/bill.model';
//Services
import { StatisticalService } from '../../../_services/statistical.service';
import { PaymentService } from '../../../_services/payment.service';
import { ProductService } from '../../../_services/product.service';


declare var $: any;
@Component({
  selector: 'app-all-bills',
  templateUrl: './all-bills.component.html',
  styleUrls: ['./all-bills.component.css']
})
export class AllBillsComponent implements OnInit {
  @Input('data') all_bills: Bill[] = [];
  page: number = 1;
  total_pages: number;

  bill_detail: Bill_item[] = [];
  current_bill: Bill;

  constructor(
    public statisticalService: StatisticalService,
    public paymentService: PaymentService,
    public productService: ProductService,
    private toastr: ToastrService,
    private activatedRoute: ActivatedRoute,
    private router: Router
  ) { }

  ngOnInit() {
    this.onload();
  }

  private onload() {
    this.activatedRoute.params.subscribe(params => {
      this.page = params['page'];
      this.get_allBills(this.page);
    })
  }

  get_page(page: number) {
    this.router.navigate(['bills/all-bills/', page]).then(() => {
      window.location.reload();
    });
  }

  // Tạo datatables 
  datatable_generate() {
    $('#allBillTable').DataTable({ "paging": false });
  }

  // Khi click vào bill trong list
  itemClicked(item: Bill) {
    this.current_bill = item;
    this.bill_detail = item.dishes;
  }

  // Thanh toán bill
  pay(bill_id: string) {
    if (confirm("Pay this bill?")) {
      this.paymentService.pay_bill(bill_id);
    };
  }

  // // Xóa bill
  // delete_bill(bill_id) {
  //   if (confirm("Are you sure to delete this bill?")) {
  //     this.paymentService.delete_bill(bill_id);
  //   };
  // }

  // Lấy danh sách bill và tạo datatable
  get_allBills(page: number) {
    this.paymentService.get_bills_list(page).subscribe(
      res => {
        this.all_bills = res.data.value as Bill[];
        this.total_pages = res.data.total_page;
      },
      err => {
        console.log("Error: " + err.error.text);
      },
      () => {
        setTimeout(() => {
          this.datatable_generate();
        })
      }
    )
  }

  // Xác nhận đơn hàng
  confirm_bill(note: string) {
    this.paymentService.confirm_bill(this.current_bill._id, note).subscribe(
      res => {
        this.toastr.success("Confirm bill success!");
        this.onload();
      },
      err => {
        this.toastr.error("Failed confirm bill!");
        console.error("Error: " + err.error.message);
      }
    )
  }

  // Hủy đơn hàng
  cancel_bill(note: string) {
    this.paymentService.cancel_bill(this.current_bill._id, note).subscribe(
      res => {
        this.toastr.success("Cancel bill success!");
        this.onload();
      },
      err => {
        this.toastr.error("Failed cancel bill!");
        console.error("Error: " + err.error.message);
      }
    )
  }
}
