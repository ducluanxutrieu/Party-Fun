import { Component, OnInit, OnDestroy, AfterViewInit } from '@angular/core';
import { api } from '../../../_api/apiUrl';
import { HttpClient, HttpHeaders } from '@angular/common/http';
// Services
import { ProductService } from '../../../_services/product.service';
// Models
import { Product } from '../../../_models/product.model';
// jquery;
declare var $: any;

@Component({
  selector: 'app-products-list',
  templateUrl: './products-list.component.html',
  styleUrls: ['./products-list.component.css']
})
export class ProductsListComponent implements AfterViewInit, OnDestroy, OnInit {
  product_list: Product[] = [];

  // dtTrigger: Subject<any> = new Subject();

  constructor(
    private productService: ProductService
  ) { }

  // Xóa món ăn
  product_delete(id: string) {
    this.productService.delete_dish(id).subscribe(
      res => {
        alert("Delete product success!");
        window.location.reload();
      },
      err => {
        alert("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      }
    )
  }
  // Xác nhận xóa
  delete_clicked(id: string, name: string) {
    if (confirm("Are you sure to delete this?\n" + name)) {
      this.product_delete(id);
    }
  }

  // Generate datatable 
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
    this.get_dishList();
  }

  // Lấy danh sách món ăn
  get_dishList() {
    this.productService.get_dishList().subscribe(
      res => {
        sessionStorage.setItem('response', JSON.stringify(res));
        localStorage.setItem('dish-list', JSON.stringify(res.data));
        this.product_list = res.data as Product[];
      },
      err => {
        console.log("Error: " + err.error.message);
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
