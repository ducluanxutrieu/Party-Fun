import { Component, OnInit, OnDestroy, AfterViewInit } from '@angular/core';
import { UserService } from '../../../_services/user.service';
import { StaffService } from '../../../_services/staff.service';
import { Subject } from 'rxjs';

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

  dtTrigger: Subject<any> = new Subject();
  constructor(
    public userService: UserService,
    private staffService: StaffService
  ) { }

  upgrade(username: string) {
    if (confirm("Are you sure to upgrade this user? " + username)) {
      this.staffService.upgradeCustomer(username);
    };
  }

  ngOnInit() {
    this.staffService.customersList.subscribe(data => {
      this.customersList = data;
    });
    setTimeout(() => {
      this.dtTrigger.next();
    }, 1000)
    // $(document).ready(function() {
    //   $('#customertable').DataTable();
    // } );
  }
  ngAfterViewInit(): void {
    // this.dtTrigger.next();
  }
  ngOnDestroy(): void {
    this.dtTrigger.unsubscribe();
  }
}