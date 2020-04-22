import { Component, OnInit, OnDestroy, AfterViewInit } from '@angular/core';
import { api } from '../../../_api/apiUrl';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { ProductService } from '../../../_services/product.service';

// declare jquery;
declare var $: any;

@Component({
  selector: 'app-products-list',
  templateUrl: './products-list.component.html',
  styleUrls: ['./products-list.component.css']
})
export class ProductsListComponent implements AfterViewInit, OnDestroy, OnInit {
  product_data = [];

  // dtTrigger: Subject<any> = new Subject();

  constructor(
    private http: HttpClient,
    private productService: ProductService
  ) { }

  product_delete(id: string) {
    let headers = new HttpHeaders({
      'Authorization': localStorage.getItem('token')
    })
    const option = {
      headers: headers,
      body: {
        _id: id
      },
    }
    this.http.delete(api.deleteDish, option).subscribe(
      res_data => {
        sessionStorage.setItem('response_body', JSON.stringify(res_data));
        alert("Delete product success!");
        window.location.reload();
      },
      err => {
        alert("Error: " + err.status + " - " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      }
    )
  }

  delete_clicked(id: string, name: string) {
    if (confirm("Are you sure to delete this?\n" + name)) {
      this.product_delete(id);
      console.log(id);
    }
  }

  //Generate datatable 
  datatable_generate() {
    var productTable = $('#productTable').DataTable();
    var productTable_info = productTable.page.info();

    if (productTable_info.pages == 1) {
      productTable.destroy();
      $('#productTable').DataTable({
        "paging": false
      });
    }
  }

  ngOnInit() {
    //this.product_data = JSON.parse(localStorage.getItem('dish-list'));
    // this.product_data = this.productService.findAll();
    // this.productService.productList.subscribe(
    //   data => {
    //     this.product_data = data;
    //   },
    //   err => console.log(err),
    //   () => {
    //     setTimeout(() => {
    //       // this.dtTrigger.next();
    //       this.datatable_generate();
    //     }, 1000)
    //   });
    this.productService.getDishList().subscribe(
      res_data => {
        sessionStorage.setItem('response_body', JSON.stringify(res_data.body));
        var response_body = JSON.parse(sessionStorage.getItem('response_body'));
        localStorage.setItem('dish-list', JSON.stringify(response_body.lishDishs));
        this.product_data = response_body.lishDishs;
      },
      err => {
        console.log("Error: " + err.status + " " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      },
      () => {
        setTimeout(() => {
          this.datatable_generate();
        }, 1000)
      }
    )
  }

  ngAfterViewInit(): void {
    // this.dtTrigger.next();
  }

  ngOnDestroy(): void {
    // this.dtTrigger.unsubscribe();
  }
}
