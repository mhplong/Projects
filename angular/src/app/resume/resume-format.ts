export class ResumeFormat {
    basics: {
        name: string,
        label: string,
        picture: string,
        email: string,
        phone: string,
        website: string,
        summary: string,
        location: {
            address: string,
            postalCode: string,
            city: string,
            region: string
        },
        profiles: [
            {
                network: string,
                username: string,
                url: URL
            }
        ]
    };
    work: [
        {
            company: string,
            position: string,
            website: URL,
            startDate: Date,
            endDate: Date,
            summary: string,
            highlights: [string]
        }
    ];
    volunteer: [
        {
            organization: string,
            position: string,
            website: URL,
            startDate: Date,
            endDate: Date,
            summary: string,
            highlights: [string]
        }
    ];
    education: [
        {
            institution: string,
            area: string,
            studyType: string,
            startDate: Date,
            endDate: Date,
            gpa: number,
            courses: [string]
        }
    ];
    awards: [
        {
            title: string,
            date: Date,
            awarder: string,
            summary: string
        }
    ];
    publications: [any];
    skills: [
        {
            name: string,
            level: string,
            keywords: [string]
        }
    ];
    languages: [
        {
            name: string,
            level: string
        }
    ];
    interests: [
        {
            name: string,
            keywords: [string]
        }
    ];
    references: [any];
}
