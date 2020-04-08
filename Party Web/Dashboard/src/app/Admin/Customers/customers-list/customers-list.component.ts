import { Component, OnInit, OnDestroy, AfterViewInit } from '@angular/core';
import { UserService } from '../../../_services/user.service';
import { StaffService } from '../../../_services/staff.service';
import { Subject } from 'rxjs';

// declare jquery;
declare var $: any;

interface Customer {
  user: any[]
}
@Component({
  selector: 'app-customers-list',
  templateUrl: './customers-list.component.html',
  styleUrls: ['./customers-list.component.css']
})
export class CustomersListComponent implements AfterViewInit, OnDestroy, OnInit {
  // customersList = [];
  customersList: Customer;

  // dtTrigger: Subject<any> = new Subject();

  constructor(
    public userService: UserService,
    private staffService: StaffService
  ) { }

  upgrade(username: string) {
    if (confirm("Are you sure to upgrade this user? " + username)) {
      this.staffService.upgradeCustomer(username);
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
    this.staffService.get_customersList().subscribe(
      res_data => {
        this.customersList = res_data.body as Customer;
      },
      err => {
        console.log("Error: " + err.status + " " + err.error.message);
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