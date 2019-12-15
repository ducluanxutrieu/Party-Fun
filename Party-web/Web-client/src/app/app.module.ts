import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HeaderComponent } from './header/header.component';
import { FooterComponent } from './footer/footer.component';
import { UserloginComponent } from './User/userlogin/userlogin.component';
import { UserregisterComponent } from './User/userregister/userregister.component';
import { MainpageComponent } from './mainpage/mainpage.component';
import { AdminpageComponent } from './admin/adminpage/adminpage.component';
import { AuthenticationService } from './_services/authentication.service';
import { AuthGuard } from './security/auth.guard';
import { UserInfoComponent } from './User/Profile/user-info/user-info.component';
import { EditInfoComponent } from './User/Edit profile/edit-info/edit-info.component';
import { EditPasswordComponent } from './User/Edit profile/edit-password/edit-password.component';
import { ForgotpasswordComponent } from './User/forgotpassword/forgotpassword.component';
import { EditProfileComponent } from './User/Edit profile/edit-profile/edit-profile.component';
import { EditPictureComponent } from './User/Edit profile/edit-picture/edit-picture.component';
import { UserProfileComponent } from './User/Profile/user-profile/user-profile.component';
import { UserCartInfoComponent } from './User/Profile/user-cart-info/user-cart-info.component';
import { NotFoundComponent } from './not-found-component/not-found-component.component';
import { PanelComponent } from './panel/panel.component';
import { AddDishComponent } from './admin/ProductManager/add-dish/add-dish.component';
import { EditDishComponent } from './admin/ProductManager/edit-dish/edit-dish.component';
import { DishlistComponent } from './admin/ProductManager/dishlist/dishlist.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatExpansionModule } from '@angular/material/expansion';
import { MatTableModule } from '@angular/material/table';
import { CustomerListComponent } from './admin/CustomerManager/customer-list/customer-list.component';
import { EmployeeListComponent } from './admin/EmployeeManager/employee-list/employee-list.component';
import { AddEmployeeComponent } from './admin/EmployeeManager/add-employee/add-employee.component';
import { StoreService } from './_services/store.service';
import { JwPaginationComponent } from 'jw-angular-pagination';
import { UserCartComponent } from './User/Cart/user-cart/user-cart.component';
import { UserCheckoutComponent } from './User/Cart/user-checkout/user-checkout.component';
import { ProductService } from './_services/product.service';
import { DatePipe } from '@angular/common';
import { ProductDetailComponent } from './Products/product-detail/product-detail.component';
import { ProductCategoryComponent } from './Products/product-category/product-category.component';
import { SearchComponent } from './Products/search/search.component';
import { UserService } from './_services/user.service';
import { ProductRatingComponent } from './Products/product-rating/product-rating.component';
import { BarRatingModule } from "ngx-bar-rating";
import { AboutComponent } from './about/about.component';

@NgModule({
  declarations: [
    AppComponent,
    HeaderComponent,
    FooterComponent,
    UserloginComponent,
    UserregisterComponent,
    MainpageComponent,
    AdminpageComponent,
    UserInfoComponent,
    EditInfoComponent,
    EditPasswordComponent,
    ForgotpasswordComponent,
    EditProfileComponent,
    EditPictureComponent,
    UserProfileComponent,
    UserCartInfoComponent,
    NotFoundComponent,
    PanelComponent,
    AddDishComponent,
    EditDishComponent,
    DishlistComponent,
    CustomerListComponent,
    EmployeeListComponent,
    AddEmployeeComponent,
    JwPaginationComponent,
    UserCartComponent,
    UserCheckoutComponent,
    ProductDetailComponent,
    ProductCategoryComponent,
    SearchComponent,
    ProductRatingComponent,
    AboutComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    HttpClientModule,
    BrowserAnimationsModule,
    MatExpansionModule,
    MatTableModule,
    BarRatingModule
  ],
  providers: [AuthenticationService, AuthGuard, StoreService, ProductService, DatePipe, UserService],
  bootstrap: [AppComponent]
})
export class AppModule { }
