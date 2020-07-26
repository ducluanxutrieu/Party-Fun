//Modules
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { DataTablesModule } from 'angular-datatables';
import { AppRoutingModule } from './app-routing.module';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { ChartsModule } from 'ng2-charts';
import 'froala-editor/js/plugins.pkgd.min.js'; // Import toàn bộ Froala plugin (Có thể import riêng lẻ từng cái)
import { FroalaEditorModule, FroalaViewModule } from 'angular-froala-wysiwyg';
import { NgSelect2Module } from 'ng-select2'
import { DatePipe } from '@angular/common';
import { ToastrModule } from 'ngx-toastr';
import { NgxPaginationModule } from 'ngx-pagination';
//Services
import { CookieService } from 'ngx-cookie-service';
import { AuthenticationService } from './_services/authentication.service';
import { AuthGuard } from './security/auth.guard';
import { ProductService } from './_services/product.service';
import { UserService } from './_services/user.service';
import { StaffService } from './_services/staff.service';
import { StatisticalService } from './_services/statistical.service';
import { PaymentService } from './_services/payment.service';

//Components
import { AppComponent } from './app.component';
import { UserloginComponent } from './User/userlogin/userlogin.component';
import { AdminPageComponent } from './Admin/admin-page/admin-page.component';
import { ProductsListComponent } from './Admin/Products/products-list/products-list.component';
import { AddProductsComponent } from './Admin/Products/add-products/add-products.component';
import { EditProductComponent } from './Admin/Products/edit-product/edit-product.component';
import { EmployeesListComponent } from './Admin/Employees/employees-list/employees-list.component';
import { AddEmployeeComponent } from './Admin/Employees/add-employee/add-employee.component';
import { EditEmployeeComponent } from './Admin/Employees/edit-employee/edit-employee.component';
import { NotFoundComponent } from './shared/not-found/not-found.component';
import { ProfileComponent } from './User/profile/profile.component';
import { CustomersListComponent } from './Admin/Customers/customers-list/customers-list.component';
import { PayComponent } from './Admin/Customers/pay/pay.component';
import { RecentBillsComponent } from './Admin/Customers/recent-bills/recent-bills.component';
import { PostComponent } from './Admin/posts/post/post.component';
import { SidebarComponent } from './shared/sidebar/sidebar.component';
import { PostsListComponent } from './Admin/posts/posts-list/posts-list.component';
import { PostsEditComponent } from './Admin/posts/posts-edit/posts-edit.component';
import { AllBillsComponent } from './Admin/Customers/all-bills/all-bills.component';
import { CreateDiscountComponent } from './Admin/discounts/create-discount/create-discount.component';
import { DiscountsListComponent } from './Admin/discounts/discounts-list/discounts-list.component';

@NgModule({
  declarations: [
    AppComponent,
    UserloginComponent,
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
    PostComponent,
    SidebarComponent,
    PostsListComponent,
    PostsEditComponent,
    AllBillsComponent,
    CreateDiscountComponent,
    DiscountsListComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    FormsModule,
    HttpClientModule,
    ChartsModule,
    DataTablesModule,
    FroalaEditorModule.forRoot(),
    FroalaViewModule.forRoot(),
    NgSelect2Module,
    ToastrModule.forRoot({
      timeOut: 1500,
      positionClass: 'toast-top-right',
      preventDuplicates: true,
    }),
    NgxPaginationModule
  ],
  providers: [
    AuthenticationService,
    AuthGuard,
    ProductService,
    UserService,
    StaffService,
    StatisticalService,
    PaymentService,
    CookieService,
    DatePipe
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
