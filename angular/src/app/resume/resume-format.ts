import { ResumeBasics, ResumeWork, ResumeVolunteer,
    ResumeEducation, ResumeAward, ResumePublication,
    ResumeSkill, ResumeReference, ResumeInterest, ResumeLanguage
} from './resume-parts';

export class ResumeFormat {
    basics: ResumeBasics;
    work: [ResumeWork];
    volunteer: [ResumeVolunteer];
    education: [ResumeEducation];
    awards: [ResumeAward];
    publications: [ResumePublication];
    skills: [ResumeSkill];
    languages: [ResumeLanguage];
    interests: [ResumeInterest];
    references: [ResumeReference];
}
