import { Component, OnInit} from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { ResumeFormat } from './resume-format';
import { ResumeBasics } from './resume-parts';

@Component({
  selector: 'app-resume',
  templateUrl: './resume.component.html',
  styleUrls: ['./resume.component.css']
})
export class ResumeComponent implements OnInit {

  public resume: ResumeFormat;
  public basics: ResumeBasics;

  constructor(private http: HttpClient) {
  }

  ngOnInit(): void {
    this.getJSON().subscribe(data => {
      this.resume = data;
      this.basics = this.resume.basics;
    });
  }

  public getJSON(): Observable<ResumeFormat> {
    return this.http.get<ResumeFormat>('/assets/resume.json');
  }

}
