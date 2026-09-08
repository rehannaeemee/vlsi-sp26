# EE476 Lab 1 progress portal setup

The updated manual uses the recommended **instructor roster + email activation** method. Students do not choose a roll number or submit evidence. After activation, each student clicks only the Lab 1 tasks they have completed. All seven tasks have equal weight.

## 1. Create the database

1. Create a Supabase project at <https://supabase.com/>.
2. Open **SQL Editor** in the project.
3. Open `lab-progress-supabase-setup.sql` and replace `REPLACE_WITH_INSTRUCTOR_EMAIL` with your own email address.
4. Run the complete SQL file.

The SQL creates the roster, activated profiles, seven Lab 1 tasks, progress records, change history, instructor dashboard function, and row-level security policies.

## 2. Configure email sign-in

1. In Supabase, open **Authentication → Providers → Email** and keep the Email provider enabled.
2. Open **Authentication → URL Configuration**.
3. Set the Site URL to the deployed address of the lab manual.
4. Add the deployed lab-manual URL to the allowed Redirect URLs.

The manual must be served from a website address. Passwordless email links will not work reliably when the HTML is opened directly with a `file://` address.

## 3. Connect the HTML file

In `lab-manual-progress.html`, search for this comment near the end:

```text
LAB 1 PROGRESS CONFIGURATION
```

Replace these two values:

```javascript
supabaseUrl: "YOUR_SUPABASE_PROJECT_URL",
supabaseAnonKey: "YOUR_SUPABASE_ANON_KEY",
```

Copy the Project URL and anon/public key from **Supabase → Project Settings → API**. Never put a service-role key in the HTML file.

## 4. Activate the instructor account

1. Deploy the updated manual.
2. Click **Lab progress login** in the top navigation.
3. Enter the instructor email used in the SQL setup.
4. Open the secure link received by email.

The same button will then open the instructor dashboard.

## 5. Import the student roster

1. Open the instructor dashboard.
2. Download the roster CSV template.
3. Fill the columns `roll_number`, `full_name`, and `email`.
4. Import the CSV through **Manage the student roster**.

Email addresses and roll numbers must be unique. Reimporting an existing email updates that roster record.

## 6. Student workflow

1. The student opens the lab manual and clicks **Lab progress login**.
2. The student enters the exact email address in the instructor roster.
3. Supabase emails a passwordless sign-in link.
4. The student opens Lab 1 and clicks **Mark complete** for each finished task.
5. Clicking **Completed** again returns the task to incomplete. Every change is timestamped in the database history.

The progress percentage is calculated as:

```text
completed Lab 1 tasks ÷ 7 × 100
```

No student can view another student's progress. Only an activated instructor account can access the class dashboard or import roster records.
