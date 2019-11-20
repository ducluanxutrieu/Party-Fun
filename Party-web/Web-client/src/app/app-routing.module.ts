import { NgModule, Component } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { UserloginComponent } from './User/userlogin/userlogin.component';
import { UserregisterComponent } from './User/userregister/userregister.component';
import { MainpageComponent } from './mainpage/mainpage.component';
import { AdminpageComponent } from './admin/adminpage/adminpage.component';
import { AppComponent } from './app.component';
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
import { AddDishComponent } from './admin/ProductManager/add-dish/add-dish.component';
import { EditDishComponent } from './admin/ProductManager/edit-dish/edit-dish.component';
import { DishlistComponent } from './admin/ProductManager/dishlist/dishlist.component';
import { EmployeeListComponent } from './admin/EmployeeManager/employee-list/employee-list.component';
import { AddEmployeeComponent } from './admin/EmployeeManager/add-employee/add-employee.component';
import { CustomerListComponent } from './admin/CustomerManager/customer-list/customer-list.component';
import { UserCartComponent } from './User/Cart/user-cart/user-cart.component';
import { UserCheckoutComponent } from './User/Cart/user-checkout/user-checkout.component';
import { ProductDetailComponent } from './Products/product-detail/product-detail.component';
import { ProductCategoryComponent } from './Products/product-category/product-category.component';


const routes: Routes = [
  { path: '', redirectTo: 'mainpage', pathMatch: 'full' },
  { path: 'user_login', component: UserloginComponent },
  { path: 'user_register', component: UserregisterComponent },
  {
    path: 'profile', component: UserInfoComponent,
    children: [
      { path: '', redirectTo: 'yourprofile', pathMatch: 'full' },
      { path: 'yourprofile', component: UserProfileComponent },
      { path: 'yourcart', component: UserCartInfoComponent }
    ],
    canActivate: [AuthGuard]
  },
  {
    path: 'editProfile', component: EditInfoComponent,
    children: [
      { path: '', redirectTo: 'profile', pathMatch: 'full' },
      { path: 'profile', component: EditProfileComponent },
      { path: 'picture', component: EditPictureComponent },
      { path: 'password', component: EditPasswordComponent }
    ],
    canActivate: [AuthGuard]
  },
  { path: 'forgotpassword', component: ForgotpasswordComponent },
  { path: 'homepage', component: AppComponent },
  { path: 'cart', component: UserCartComponent },
  { path: 'checkout', component: UserCheckoutComponent, canActivate: [AuthGuard] },
  {
    path: 'admin', component: AdminpageComponent,
    children: [
      { path: '', redirectTo: 'adddish', pathMatch: 'full' },
      { path: 'adddish', component: AddDishComponent },
      { path: 'editdish', component: EditDishComponent },
      { path: 'dishlist', component: DishlistComponent },
      { path: 'addEmployee', component: AddEmployeeComponent },
      { path: 'employeeList', component: EmployeeListComponent },
      { path: 'customerList', component: CustomerListComponent }
    ],
    canActivate: [AuthGuard]
  },
  { path: 'mainpage', component: MainpageComponent },
  { path: 'productDetail', component: ProductDetailComponent },
  { path: 'product/:id', component: ProductDetailComponent },
  { path: 'category/:filter', component: ProductCategoryComponent },
  { path: '404', component: NotFoundComponent },
  { path: '**', redirectTo: '/404' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})

export class AppRoutingModule { }
