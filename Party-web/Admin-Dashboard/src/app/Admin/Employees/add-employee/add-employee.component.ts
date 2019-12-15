import { Component, OnInit, ViewChild } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { UserService } from '../../../_services/user.service';

import { api } from '../../../_api/apiUrl';
import { NgForm } from '@angular/forms';
@Component({
  selector: 'app-add-employee',
  templateUrl: './add-employee.component.html',
  styleUrls: ['./add-employee.component.css']
})
export class AddEmployeeComponent implements OnInit {
  @ViewChild('userreg', null) thisForm: NgForm;
  @ViewChild('addExisted', null) modalForm: NgForm;
  existed_username: string;

  constructor(
    private http: HttpClient,
    public userService: UserService
  ) { }

  ngOnInit() {
  }
  onClickSubmit(data: {
    name: string;
    email: string;
    phone: number;
    username: string;
    pwd: string;
  }) {
    let body = `fullName=${data.name}&username=${data.username}&email=${data.email}&phoneNumber=${data.phone}&password=${data.pwd}`;
    console.log(body);
    let headers = new HttpHeaders({
      'Content-Type': 'application/x-www-form-urlencoded'
    })
    this.http.post(api.signup, body, { headers: headers, observe: 'response' }).subscribe(
      res_data => {
        sessionStorage.setItem('response_body', JSON.stringify(res_data.body));
        let headers = new HttpHeaders({
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': localStorage.getItem('token')
        })
        let body = `userupgrade=${data.username}`
        this.http.post(api.upgraderole, body, { headers: headers, observe: 'response' }).subscribe(
          res_data => {
            sessionStorage.setItem('response_body2', JSON.stringify(res_data.body));
            alert("Add Employee Success!");
            this.thisForm.reset();
          },
          err => {
            alert("Error: " + err.status + " - " + err.error.message);
            sessionStorage.setItem('error2', JSON.stringify(err));
          })
      },
      err => {
        alert("Error: " + err.status + " - " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }

  AddExistedUser(data: { username: string }) {
    let headers = new HttpHeaders({
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': localStorage.getItem('token')
    })
    let body = `userupgrade=${data.username}`;
    this.http.post(api.upgraderole, body, { headers: headers, observe: 'response' }).subscribe(
      res_data => {
        sessionStorage.setItem('response_body', JSON.stringify(res_data.body));
        alert("Add Employee Success!");
        this.modalForm.reset();
      },
      err => {
        alert("Error: " + err.status + " - " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }
}
