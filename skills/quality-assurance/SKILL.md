---
name: quality-assurance
description: Test software, websites, and applications for bugs, usability issues, and performance problems. Use when launching products, running quality checks, or establishing testing workflows.
---

# Quality Assurance

Ship high-quality products with confidence.

## Testing Types

### Functional Testing
- Unit tests
- Integration tests
- End-to-end tests
- API testing

### Usability Testing
- User flows
- Navigation
- Mobile responsiveness
- Accessibility

### Performance Testing
- Load testing
- Stress testing
- Speed optimization
- Scalability

### Security Testing
- Vulnerability scanning
- Penetration testing
- Data validation
- Authentication checks

## Testing Process

### 1. Test Planning
- Define scope
- Write test cases
- Set up environments
- Allocate resources

### 2. Test Execution
- Run test suites
- Log defects
- Track coverage
- Report status

### 3. Bug Management
- Document issues
- Prioritize severity
- Assign to developers
- Verify fixes

### 4. Release Decision
- Test summary
- Risk assessment
- Go/no-go criteria
- Rollback plan

## Tools

**Automated Testing:**
- Selenium
- Cypress
- Playwright
- Jest

**Manual Testing:**
- TestRail
- qTest
- Google Sheets

**Performance:**
- JMeter
- LoadRunner
- GTmetrix
- PageSpeed Insights

**Bug Tracking:**
- Jira
- Linear
- GitHub Issues
- Bugzilla

## Test Case Template

```
Test ID: TC001
Feature: User Login
Priority: High

Preconditions:
- Valid user account exists

Steps:
1. Navigate to login page
2. Enter valid email
3. Enter valid password
4. Click "Login"

Expected Result:
- User is logged in
- Redirected to dashboard
- Session cookie set

Actual Result:
[To be filled during testing]

Status: [Pass/Fail]
```

## Scripts

- `scripts/test-runner.py` - Execute test suites
- `scripts/bug-reporter.py` - Log issues
- `scripts/regression-tester.py` - Check for new bugs
- `scripts/performance-checker.py` - Speed testing
