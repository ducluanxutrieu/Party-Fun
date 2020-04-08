import { Component, OnInit, Inject, HostListener } from '@angular/core';
import { DOCUMENT } from '@angular/common';

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
    } else {
      this.isWindowScrolled = false;
    }
  }

  scrolltoTop() {
    this.document.body.scrollTop = 0;
    this.document.documentElement.scrollTop = 0;
  }

  ngOnInit() { }

}
