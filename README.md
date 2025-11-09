# 📱 FocusMate  

FocusMate is a modern iOS productivity app that helps users **stay focused, manage tasks, and visualize their progress** — all in one place. It combines a **task manager**, **focus timer**, and **insightful analytics dashboard** into a cohesive experience designed to build better habits and consistency.  

---

## 🚀 Features  

### 🎯 Focus Sessions  
- Start **focus sessions** with allotted time and live progress tracking.  
- Real-time progress updates with **Dynamic Island Live Activities** and **Lock Screen widgets**.  
- Automatic handling of app backgrounding — reminders to return or resume sessions.  
- Abandon sessions anytime, with all data safely persisted in Core Data.  

### ✅ Task Management  
- Create tasks with custom titles, categories, and time goals.  
- Mark tasks as **completed**, **in progress**, or **abandoned**.  
- Smart dashboard UI to view, manage, and track ongoing tasks.  

### 📊 Stats & Analytics  
- **Focus Score** calculated as `timeCompleted ÷ timeAllotted` (per session/day/week/month).  
- **Line Chart**: Visualize focus trends over time with Swift Charts.  
- **Bar Chart**: Compare allotted vs. completed time.  
- Tap any day in the chart to view the list of tasks from that day.  

### 💡 Productivity Insights *(upcoming)*  
- Real-time focus performance summary.  
- Average daily and weekly focus scores.  
- Personalized insights and improvement suggestions based on patterns.  

---

## 🛠️ Tech Stack  

- **Language:** Swift 6  
- **Frameworks:**  
  - 🧠 **SwiftUI** – Declarative, state-driven UI  
  - 📊 **Swift Charts** – Interactive data visualizations  
  - 💾 **Core Data** – Persistent task and session storage  
  - 🔔 **ActivityKit** – Dynamic Island & Live Activity updates  
  - 🕐 **UserNotifications** – Background session reminders  

---

## 🗂️ Project Architecture  

| Layer | Responsibility |
|-------|----------------|
| `FocusModeView` | Runs active focus sessions with live progress updates. |
| `DashboardView` | Task creation, management, and navigation to active sessions. |
| `StatsView` | Displays analytics and focus trends using Swift Charts. |
| `StatsViewModel` | Aggregates and filters data by day/week/month. |
| `FocusSessionEntity` | Core Data model for sessions and completion metrics. |

---

## 📈 Roadmap  

- [x] Task creation, completion, and abandonment  
- [x] Core Data persistence  
- [x] Swift Charts analytics  
- [x] Focus Score calculation  
- [x] Dynamic Island Live Activity integration  
- [x] Background reminders using notifications  
- [ ] Show tasks for a selected day in Stats  
- [ ] Streak tracking (daily consistency)  
- [ ] Focus insights & personalized feedback  
- [ ] iCloud sync for data persistence across devices  

---

## 🎨 Design  

- Minimal, distraction-free UI inspired by focus-oriented design principles.  
- Adaptive light and dark mode support.  
- Planned: Custom themes and typography settings.  

---

## 🤝 Contribution  

Contributions, feedback, and feature ideas are always welcome!  
Submit an issue or open a pull request to help improve FocusMate.  

---

## 📄 License  

This project is licensed under the **MIT License** – see the [LICENSE](LICENSE) file for details.  

---

## 📸 Screenshots  

<table>
  <tr>
    <td align="center">
      <img width="301" height="655" alt="Progress View" src="https://github.com/user-attachments/assets/29f37adc-72a6-452b-a43d-fe29a4caf964" />
      <br />
      <sub>🕒 Focus Progress View</sub>
    </td>
    <td align="center">
      <img width="301" height="655" alt="Alert View" src="https://github.com/user-attachments/assets/2f978eb8-e466-402e-96a9-c48883093fa6" />
      <br />
      <sub>🚨 Focus Session Alert</sub>
    </td>
  </tr>
</table>

🎥 [App Demo](https://github.com/user-attachments/assets/5697ea0e-e1b7-4687-9f04-5c8b337e9267)  
📊 [Progress View](https://github.com/user-attachments/assets/3c23c7ac-0274-438b-b17a-8d161fb0afb8)  
🔔 [Alert View](https://github.com/user-attachments/assets/5a86996c-7539-4194-8b2a-ac6a70023034)  

---

⚡ *FocusMate helps you stay consistent, track your progress, and build sustainable focus habits over time.*
