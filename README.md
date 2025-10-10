# 📱 FocusMate

FocusMate is an iOS app designed to help users manage their tasks, track productivity, and analyze focus trends over time. The app combines a **task manager**, **focus session tracker**, and **stats dashboard** into one seamless experience.  

---

## 🚀 Features  

### ✅ Task Management  
- Add new tasks with an allotted time.  
- Mark tasks as **completed** or **abandoned**.  
- Simple dashboard UI for managing active sessions.  

### 📊 Stats & Analytics  
- **Focus Score** (per session, daily, weekly, monthly) based on `timeCompleted ÷ timeAlloted`.  
- **Line chart** showing focus score trend over time.  
- **Bar chart** comparing time allotted vs. time completed.  
- Tap on any day in the chart to view tasks from that day.  

### 🎯 Productivity Insights *(in-progress)*  
- Current session’s focus score.  
- Average daily and weekly focus score.  
- Suggestions to improve focus score (planned).  

---

## 🛠️ Tech Stack  

- **Language:** Swift 6  
- **Frameworks:**  
  - **SwiftUI** for UI  
  - **Swift Charts** for graphs & visualizations  
  - **Core Data** for task/session persistence  
- **Design:** Custom fonts & UI themes (upcoming)  

---

## 🗂️ Project Structure  

- `DashboardView` → Add/manage tasks, run sessions.  
- `StatsView` → Charts, focus score, daily breakdown.  
- `StatsViewModel` → Data aggregation (per-day/week/month).  
- `FocusSessionEntity` → Core Data model for sessions.  

---

## 📈 Roadmap  

- [x] Add and complete tasks  
- [x] Dashboard UI  
- [x] Stats screen with charts  
- [x] Calculate and persist focus score  
- [ ] Show task list for selected day in stats  
- [ ] Background task handling  
- [ ] Streaks (daily consistency tracking)  
- [ ] Productivity insights based on focus score trends  

---

## 🤝 Contribution  

Contributions, issues, and feature requests are welcome!  
Feel free to open a pull request or raise an issue.  

---

## 📄 License  

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.  

---

⚡ *FocusMode helps you stay consistent, analyze your habits, and build better focus over time.*  

---

## Screenshots
<table>
  <tr>
    <td align="center">
    <img width="301" height="655" alt="Simulator Screenshot - iPhone 16 Pro - 2025-08-15 at 00 56 08" src="https://github.com/user-attachments/assets/29f37adc-72a6-452b-a43d-fe29a4caf964" />
      <br />
      <sub>Light Mode Progress View</sub>
    </td>
    <td align="center">
      <img width="301" height="655" alt="Simulator Screenshot - iPhone 16 Pro - 2025-08-15 at 00 56 15" src="https://github.com/user-attachments/assets/2f978eb8-e466-402e-96a9-c48883093fa6" />
      <br />
      <sub>Light Mode Alert View</sub>
    </td>
  </tr>
</table>

[Progress View](https://github.com/user-attachments/assets/3c23c7ac-0274-438b-b17a-8d161fb0afb8)

[Alert View](https://github.com/user-attachments/assets/5a86996c-7539-4194-8b2a-ac6a70023034)

[App Demo](https://github.com/user-attachments/assets/5697ea0e-e1b7-4687-9f04-5c8b337e9267)




