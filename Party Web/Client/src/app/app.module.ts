//Modules
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { AppRoutingModule } from './app-routing.module';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatExpansionModule } from '@angular/material/expansion';
import { MatTableModule } from '@angular/material/table';
import { BarRatingModule } from "ngx-bar-rating";

import { DatePipe } from '@angular/common';

//Services
import { AuthenticationService } from './_services/authentication.service';
import { ProductService } from './_services/product.service';
import { UserService } from './_services/user.service';
// import { StoreService } from './_services/store.service';

//Guard
import { AuthGuard } from './_guard/auth.guard';
import { PaymentGuard } from './_guard/payment.guard';

//Components
import { AppComponent } from './app.component';
import { HeaderComponent } from './component/header/header.component';
import { FooterComponent } from './component/footer/footer.component';
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
import { JwPaginationComponent } from 'jw-angular-pagination';
import { UserCartComponent } from './pages/User/Cart/user-cart/user-cart.component';
import { UserCheckoutComponent } from './pages/User/Cart/user-checkout/user-checkout.component';
import { ProductDetailComponent } from './pages/Products/product-detail/product-detail.component';
import { ProductCategoryComponent } from './pages/Products/product-category/product-category.component';
import { SearchComponent } from './pages/Products/search/search.component';
import { ProductRatingComponent } from './pages/Products/product-rating/product-rating.component';
import { AboutComponent } from './pages/about/about.component';
import { ScrollToTopComponent } from './component/scroll-to-top/scroll-to-top.component';
import { ReceiptComponent } from './pages/User/payment/receipt/receipt.component';
import { PaymentComponent } from './pages/User/payment/payment/payment.component';

@NgModule({
  declarations: [
    AppComponent,
    HeaderComponent,
    FooterComponent,
    UserloginComponent,
    UserregisterComponent,
    MainpageComponent,
    UserInfoComponent,
    EditInfoComponent,
    EditPasswordComponent,
    ForgotpasswordComponent,
    EditProfileComponent,
    EditPictureComponent,
    UserProfileComponent,
    UserCartInfoComponent,
    NotFoundComponent,
    JwPaginationComponent,
    UserCartComponent,
    UserCheckoutComponent,
    ProductDetailComponent,
    ProductCategoryComponent,
    SearchComponent,
    ProductRatingComponent,
    AboutComponent,
    ScrollToTopComponent,
    ReceiptComponent,
    PaymentComponent
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
  providers: [
    AuthenticationService,
    AuthGuard,
    ProductService,
    DatePipe,
    UserService,
    PaymentGuard
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }