import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { UserCartInfoComponent } from './user-cart-info.component';

describe('UserCartInfoComponent', () => {
  let component: UserCartInfoComponent;
  let fixture: ComponentFixture<UserCartInfoComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ UserCartInfoComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(UserCartInfoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
