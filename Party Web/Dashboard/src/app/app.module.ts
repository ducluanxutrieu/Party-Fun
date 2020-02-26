import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { HttpClientModule } from '@angular/common/http';
import { DataTablesModule } from 'angular-datatables';
import { AppRoutingModule } from './app-routing.module';

import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { CookieService } from 'ngx-cookie-service';
import { AuthenticationService } from './_services/authentication.service';
import { AuthGuard } from './security/auth.guard';
import { ProductService } from './_services/product.service';
import { UserService } from './_services/user.service';
import { StaffService } from './_services/staff.service';
import { StatisticalService } from './_services/statistical.service';
import { PaymentService } from './_services/payment.service';

import { AppComponent } from './app.component';
import { UserloginComponent } from './User/userlogin/userlogin.component';
import { UserregisterComponent } from './User/userregister/userregister.component';
import { AdminPageComponent } from './Admin/admin-page/admin-page.component';
import { ProductsListComponent } from './Admin/Products/products-list/products-list.component';
import { AddProductsComponent } from './Admin/Products/add-products/add-products.component';
import { EditProductComponent } from './Admin/Products/edit-product/edit-product.component';
import { EmployeesListComponent } from './Admin/Employees/employees-list/employees-list.component';
import { AddEmployeeComponent } from './Admin/Employees/add-employee/add-employee.component';
import { EditEmployeeComponent } from './Admin/Employees/edit-employee/edit-employee.component';
import { NotFoundComponent } from './not-found/not-found.component';
import { ProfileComponent } from './User/profile/profile.component';
import { CustomersListComponent } from './Admin/Customers/customers-list/customers-list.component';
import { ChartsModule } from 'ng2-charts';
import { DatePipe } from '@angular/common';
import { PayComponent } from './Admin/Customers/pay/pay.component';
import { RecentBillsComponent } from './Admin/Customers/recent-bills/recent-bills.component';


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
    NotFoundComponent,
    ProfileComponent,
    CustomersListComponent,
    PayComponent,
    RecentBillsComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    FormsModule,
    HttpClientModule,
    ChartsModule,
    DataTablesModule
  ],
  providers: [AuthenticationService, AuthGuard, ProductService, UserService, StaffService, StatisticalService, PaymentService, CookieService, DatePipe],
  bootstrap: [AppComponent]
})
export class AppModule { }
