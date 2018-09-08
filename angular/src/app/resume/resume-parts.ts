export class ResumeBasics {
    name: string;
    label: string;
    picture: string;
    email: string;
    phone: string;
    website: string;
    summary: string;
    location: {
        address: string,
        postalCode: string,
        city: string,
        region: string
    };
    profiles: [
        {
            network: string,
            username: string,
            url: URL
        }
    ];
}

export class ResumeWork {
    company: string;
    position: string;
    website: URL;
    startDate: Date;
    endDate: Date;
    summary: string;
    highlights: [string];
}

export class ResumeVolunteer {
    organization: string;
    position: string;
    website: URL;
    startDate: Date;
    endDate: Date;
    summary: string;
    highlights: [string];
}

export class ResumeEducation {
    institution: string;
    area: string;
    studyType: string;
    startDate: Date;
    endDate: Date;
    gpa: number;
    courses: [string];
}

export class ResumeAward {
    title: string;
    date: Date;
    awarder: string;
    summary: string;
}

export class ResumePublication {
    contents: any;
}

export class ResumeSkill {
    name: string;
    level: string;
    keywords: [string];
}

export class ResumeLanguage {
    name: string;
    level: string;
}

export class ResumeInterest {
    name: string;
    keywords: [string];
}

export class ResumeReference {
    name: string;
    contact: string;
}
