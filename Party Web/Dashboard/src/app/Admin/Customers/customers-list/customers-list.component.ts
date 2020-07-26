import { Component, OnInit, OnDestroy, AfterViewInit, Input } from '@angular/core';
import { StaffService } from '../../../_services/staff.service';
import { ActivatedRoute, Router } from '@angular/router';

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
  @Input('data') customers_list: Customer[] = [];
  page: number = 1;
  total_pages: number;

  // dtTrigger: Subject<any> = new Subject();

  constructor(
    private staffService: StaffService,
    private activatedRoute: ActivatedRoute,
    private router: Router
  ) { }

  upgrade(user_id: string) {
    if (confirm("Are you sure to upgrade this user?")) {
      this.staffService.upgradeCustomer(user_id);
    };
  }

  //Generate datatable 
  datatable_generate() {
    var customerTable = $('#customerTable').DataTable({ "paging": false });
    // var customerTable_info = customerTable.page.info();

    // if (customerTable_info.pages == 1) {
    //   customerTable.destroy();
    //   $('#customerTable').DataTable({
    //     "paging": false
    //   });
    // }
  }

  ngOnInit() {
    this.loaddata()
  }

  loaddata() {
    this.activatedRoute.params.subscribe(params => {
      this.page = params['page'];
      this.get_customerList(this.page);
    })
  }

  get_customerList(page: number) {
    this.staffService.get_customersList(page).subscribe(
      res => {
        this.customers_list = res.data.value as Customer[];
        this.total_pages = res.data.total_page;
      },
      err => {
        console.log("Error: " + err.error.message);
      },
      () => {
        setTimeout(() => {
          // this.dtTrigger.next();
          this.datatable_generate();
        })
      });
  }

  get_page(page: number) {
    this.router.navigate(['/customers/list', page]).then(() => {
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