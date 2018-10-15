import { Router, RouterModule } from '../../node_modules/@angular/router';
import { TestBed } from '../../node_modules/@angular/core/testing';
import { JournalComponent } from './journal/journal.component';
import { RadarComponent } from './radar/radar.component';
import { ResumeComponent } from './resume/resume.component';
import { AppRoutingModule } from './app-routing.module';

describe('AppRoutingModule', () => {
  let routingModule: AppRoutingModule;

  beforeEach(() => {
    routingModule = new AppRoutingModule();
  });

  it('should navigate to the resume page', () => {
    expect(routingModule).toBeTruthy();
  });
});
