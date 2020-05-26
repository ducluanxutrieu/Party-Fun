import { Component, OnInit } from '@angular/core';
// Services
import { api } from '../../../_api/apiUrl';
import { PostService } from '../../../_services/post.service';
import { CommonService } from '../../../_services/common.service';

@Component({
  selector: 'app-post',
  templateUrl: './post.component.html',
  styleUrls: ['./post.component.css']
})
export class PostComponent implements OnInit {
  public post_content;
  post_feature_image;
  constructor(
    private postService: PostService,
    private commonService: CommonService
  ) { }

  ngOnInit() { }

  options: Object = {
    placeholderText: 'Edit your post here!',
    toolbarButtons: [
      ['fullscreen', 'bold', 'italic', 'underline', 'strikeThrough', 'subscript', 'superscript'],
      ['fontFamily', 'fontSize', 'backgroundColor', 'textColor'],
      ['paragraphFormat', 'align', 'formatOL', 'formatUL', 'outdent', 'indent', '-', 'insertImage', 'embedly',
        'insertTable', 'insertLink', 'quote', 'html'],
      ['specialCharacters', 'insertHR', 'clearFormatting'],
      ['undo', 'redo']],
    fontFamily: {
      'Arial,Helvetica,sans-serif': 'Arial',
      '\'Courier New\',Courier,monospace': 'Courier New',
      'Georgia,serif': 'Georgia',
      'Impact,Charcoal,sans-serif': 'Impact',
      '\'Lucida Console\',Monaco,monospace': 'Lucida Console',
      'Tahoma,Geneva,sans-serif': 'Tahoma',
      '\'Times New Roman\',Times,serif': 'Times New Roman',
      'Verdana,Geneva,sans-serif': 'Verdana',
    },
    // // disable image upload (use hotlinking)
    // imageUpload: false,
    // Set the image upload parameter.
    requestHeaders: {
      Authorization: localStorage.getItem('token'),
    },
    imageUploadParam: 'image',
    // Set the image upload URL.
    imageUploadURL: api.upload_image,
    // Additional upload params.
    imageUploadParams: { type: 'post_image' },
    // Set request type.
    imageUploadMethod: 'POST',
    // Set max image size to 5MB.
    imageMaxSize: 5 * 1024 * 1024,
    // Allow to upload PNG and JPG.
    imageAllowedTypes: ['jpeg', 'jpg', 'png'],
    // events: {
    //   'image.uploaded': function (e, editor, response) {
    //     editor.image.insert(response.body.data, false, null, editor.image.get(), response);
    //   }
    // }
  }

  // Thêm bài viết
  add_post(content: {
    title: string
  }) {
    let post_feature_image_url: string;
    this.commonService.upload_image(this.post_feature_image).subscribe(
      res => {
        post_feature_image_url = res.data;
      },
      err => {
        alert("Error: Upload image error!");
        return;
      },
      () => {
        let body = `title=${content.title}&feature_image=${post_feature_image_url}&content=${this.post_content}`;
        this.postService.add_post(body).subscribe(
          res => {
            alert("Add post success!");
            window.location.reload();
          },
          err => {
            alert("Error: " + err.error.message);
          }
        )
      }
    )
  }

  // Khi thêm ảnh vào input
  fileChanged(event: any) {
    this.post_feature_image = event.target.files;
  }
}