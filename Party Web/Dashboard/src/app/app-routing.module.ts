import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { UserloginComponent } from './User/userlogin/userlogin.component';
import { AdminPageComponent } from './Admin/admin-page/admin-page.component';
import { AuthGuard } from './security/auth.guard';

import { ProductsListComponent } from './Admin/Products/products-list/products-list.component';
import { AddProductsComponent } from './Admin/Products/add-products/add-products.component';
import { EditProductComponent } from './Admin/Products/edit-product/edit-product.component';
import { EmployeesListComponent } from './Admin/Employees/employees-list/employees-list.component';
import { AddEmployeeComponent } from './Admin/Employees/add-employee/add-employee.component';
import { EditEmployeeComponent } from './Admin/Employees/edit-employee/edit-employee.component';
import { NotFoundComponent } from './not-found/not-found.component';
import { ProfileComponent } from './User/profile/profile.component';
import { CustomersListComponent } from './Admin/Customers/customers-list/customers-list.component';
import { PayComponent } from './Admin/Customers/pay/pay.component';
import { RecentBillsComponent } from './Admin/Customers/recent-bills/recent-bills.component';

const routes: Routes = [
  { path: '', redirectTo: 'dashboard', pathMatch: 'full' },
  { path: 'login', component: UserloginComponent },
  { path: 'profile', component: ProfileComponent, canActivate: [AuthGuard] },
  { path: 'dashboard', component: AdminPageComponent, canActivate: [AuthGuard] },
  {
    path: 'products',
    children: [
      { path: '', redirectTo: 'add', pathMatch: 'full' },
      { path: 'add', component: AddProductsComponent },
      { path: 'edit/:id', component: EditProductComponent },
      { path: 'list', component: ProductsListComponent }
    ],
    canActivate: [AuthGuard]
  },
  {
    path: 'employees',
    children: [
      { path: '', redirectTo: 'add', pathMatch: 'full' },
      { path: 'add', component: AddEmployeeComponent },
      { path: 'edit', component: EditEmployeeComponent },
      { path: 'list', component: EmployeesListComponent }
    ],
    canActivate: [AuthGuard]
  },
  {
    path: 'customers',
    children: [
      { path: '', redirectTo: 'list', pathMatch: 'full' },
      { path: 'list', component: CustomersListComponent },
      { path: 'pay', component: PayComponent },
      { path: 'recent-bill', component: RecentBillsComponent }
    ],
    canActivate: [AuthGuard]
  },
  { path: 'not-found', component: NotFoundComponent },
  { path: '**', redirectTo: '/not-found' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
