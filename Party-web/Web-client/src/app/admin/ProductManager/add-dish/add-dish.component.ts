import { Component, OnInit, ViewChild } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { NgForm } from '@angular/forms';

import { api } from '../../../_api/apiUrl';

@Component({
  selector: 'app-add-dish',
  templateUrl: './add-dish.component.html',
  styleUrls: ['./add-dish.component.css']
})
export class AddDishComponent implements OnInit {
  @ViewChild('adddishForm', null) thisForm: NgForm;
  apiUrl = api.adddish;
  imgArr: any[];
  constructor(
    private http: HttpClient,
  ) { this.imgArr = []; }

  ngOnInit() {
  }
  onClickSubmit(data: {
    name: string;
    description: string;
    type: string;
    price: string;
    promotion: string;
    image1: File;
    //image2: File;
  }) {
    var body = new FormData();
    body.append('name', data.name);
    body.append('description', data.description);
    body.append('price', data.price);
    body.append('promotion', data.promotion);
    body.append('type', data.type);
    //   this.createFormData(body, 'image', this.imgArr);
    body.append('image', this.imgArr[0]);
    var token = localStorage.getItem('token');
    let headers = new HttpHeaders({
      'Authorization': token
    })
    return this.http.post(this.apiUrl, body, { headers: headers, observe: 'response' }).subscribe(res_data => {
      sessionStorage.setItem('response_body', JSON.stringify(res_data.body));
      alert("Cập nhật thành công!");
      this.thisForm.reset();
    },
      err => {
        alert("Lỗi: " + err.status + " " + err.statusText + "\n" + err.error.errorMessage);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }

  fileChanged(event: any) {
    // this.imgArr.push(event.target.files);
    this.imgArr = event.target.files;
  }
  createFormData(formData, key, data) {
    if (data === Object(data) || Array.isArray(data)) {
      for (var i in data) {
        this.createFormData(formData, key + '[' + i + ']', data[i]);
      }
    } else {
      formData.append(key, data);
    }
  }
}
