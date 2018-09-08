import { Component, OnInit} from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { ResumeFormat } from './resume-format';

@Component({
  selector: 'app-resume',
  templateUrl: './resume.component.html',
  styleUrls: ['./resume.component.css']
})
export class ResumeComponent implements OnInit {

  public resume: ResumeFormat;

  constructor(private http: HttpClient) {
  }

  ngOnInit(): void {
    this.getJSON().subscribe(data => {
      this.resume = data;
    });
  }

  public getJSON(): Observable<ResumeFormat> {
    return this.http.get<ResumeFormat>('/assets/resume.json');
  }

}
