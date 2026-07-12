import { ComponentFixture, TestBed } from '@angular/core/testing';
import { of, throwError } from 'rxjs';
import { SidebarComponent } from './sidebar.component';
import { UserService } from '../../_services/user.service';
import { User } from '../../_models/user.model';

describe('SidebarComponent', () => {
  let component: SidebarComponent;
  let fixture: ComponentFixture<SidebarComponent>;
  let userService: jasmine.SpyObj<UserService>;

  const mockUser: User = { full_name: 'John Doe', username: 'johndoe', avatar: 'avatar.png' } as User;

  beforeEach(async () => {
    userService = jasmine.createSpyObj('UserService', ['get_userInfo']);
    userService.get_userInfo.and.returnValue(of({ data: mockUser, message: 'ok' }));

    await TestBed.configureTestingModule({
      declarations: [SidebarComponent],
      providers: [{ provide: UserService, useValue: userService }]
    }).compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(SidebarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('loads user info on init', () => {
    expect(userService.get_userInfo).toHaveBeenCalled();
    expect(component.user_info).toEqual(mockUser);
  });

  it('handles error when loading user info', () => {
    userService.get_userInfo.and.returnValue(throwError({ error: { message: 'Unauthorized' } }));
    component.get_userInfo();
    expect(component.user_info).toBeUndefined();
  });
});
