import { Component, OnInit, ViewChild } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { NgForm } from '@angular/forms';

import { api } from '../../../../_api/apiUrl'

declare var toastr;

@Component({
  selector: 'app-edit-picture',
  templateUrl: './edit-picture.component.html',
  styleUrls: ['./edit-picture.component.css']
})
export class EditPictureComponent implements OnInit {
  @ViewChild('updatepicture', null) avatarForm: NgForm;

  userInfo;
  avtUrl: string;
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
    return this.http.post(api.uploadavatar, body, { headers: headers, observe: 'response' }).subscribe(res_data => {
      result = res_data.body;
      sessionStorage.setItem('response', JSON.stringify(res_data.body));
      localStorage.setItem('avatar', result.message);
      location.reload();
      toastr.success("Update success!");
    },
      err => {
        toastr.error("Error: " + err.status + " " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }
  fileChanged(event: any) {
    if (event.target.files[0].type == "image/png" || event.target.files[0].type == "image/jpeg" || event.target.files[0].type == "image/gif") {
      this.avatarFile = event.target.files;
    }
    else {
      toastr.warning("Not a jpeg, png or gif file!");
      this.avatarForm.reset();
    }
  }
  getuserInfo() {
    this.userInfo = JSON.parse(localStorage.getItem('userinfo'));
    this.avtUrl = localStorage.getItem('avatar');
  }
}
