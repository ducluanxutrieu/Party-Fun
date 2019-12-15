import { Component, OnInit } from '@angular/core';
import { UserService } from '../../_services/user.service';
import { api } from '../../_api/apiUrl';
import { HttpHeaders, HttpClient } from '@angular/common/http';
import { DatePipe } from '@angular/common';


@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.css']
})
export class ProfileComponent implements OnInit {
  profile_info;
  private birthday;

  constructor(
    public userService: UserService,
    private http: HttpClient,
    public datepipe: DatePipe
  ) { }

  ngOnInit() {
    // this.profile_info = this.userService.get_userInfo();
    console.log(this.profile_info);
  }
  updateSubmit(data: {
    name: string;
    email: string;
    phone: string;
    gender: string;
    birthday: string;
  }) {
    this.birthday = this.datepipe.transform(data.birthday, 'MM/dd/yyyy');
    let body = `fullName=${data.name}&sex=${data.gender}&birthday=${this.birthday}&phoneNumber=${data.phone}&email=${data.email}`;
    let headers = new HttpHeaders({
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': localStorage.getItem('token')
    })
    this.http.post(api.updateuser, body, { headers: headers, observe: 'response' }).subscribe(
      res_data => {
        sessionStorage.setItem('response_body', JSON.stringify(res_data.body));
        alert("Update info success!");
        window.location.reload();
      },
      err => {
        alert("Error: " + err.status + " - " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }

  avatarChanged(event: any) {
    var body = new FormData();
    for (const file of event.target.files) {
      body.append('image', file);
    }
    let headers = new HttpHeaders({
      'Authorization': localStorage.getItem('token')
    })
    this.http.post(api.uploadavatar, body, { headers: headers, observe: 'response' }).subscribe(
      res_data => {
        sessionStorage.setItem('response_body', JSON.stringify(res_data.body));
        window.location.reload();
      },
      err => {
        alert("Error: " + err.status + " - " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }
  changeOfDate(event: any) {
    this.birthday = event.target.value;
    this.birthday = this.datepipe.transform(this.birthday, 'MM/dd/yyyy');
  }
}