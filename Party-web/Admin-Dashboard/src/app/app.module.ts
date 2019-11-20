import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { HttpClientModule } from '@angular/common/http';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { AuthenticationService } from './_services/authentication.service';
import { AuthGuard } from './security/auth.guard';
import { ProductService } from './_services/product.service';

import { UserloginComponent } from './User/userlogin/userlogin.component';
import { UserregisterComponent } from './User/userregister/userregister.component';
import { AdminPageComponent } from './Admin/admin-page/admin-page.component';
import { ProductsListComponent } from './Admin/Products/products-list/products-list.component';
import { AddProductsComponent } from './Admin/Products/add-products/add-products.component';
import { EditProductComponent } from './Admin/Products/edit-product/edit-product.component';
import { EmployeesListComponent } from './Admin/Employees/employees-list/employees-list.component';
import { AddEmployeeComponent } from './Admin/Employees/add-employee/add-employee.component';
import { EditEmployeeComponent } from './Admin/Employees/edit-employee/edit-employee.component';
import { ChartPageComponent } from './Admin/chart-page/chart-page.component';


@NgModule({
  declarations: [
    AppComponent,
    UserloginComponent,
    UserregisterComponent,
    AdminPageComponent,
    ProductsListComponent,
    AddProductsComponent,
    EmployeesListComponent,
    AddEmployeeComponent,
    EditProductComponent,
    EditEmployeeComponent,
    ChartPageComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    FormsModule,
    HttpClientModule,
  ],
  providers: [AuthenticationService, AuthGuard, ProductService],
  bootstrap: [AppComponent]
})
export class AppModule { }
