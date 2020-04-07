import { Component, OnInit, OnDestroy, AfterViewInit } from '@angular/core';
import { UserService } from '../../../_services/user.service';
import { StaffService } from '../../../_services/staff.service';
import { Subject } from 'rxjs';

// declare jquery;
declare var $: any;

interface Staff {
  user: any[]
}

@Component({
  selector: 'app-employees-list',
  templateUrl: './employees-list.component.html',
  styleUrls: ['./employees-list.component.css']
})
export class EmployeesListComponent implements AfterViewInit, OnDestroy, OnInit {
  // staffsList = [];
  staffsList: Staff;
  // dtTrigger: Subject<any> = new Subject();

  constructor(
    public userService: UserService,
    private staffService: StaffService
  ) { }

  downgrade(username: string) {
    if (confirm("Are you sure to downgrade this user? " + username)) {
      this.staffService.downgradeStaff(username);
    };
  }

  //Generate datatable 
  datatable_generate() {
    var employeTable = $('#employeTable').DataTable();
    var employeTable_info = employeTable.page.info();

    if (employeTable_info.pages == 1) {
      employeTable.destroy();
      $('#employeTable').DataTable({
        "paging": false
      });
    }
  }

  ngOnInit() {
    this.staffService.staffsList.subscribe(data => {
      this.staffsList = data;
      // this.dtTrigger.next();
    });
    setTimeout(() => {
      // this.dtTrigger.next();
      this.datatable_generate();
    }, 1000)
  }

  ngAfterViewInit(): void {
    // this.dtTrigger.next();
  }

  ngOnDestroy(): void {
    // this.dtTrigger.unsubscribe();
  }
}
