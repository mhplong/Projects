import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { RadarComponent } from './radar/radar.component';
import { JournalComponent } from './journal/journal.component';
import { ResumeComponent } from './resume/resume.component';

const routes = [
  { path: 'radar', component: RadarComponent },
  { path: 'journal', component: JournalComponent },
  { path: 'resume', component: ResumeComponent }
];

@NgModule({
  imports: [
    RouterModule.forRoot(routes)
  ],
  exports: [
    RouterModule
  ]
})
export class AppRoutingModule { }
