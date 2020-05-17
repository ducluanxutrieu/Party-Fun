import { Component, OnInit, OnDestroy, AfterViewInit } from '@angular/core';
import { StaffService } from '../../../_services/staff.service';

// declare jquery;
declare var $: any;

interface Staff {
  _id: string;
  username: string;
  full_name: string;
  avatar: string;
}

@Component({
  selector: 'app-employees-list',
  templateUrl: './employees-list.component.html',
  styleUrls: ['./employees-list.component.css']
})
export class EmployeesListComponent implements AfterViewInit, OnDestroy, OnInit {
  staffs_List: Staff[] = [];
  // dtTrigger: Subject<any> = new Subject();

  constructor(
    private staffService: StaffService
  ) { }

  downgrade(user_id: string) {
    if (confirm("Are you sure to downgrade this user?")) {
      this.staffService.downgradeStaff(user_id);
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
    this.get_staffList();
  }

  // Lấy danh sách nhân viên
  get_staffList() {
    this.staffService.get_staffsList(1).subscribe(
      res => {
        this.staffs_List = res.data.value as Staff[];
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
