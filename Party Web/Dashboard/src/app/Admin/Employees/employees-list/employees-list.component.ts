import { Component, OnInit, OnDestroy, AfterViewInit, Input } from '@angular/core';
import { StaffService } from '../../../_services/staff.service';
import { ActivatedRoute, Router } from '@angular/router';
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
  @Input('data') staffs_List: Staff[] = [];
  page: number = 1;
  total_pages: number;

  // dtTrigger: Subject<any> = new Subject();

  constructor(
    private staffService: StaffService,
    private activatedRoute: ActivatedRoute,
    private router: Router
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
    this.loaddata();
  }

  loaddata() {
    this.activatedRoute.params.subscribe(params => {
      this.page = params['page'];
      this.get_staffList(this.page);
    })
  }

  // Lấy danh sách nhân viên
  get_staffList(page: number) {
    this.staffService.get_staffsList(page).subscribe(
      res => {
        this.staffs_List = res.data.value as Staff[];
        this.total_pages = res.data.total_page;
      },
      err => {
        console.error("Error: " + err.error.message);
      },
      () => {
        setTimeout(() => {
          // this.dtTrigger.next();
          this.datatable_generate();
        })
      });
  }

  get_page(page: number) {
    this.router.navigate(['/employees/list', page]).then(() => {
      window.location.reload();
    });
  }

  ngAfterViewInit(): void {
    // this.dtTrigger.next();
  }

  ngOnDestroy(): void {
    // this.dtTrigger.unsubscribe();
  }
}
