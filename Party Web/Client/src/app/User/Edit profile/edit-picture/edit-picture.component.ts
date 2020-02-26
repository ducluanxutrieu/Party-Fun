import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

import { api } from '../../../_api/apiUrl'

@Component({
  selector: 'app-edit-picture',
  templateUrl: './edit-picture.component.html',
  styleUrls: ['./edit-picture.component.css']
})
export class EditPictureComponent implements OnInit {
  apiUrl = api.uploadavatar;
  userInfo;
  avtUrl;
  avatarFile: any[];
  constructor(
    private http: HttpClient,
  ) { this.avatarFile = []; }

  ngOnInit() {
    this.getuserInfo();
  }
  onClickSubmit(data: { avt: File }) {
    //alert("wee");
    var body = new FormData();
    for (const file of this.avatarFile) {
      body.append('image', file);
    }
    var token = localStorage.getItem('token');
    let headers = new HttpHeaders({
      'Authorization': token
    })
    var result;
    return this.http.post(this.apiUrl, body, { headers: headers, observe: 'response' }).subscribe(res_data => {
      result = res_data.body;
      sessionStorage.setItem('response', JSON.stringify(res_data.body));
      localStorage.setItem('avatar', result.message);
      location.reload();
      alert("Cập nhật thành công!");
    },
      err => {
        alert("Lỗi: " + err.status);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }
  fileChanged(event: any) {
    this.avatarFile = event.target.files;
  }
  getuserInfo() {
    this.userInfo = JSON.parse(localStorage.getItem('userinfo'));
    this.avtUrl = localStorage.getItem('avatar');
  }
}
