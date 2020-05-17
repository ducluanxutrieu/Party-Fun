import { Component, OnInit, OnDestroy, AfterViewInit } from '@angular/core';
import { StaffService } from '../../../_services/staff.service';

// declare jquery;
declare var $: any;

interface Customer {
  _id: string;
  full_name: string;
  username: string;
  avatar: string;
}
@Component({
  selector: 'app-customers-list',
  templateUrl: './customers-list.component.html',
  styleUrls: ['./customers-list.component.css']
})
export class CustomersListComponent implements AfterViewInit, OnDestroy, OnInit {
  customers_list: Customer[] = [];

  // dtTrigger: Subject<any> = new Subject();

  constructor(
    private staffService: StaffService
  ) { }

  upgrade(user_id: string) {
    if (confirm("Are you sure to upgrade this user?")) {
      this.staffService.upgradeCustomer(user_id);
    };
  }

  //Generate datatable 
  datatable_generate() {
    var customerTable = $('#customerTable').DataTable();
    var customerTable_info = customerTable.page.info();

    if (customerTable_info.pages == 1) {
      customerTable.destroy();
      $('#customerTable').DataTable({
        "paging": false
      });
    }
  }

  ngOnInit() {
    this.get_customerList();
  }
  get_customerList() {
    this.staffService.get_customersList(1).subscribe(
      res => {
        this.customers_list = res.data.value as Customer[];
      },
      err => {
        console.log("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      },
      () => {
        setTimeout(() => {
          // this.dtTrigger.next();
          this.datatable_generate();
        })
      });
  }

  ngAfterViewInit(): void {
    // this.dtTrigger.next();
  }

  ngOnDestroy(): void {
    // this.dtTrigger.unsubscribe();
  }
}