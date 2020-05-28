import { Component, OnInit, ViewEncapsulation } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';

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
  similar_posts: Post[] = [];

  constructor(
    private activatedRoute: ActivatedRoute,
    private postService: PostService,
    private router: Router,
  ) { }

  ngOnInit() {
    this.activatedRoute.params.subscribe(params => {
      let post_id = params['id'];
      this.get_post(post_id);
    })

    this.get_similar_posts();
  }
  // Lấy thông tin bài viết
  get_post(id: string) {
    this.postService.get_post(id).subscribe(
      res => {
        this.post = res.data as Post;
      },
      err => {
        if (err.error.message == "Không tìm thấy Id bài viết") {
          this.router.navigate(['/404']);
        }
        console.log("Error: " + err.error.message);
        toastr.error("Error loading post!");
      }
    )
  }

  // Lấy danh sách bài viết tương tự
  get_similar_posts() {
    this.postService.get_posts_list(1).subscribe(
      res => {
        this.similar_posts = res.data.value as Post[];
      },
      err => {
        console.log("Error: " + err.error.message);
      }
    )
  }
}