**Intake Questions:**

What are you salary or total compensation expectations that you would like to share at this time?
- My expected salary is 160k - 180k

Do you require sponsorship at this time? If so, please share those details.
- I don't. I'm an American citizen

Are you open to going into the office on a hybrid basis (3 days a week?)
- I'm currently located in Utah and this was posted as a virtual location for Washington. I'm happy to go into the office as needed and travel to that location. But, I would expect this role to be mostly remote.
What would be an ideal start date if everything goes well and you receive an offer?
- I'm flexible on this date. I would like to give my current employer a two-week notice. As long as I provide them with this notice, I can begin immediately afterwards.

Are you currently interviewing or do you have any pending offers?
- No, I'm not currently interviewing anywhere else.

In case this role is not a fit, would you be open to relocating for other security engineer openings? (Seattle OR Austin)
- Currently, no. A remote role is what I'm seeking.

**Role Related Questions:**

In the last year, how many manual code reviews have you performed?
- I have performed 2 code reviews for our internal applications written in .NET. This came after we found a SQL Injection vulnerability and I worked in tangent with the developers to help identify the vulnerability in the code.

Please list what stages you are involved in for the above: (Scoping, Test Execution, Reporting, Remediation) of the engagement?
- I was involved in all the stages of the pentest: 
	- **Scoping:** I gathered the requirements, assets, and goals for the pentest from the stakeholders, whether for compliance or as a red team exercise. I ensured the scope was clear and that my team understood the boundaries.
	- **Test Execution:** I actively participated in testing the environment, from reconnaissance through compromising a host and establishing persistence. I was finding and exploiting vulnerabilities.
	- **Reporting:** Throughout the pentest, all activities were monitored by the SOC. I ensured the SOC had visibility into our actions. If not, that was a finding on itself, to improve logging. At the end, we compiled a report detailing vulnerabilities, proof of concepts, and remediation steps for the stakeholders.
	- **Remediation:** I was responsible for following up on the tickets created for the identified vulnerabilities as part of the pentest.   

Please tell me about your scripting and coding abilities (required for this role in order to perform security automation).
- I have experience with scripting and coding for automation, which is essential for performing security automation tasks. For example, during a pentest, we needed more visibility into our external domains and subdomains to expand our external attack surface. To achieve this, I developed a Bash script that automated the process. The script would download and install necessary tools on Kali Linux, our penetration testing operating system. It then utilized these tools to perform real-time scans of our external domains, providing us with up-to-date information on any exposed external domains. This automation significantly improved our ability to monitor and find any potential vulnerabilities in our external assets. 
- I also have experience with Golang and Python3. Which I have used golang to help me automate some tasks, for example this simple IP counter in my github repository: https://github.com/solidshadw/goIpCounter
- I also have experience with terraform, which I used to built a phishing environment and to automate to creation of an environment for the SOC class that I teach at Ensign College.

Please tell me about your experience with threat modeling.
- My threat modeling experience comes from collaborating with the Security Operations Center (SOC) team in conducting exercises that involved identifying potential threats and vulnerabilities within our systems, analyzing their possible impacts, and developing strategies to mitigate these risks. Through that process, I helped enhanced their incident response capabilities . 
- During my red team exercised, I used the MITRE ATT&CK framework to evaluate the risk of the vulnerability based on the CVSS which then takes into consideration factors such as the ease of exploitation, potential impact on confidentiality, integrity, and availability, and the level of access required for an attack. This approach allowed me to prioritize vulnerabilities effectively, ensuring that the most critical issues were addressed first to enhance our overall security posture.
- During my time at Arctic Wolf Networks as a Concierge Security Engineer, I was deeply involved in threat modeling processes. I implemented, oversaw, managed, and supported network security infrastructure for multiple enterprise customers. I played a key role in analyzing logs, which was crucial for identifying potential security threats and forming the basis for our customers' threat models.

How many years professionally (paid within an organization + non internship) experience do you have within pentesting?
- I have 3 years of pentesting experience

What would you consider is your strongest security discipline?
- I consider my strongest security discipline to be offensive security, specifically in the areas of red teaming and penetration testing. My experience as a Red Teamer at Merrick Bank has sharpened my skills in identifying and exploiting vulnerabilities. This role required a deep understanding of threat modeling, hands-on testing, and the use of frameworks like MITRE ATT&CK. My attention to detail and thoroughness helps me discover vulnerabilities that might otherwise go undetected by automated scans. Additionally, my ability to script and code my own tools enhances my effectiveness and efficiency in conducting penetration tests.