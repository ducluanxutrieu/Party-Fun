import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
// Services
import { PostService } from '../../../_services/post.service';
import { CommonService } from '../../../_services/common.service';
import { ToastrService } from 'ngx-toastr';
/// Models
import { Post } from '../../../_models/post.model';
import { api } from '../../../_api/apiUrl';
@Component({
  selector: 'app-posts-edit',
  templateUrl: './posts-edit.component.html',
  styleUrls: ['./posts-edit.component.css']
})
export class PostsEditComponent implements OnInit {
  post_id: string;
  post: Post = new Post;
  post_feature_image;

  options: Object = {
    language: 'vi',
    pastePlain: true,
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
  }
  constructor(
    private postService: PostService,
    private commonService: CommonService,
    private activatedRoute: ActivatedRoute,
    private toastr: ToastrService
  ) { }

  ngOnInit() {
    this.activatedRoute.params.subscribe(params => {
      this.post_id = params['id'];
      this.get_post(this.post_id);
    })
  }

  // Xác nhận chỉnh sửa bài viết
  edit_confirm(content: {
    title: string
  }) {
    if (this.post_feature_image) {
      this.commonService.upload_image(this.post_feature_image).subscribe(
        res => {
          this.post.feature_image = res.data;
        },
        err => {
          this.toastr.error("Error: Upload image error!");
          return;
        },
        () => {
          this.edit_post(content);
        }
      )
    }
    else {
      this.edit_post(content);
    }
  }

  // Chỉnh sửa bài viết
  edit_post(content: {
    title: string
  }
  ) {
    let body = `_id=${this.post_id}&title=${content.title}&feature_image=${this.post.feature_image}&content=${encodeURIComponent(this.post.content)}`;
    this.postService.edit_post(body).subscribe(
      res => {
        this.toastr.success("Edit post success!");
        // window.location.reload();
      },
      err => {
        this.toastr.error("Error while uploading post!");
        console.log("Error" + err.error.message);
      }
    )
  }
  // Lấy nội dung bài viết
  get_post(post_id: string) {
    this.postService.get_post(post_id).subscribe(
      res => {
        this.post = res.data as Post;
      },
      err => {
        console.log("Error: " + err.error.message);
      }
    )
  }
  fileChanged(event: any) {
    this.post_feature_image = event.target.files;
  }
}