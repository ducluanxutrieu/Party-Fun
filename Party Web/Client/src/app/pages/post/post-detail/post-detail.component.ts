import { Component, OnInit, ViewEncapsulation } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

// Service
import { PostService } from '../../../_services/post.service';
// Models
import { Post } from '../../../_models/post.model';

declare var toastr;

@Component({
  selector: 'app-post-detail',
  templateUrl: './post-detail.component.html',
  styleUrls: ['./post-detail.component.css'],
  // encapsulation: ViewEncapsulation.None,
})
export class PostDetailComponent implements OnInit {
  post: Post = new Post;

  constructor(
    private activatedRoute: ActivatedRoute,
    private postService: PostService,
  ) { }

  ngOnInit() {
    this.activatedRoute.params.subscribe(params => {
      let post_id = params['id'];
      this.get_post(post_id);
    })
  }
  // Lấy thông tin bài viết
  get_post(id: string) {
    this.postService.get_post(id).subscribe(
      res => {
        this.post = res.data as Post;
      },
      err => {
        console.log("Error: " + err.error.message);
        toastr.error("Error loading post!");
      }
    )
  }
}