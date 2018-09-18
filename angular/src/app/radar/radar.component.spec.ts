import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RadarComponent } from './radar.component';
import { By } from '@angular/platform-browser';
import { DebugElement } from '@angular/core';

function queryCss(fixture: ComponentFixture<any>, name: string): DebugElement {
  return fixture.debugElement.query(By.css(name));
}

describe('RadarComponent', () => {
  let component: RadarComponent;
  let fixture: ComponentFixture<RadarComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RadarComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RadarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should display radar image background', () => {
    const radarBackground = queryCss(fixture, '#radar-background');
    expect(radarBackground).toBeTruthy('radar image is displayed');
  });

  it('should show radar image', () => {
    const radar = queryCss(fixture, '#radar');
    expect(radar).toBeTruthy('radar image is displayed');
  });
});
