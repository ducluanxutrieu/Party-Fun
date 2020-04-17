import { Component, OnInit, ViewChild } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { NgForm } from '@angular/forms';
import { api } from '../../../_api/apiUrl';


@Component({
  selector: 'app-add-products',
  templateUrl: './add-products.component.html',
  styleUrls: ['./add-products.component.css']
})
export class AddProductsComponent implements OnInit {
  @ViewChild('adddishForm', null) thisForm: NgForm;
  imgArr = [];
  constructor(
    private http: HttpClient
  ) { }

  ngOnInit() { }
  onClickSubmit(data: {
    name: string;
    description: string;
    type: string;
    price: string;
    promotion: string;
    image1: File;
  }) {
    var body = new FormData();
    body.append('name', data.name);
    body.append('description', data.description);
    body.append('price', data.price);
    body.append('discount', "0"); //discount temp disable
    body.append('type', data.type);
    //   this.createFormData(body, 'image', this.imgArr);
    body.append('image', this.imgArr[0]);
    let headers = new HttpHeaders({
      'Authorization': localStorage.getItem('token')
    })
    this.http.post(api.adddish, body, { headers: headers, observe: 'response' }).subscribe(res_data => {
      sessionStorage.setItem('response_body', JSON.stringify(res_data.body));
      alert("Add product success");
      this.thisForm.reset();
    },
      err => {
        alert("Error: " + err.status + " " + err.statusText + "\n" + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }
  fileChanged(event: any) {
    // this.imgArr.push(event.target.files);
    this.imgArr = event.target.files;
  }
}

