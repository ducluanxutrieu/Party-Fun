import { Component, OnInit, Inject, HostListener } from '@angular/core';
import { DOCUMENT } from '@angular/common';

declare var $: any;

@Component({
  selector: 'scroll-to-top',
  templateUrl: './scroll-to-top.component.html',
  styleUrls: ['./scroll-to-top.component.css']
})


export class ScrollToTopComponent implements OnInit {

  isWindowScrolled: boolean;

  constructor(@Inject(DOCUMENT) private document: Document) { }
  @HostListener("window:scroll", [])

  onWindowScroll() {
    if (this.document.body.scrollTop > 30 || this.document.documentElement.scrollTop > 30) {
      this.isWindowScrolled = true;
      $('.scroll-top-btn').fadeIn(200);
    } else {
      this.isWindowScrolled = false;
      $('.scroll-top-btn').fadeOut(200);
    }
  }

  scrolltoTop() {
    // this.document.body.scrollTop = 0;
    // this.document.documentElement.scrollTop = 0;
    $("html,body").animate({
      scrollTop: 0
    }, 500);
  }

  ngOnInit() { }

}
