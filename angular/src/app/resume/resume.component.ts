import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-resume',
  templateUrl: './resume.component.html',
  styleUrls: ['./resume.component.css']
})
export class ResumeComponent implements OnInit {

  constructor(private http: HttpClient) {
    
  }

  public data

  public getJSON(): Observable<any> {
    return this.http.get("/resume.json");
  }

  ngOnInit() {
    this.getJSON().subscribe(data => {
      console.log(data);
      this.data = data;
    }, error => { console.log(error); });
  }

}
