import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { RadarComponent } from './radar/radar.component';
import { JournalComponent } from './journal/journal.component';

const routes = [
  { path: 'radar', component: RadarComponent },
  { path: 'journal', component: JournalComponent }
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
