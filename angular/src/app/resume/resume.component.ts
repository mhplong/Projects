import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-resume',
  templateUrl: './resume.component.html',
  styleUrls: ['./resume.component.css']
})
export class ResumeComponent implements OnInit {

  constructor() { }

  public items = [
    "Mark Long",
    "1065 Old Mill Run",
    "Leeds, AL 35094"
  ]

  ngOnInit() {
  }

}
