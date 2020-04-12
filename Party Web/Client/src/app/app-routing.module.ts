//Modules
import { NgModule, Component } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { AuthGuard } from './security/auth.guard';

//Components
import { AppComponent } from './app.component';
import { UserloginComponent } from './pages/User/userlogin/userlogin.component';
import { UserregisterComponent } from './pages/User/userregister/userregister.component';
import { MainpageComponent } from './pages/mainpage/mainpage.component';
import { UserInfoComponent } from './pages/User/Profile/user-info/user-info.component';
import { EditInfoComponent } from './pages/User/Edit profile/edit-info/edit-info.component';
import { EditPasswordComponent } from './pages/User/Edit profile/edit-password/edit-password.component';
import { ForgotpasswordComponent } from './pages/User/forgotpassword/forgotpassword.component';
import { EditProfileComponent } from './pages/User/Edit profile/edit-profile/edit-profile.component';
import { EditPictureComponent } from './pages/User/Edit profile/edit-picture/edit-picture.component';
import { UserProfileComponent } from './pages/User/Profile/user-profile/user-profile.component';
import { UserCartInfoComponent } from './pages/User/Profile/user-cart-info/user-cart-info.component';
import { NotFoundComponent } from './pages/not_found/not-found.component';
import { UserCartComponent } from './pages/User/Cart/user-cart/user-cart.component';
import { UserCheckoutComponent } from './pages/User/Cart/user-checkout/user-checkout.component';
import { ProductDetailComponent } from './pages/Products/product-detail/product-detail.component';
import { ProductCategoryComponent } from './pages/Products/product-category/product-category.component';
import { AboutComponent } from './pages/about/about.component';

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
  { path: 'mainpage', component: MainpageComponent },
  { path: 'product/:id', component: ProductDetailComponent },
  { path: 'category/:filter', component: ProductCategoryComponent },
  { path: 'about', component: AboutComponent },
  { path: '404', component: NotFoundComponent },
  { path: '**', redirectTo: '/404' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})

export class AppRoutingModule { }
