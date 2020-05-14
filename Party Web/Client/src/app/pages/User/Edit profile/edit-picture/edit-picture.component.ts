import { Component, OnInit, ViewChild } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { NgForm } from '@angular/forms';

import { api } from '../../../../_api/apiUrl';
//Models
import { Response } from '../../../../_models/response.model';

declare var toastr;

@Component({
  selector: 'app-edit-picture',
  templateUrl: './edit-picture.component.html',
  styleUrls: ['./edit-picture.component.css']
})
export class EditPictureComponent implements OnInit {
  @ViewChild('updatepicture', null) avatarForm: NgForm;

  avtUrl: string;
  avatarFile: any[];
  constructor(
    private http: HttpClient,
  ) {
    this.avatarFile = [];
  }

  ngOnInit() {
    this.avtUrl = localStorage.getItem('avatar');
  }
  onClickSubmit(data: { avt: File }) {
    let body = new FormData();
    for (const file of this.avatarFile) {
      body.append('image', file);
    }
    let headers = new HttpHeaders({
      'Authorization': localStorage.getItem('token'),
    })
    return this.http.put<Response>(api.update_avt, body, { headers: headers }).subscribe(
      res => {
        sessionStorage.setItem('response', JSON.stringify(res));
        localStorage.setItem('avatar', res.data);
        location.reload();
        toastr.success("Update success!");
      },
      err => {
        toastr.error("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }
  // Khi file input thay đổi, kiểm tra định dạng ảnh
  fileChanged(event: any) {
    if (event.target.files[0].type == "image/png" || event.target.files[0].type == "image/jpeg" || event.target.files[0].type == "image/gif") {
      this.avatarFile = event.target.files;
    }
    else {
      toastr.warning("Not a jpeg, png or gif file!");
      this.avatarForm.reset();
    }
  }
}