import { Component, OnInit } from '@angular/core';
import { HttpHeaders, HttpClient } from '@angular/common/http';
import { DatePipe } from '@angular/common';

// Services
import { api } from '../../_api/apiUrl';
import { UserService } from '../../_services/user.service';
// Models
import { User } from '../../_models/user.model';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.css']
})
export class ProfileComponent implements OnInit {
  user_info: User = new User;
  private birthday;

  constructor(
    public userService: UserService,
    private http: HttpClient,
    public datepipe: DatePipe
  ) { }

  ngOnInit() {
    this.get_userInfo();
  }
  // Lấy thông tin user
  get_userInfo() {
    this.userService.get_userInfo().subscribe(
      res => {
        this.user_info = res.data as User;
      },
      err => {
        console.log("Get user info error!");
      }
    )
  }

  // Cập nhật thông tin profile
  updateSubmit(data: {
    name: string;
    email: string;
    phone: number;
    gender: string;
    birthday: string;
  }) {
    this.birthday = this.datepipe.transform(data.birthday, 'MM/dd/yyyy');
    let body = `full_name=${data.name}&sex=${data.gender}&birthday=${this.birthday}&phone=${data.phone}&email=${data.email}`;
    this.userService.update_userInfo(body).subscribe(
      res => {
        sessionStorage.setItem('response_body', JSON.stringify(res));
        alert("Update info success!");
        window.location.reload();
      },
      err => {
        alert("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      }
    )
  }

  avatarChanged(event: any) {
    var body = new FormData();
    for (const file of event.target.files) {
      body.append('image', file);
    }
    let headers = new HttpHeaders({
      'Authorization': localStorage.getItem('token')
    })
    this.http.put(api.uploadavatar, body, { headers: headers, observe: 'response' }).subscribe(
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