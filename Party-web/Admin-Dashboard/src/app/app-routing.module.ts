import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { UserloginComponent } from './User/userlogin/userlogin.component';
import { AdminPageComponent } from './Admin/admin-page/admin-page.component';

import { ProductsListComponent } from './Admin/Products/products-list/products-list.component';
import { AddProductsComponent } from './Admin/Products/add-products/add-products.component';
import { EditProductComponent } from './Admin/Products/edit-product/edit-product.component';
import { EmployeesListComponent } from './Admin/Employees/employees-list/employees-list.component';
import { AddEmployeeComponent } from './Admin/Employees/add-employee/add-employee.component';
import { EditEmployeeComponent } from './Admin/Employees/edit-employee/edit-employee.component';
import { ChartPageComponent } from './Admin/chart-page/chart-page.component';

const routes: Routes = [
  { path: '', redirectTo: 'admin', pathMatch: 'full' },
  { path: 'login', component: UserloginComponent },
  { path: 'admin', component: AdminPageComponent },
  {
    path: 'products',
    children: [
      { path: '', redirectTo: 'add', pathMatch: 'full' },
      { path: 'add', component: AddProductsComponent },
      { path: 'edit', component: EditProductComponent },
      { path: 'list', component: ProductsListComponent }
    ]
  },
  {
    path: 'employees',
    children: [
      { path: '', redirectTo: 'add', pathMatch: 'full' },
      { path: 'add', component: AddEmployeeComponent },
      { path: 'edit', component: EditEmployeeComponent },
      { path: 'list', component: EmployeesListComponent }
    ]
  },
  { path: 'chart', component: ChartPageComponent },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
