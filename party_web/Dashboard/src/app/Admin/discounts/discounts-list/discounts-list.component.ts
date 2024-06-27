import { Component, OnInit } from '@angular/core';
// Models
import { Discount } from '../../../_models/discount.model';
// Services
import { PaymentService } from '../../../_services/payment.service';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-discounts-list',
  templateUrl: './discounts-list.component.html',
  styleUrls: ['./discounts-list.component.css']
})
export class DiscountsListComponent implements OnInit {
  discounts_list: Discount[] = [];

  constructor(
    private paymentService: PaymentService,
    private toastr: ToastrService
  ) { }

  ngOnInit() {
    this.get_discounts_list();
  }

  // Lấy danh sách mã giảm giá
  get_discounts_list() {
    this.paymentService.get_discounts_list().subscribe(
      res => {
        this.discounts_list = res.data as Discount[];
      },
      err => {
        this.toastr.error("Error while getting discounts list!");
        console.log("Error: " + err.error.message);
      },
      () => {
        setTimeout(() => {
          this.datatable_generate();
        })
      }
    );
  }

  // Tạo datatable 
  datatable_generate() {
    var discountTable = $('#discountTable').DataTable();
    var discountTable_info = discountTable.page.info();

    if (discountTable_info.pages == 1) {
      discountTable.destroy();
      $('#discountTable').DataTable({
        "paging": false
      });
    }
  }
}
