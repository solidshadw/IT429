## Playbook: Phishing Incident

### MITRE

| Tactic         | SubTechniques ID | Technique Name      | Sub-Technique Name           | Platforms | Permissions Required |
| -------------- | ------------ | ------------------- | ---------------------------- | --------- | --------------------- |
| Initial Access | T1566.001        | Phishing           | Spearphishing Attachment     | All       | User-level            |
| Initial Access | T1566.002        | Phishing           | Spearphishing Link           | All       | User-level            |
| Initial Access | T1566.003        | Phishing           |  Spearphishing via Service    | All       | User-level            |
| Initial Access | T1566.004        | Phishing           | Spearphishing Voice           | All       | User-level            |
| Credential Access | T1078    | Valid Accounts     | Account Manipulation         | All       | User-level            |

```
(P) Preparation
- Ensure all team members are trained in recognizing phishing tactics and are familiar with incident response protocols.
- Maintain up-to-date contact lists for relevant personnel in IT, HR, and Legal.
- Verify that incident detection and monitoring tools are configured to alert on common phishing indicators (e.g., suspicious login attempts, unexpected email links or attachments).
- Test and ensure email filtering and anti-phishing software is functional and effective
```

Assign steps to individuals or teams to work concurrently.

Assigned to: Security Analyst Team, IT Response Team, and Communications Officer.

--------------
### Investigate
#### Objective: Detect the incident, determine its and involve appropriate parties

1. **Phising Detection and Analysis**: 
   * Check email logs to identify all recipients of the suspicious email.
   * Confirm whether any users clicked the link or downloaded attachments.
   * Verify any login attempts or data access following the email interaction.
   * Check headers for suspicious metadata.
   * Use sandboxing tools to analyze any attachments for malicious behavior.
   * Trace URLs in the email to identify if they lead to known phishing sites.
   * Check affected user accounts for unusual login locations or access times.
   * Investigate whether any sensitive data has been accessed, downloaded, or transferred.
2. **Phishing Attack Scope**:
   * Determine number of users that received the email or targeted users
   * Search for compromised accounts
3. Collect Evidence
   * Make sure logging is in place
--------------

### Remediate
**Objective: Take action to stop the phishing attack.**

#### Contain

1. **Isolate Affected Systems**:
   * Disconnect any compromised machines from the network if malware is detected.
   * Temporarily lock affected accounts.
2. **Prevent Further Spread**:
   * Block known malicious URLs, IP addresses, and email addresses associated with the phishing attempt.
   * Flag and remove all instances of the phishing email from user inboxes using email filtering tools.
3. **Remove Malicious Content**
   * **Delete Phishing Emails** from user inboxes using email filtering tools or remove them from quarantine.
   * **Block URLs** linked to phishing sites on all systems to prevent further access.
   * **Use Sandboxing** tools to safely analyze and remove any attachments or files that were part of the phishing attempt.
4. **Notify Affected Users**:
   * Inform users to avoid clicking links or downloading attachments in suspicious emails.
   * Advise password changes for any users who clicked on phishing links or provided credentials.

#### Tools that can be used: 
   * Joe SandBox to analyze the file that was downloaded: https://www.joesandbox.com
   * Email Software to delete email from other inboxes
   * EDRs like CrowdStrike Falcon, Carbon Black, SentinelOne can help detect and isolate compromised endpoints, allowing for rapid response to potential malware or other malicious activities on user devices.

#### Eradicate

1. **Remove Malicious Files**:
   * Ensure all malware or suspicious files identified are deleted from affected systems.
   
2. **Reinforce Filters**:
   * Update email filters to prevent future phishing emails with similar patterns.

3. **Reset Credentials**:
   * Enforce a password reset for all affected accounts.
   * 

#### Reference: Remediation Resources
Need to reach out to the 
* Personnel: Security Analyst Team, IT Support, Communications Officer
* Financial: Licensing for EDR and sandbox tools
* Logistical: Coordination across IT, HR, and affected departments

--------------

### Communicate

1. **Notify Stakeholders**:
   * Inform management, IT, and affected departments of the incident status and containment measures.
   
2. **User Advisory**:
   * Send a company-wide alert regarding the phishing attempt, including guidance on recognizing phishing. Very careful about this one. Only sent one out if neccessary.

3. **Legal and Compliance Reporting**:
   * Inform Legal and Compliance teams, especially if data may have been compromised.

--------------

### Recover

1. **Restore Access**:
   * Ensure all affected accounts and systems are securely restored with new credentials.
   
2. **Monitor Systems**:
   * Increase monitoring on previously affected accounts and systems for any signs of persistent threats.

3. **Conduct Awareness Training**:
   * Provide additional phishing training for all employees, emphasizing recent tactics and red flags.

--------------

### Lessons Learned

1. **Importance of Regular User Awareness Training**
   - Many phishing attacks succeed due to human error. Regular, updated training on phishing tactics and red flags can significantly reduce the likelihood of users interacting with phishing emails.
   - Conducting simulated phishing exercises can reinforce training and highlight areas where users may need additional guidance.

2. **Need for Strong Email Filtering and Monitoring**
   - Effective email filtering and monitoring can block most phishing emails before they reach users. Regularly updating filters based on the latest threats and indicators of compromise (IOCs) is crucial.
   - Monitoring email traffic for unusual patterns, such as spikes in suspicious emails or phishing-related keywords, can provide early warning signs of a phishing campaign.

3. **Multi-Factor Authentication (MFA) as a Crucial Layer of Defense**
   - Phishing often targets user credentials, so having MFA in place can help protect accounts even if passwords are compromised.
   - Encouraging or enforcing MFA across the organization, especially for high-value systems and sensitive data access, adds an essential layer of protection.
     
4. **Importance of Threat Intelligence in Preventing Future Attacks**
   - Utilizing threat intelligence on current phishing trends, malicious domains, and common tactics helps the organization stay proactive against emerging threats.
   - Subscribing to reputable threat intelligence feeds and regularly updating blocklists with known malicious IPs and URLs can prevent similar incidents.

### Additional Resources
https://attack.mitre.org/techniques/T1566/
