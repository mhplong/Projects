import { Component, OnInit } from '@angular/core';
import * as json from './resume.json';

@Component({
  selector: 'app-resume',
  templateUrl: './resume.component.html',
  styleUrls: ['./resume.component.css']
})
export class ResumeComponent implements OnInit {

  constructor() { }

  public data

  ngOnInit() {
    this.data = json;
  }

}
