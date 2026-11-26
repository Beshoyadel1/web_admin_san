# Antigravity & Agent Engineering Guidelines — San Admin System

This document defines the strict engineering guidelines, architecture standards, and execution directives for any AI coding agent working on the `web_admin_san` admin dashboard.

---

## 🚨 STRICTLY FORBIDDEN ANTI-PATTERNS (Zero Tolerance)

1. **❌ NEVER Hardcode Colors**:
   - Never write inline `Color(0xFF...)`, `Colors.white`, `Colors.grey`, `Colors.black`, etc.
   - **Always** use centralized color tokens from `AppColors` in `lib/core/theming/colors.dart`. If a required color does not exist, add it to `AppColors` first.

2. **❌ NEVER Write Private Methods Returning Widgets**:
   - Never write `Widget _buildSection()`, `Widget _buildRow()`, `Widget _buildCard()`.
   - **Always** extract sub-widgets into dedicated, standalone `StatelessWidget` classes with `const` constructors under the feature's `presentation/custom_widget/` directory.

3. **❌ NEVER Perform Direct API/Network Calls in Widgets**:
   - Never call `Network.getData(...)` or raw HTTP inside UI widgets, dialogs, or build methods.
   - **Always** route calls through the feature's `data/datasource/` and trigger them through `presentation/bloc/` (`Cubit`).

4. **❌ NEVER Use Context Across Async Gaps Without Mounted Checks**:
   - Always ensure `if (!context.mounted) return;` before using `BuildContext` after `await`.

---

## 1. FCM (Firebase Cloud Messaging) Implementation Standard

Benchmark reference: [`D:\Flutter-Projects\sun_dashboard_company`](file:///D:/Flutter-Projects/sun_dashboard_company)

### A. Web Service Worker & Cross-Tab Bridge
1. **Service Worker (`web/firebase-messaging-sw.js`)**:
   - Ensure Firebase config matches `lib/firebase_options.dart`.
   - In `onBackgroundMessage`, broadcast the payload to all open tabs:
     ```javascript
     self.clients.matchAll({ type: "window", includeUncontrolled: true }).then((windowClients) => {
       for (let i = 0; i < windowClients.length; i++) {
         windowClients[i].postMessage({
           isFcmBackgroundMessage: true,
           data: d,
           notification: { title: notificationTitle, body: notificationBody }
         });
       }
     });
     ```
   - In `notificationclick`, focus existing open admin tabs or open `/` if none exist, sending `isFcmClick: true`.

2. **Web Interop Layer (`lib/core/services/web_interop/`)**:
   - Implement `web_interop_web.dart` using `dart:js_interop` and `package:web`.
   - Listen to `window.navigator.serviceWorker` messages so that background tabs and notification clicks trigger instant UI and sound updates.
   - Maintain conditional imports (`web_interop.dart`, `web_interop_stub.dart`, `web_interop_web.dart`) to keep non-web platforms compilable.

### B. Token Lifecycle & Backend Sync
* **Web Token Hygiene**: On Flutter Web, do not store or send fallback dummy tokens (`fcm_web_...`). Only send genuine FCM tokens fetched with `FcmConfig.webVapidKey`.
* **Backend Sync Contract**:
  - Sync tokens via `ApiLink.updateFcmToken` with payload:
    ```dart
    {
      'userId': adminUserId,
      'userType': UserType.adminUser, // 6
      'fcmToken': token,
    }
    ```
  - Subscribe admin clients to topics: `NotificationTopic.admin` and `'all'`.
* **Sound Alerts**:
  - Centralize notification sounds through `AudioService` (e.g., play order alert on `neworder`).

---

## 2. UI Engineering & Dashboard Standards

### A. Responsive Web & Desktop Usability
1. **Mouse Cursors**:
   - Interactive elements, custom cards, table rows, and icon buttons must provide click cursor feedback:
     ```dart
     MouseRegion(
       cursor: SystemMouseCursors.click,
       child: ...
     )
     ```
2. **Desktop Scrollbars**:
   - Wide data tables and scrollable lists must display persistent scrollbars:
     ```dart
     Scrollbar(
       thumbVisibility: true,
       controller: _scrollController,
       child: ...
     )
     ```

### B. Screen Architecture & 4-State UI Contract
Every dashboard screen must strictly handle four states:
1. **Initial**: Setup state before fetching.
2. **Loading**: Use shimmering skeleton loaders (`custom_widget/loading_shimmer.dart`) rather than blocking whole-screen spinners.
3. **Success**: Display data cleanly with responsive breakpoints (Mobile / Tablet / Desktop).
4. **Error**: Display a user-friendly error card with an explicit "إعادة المحاولة" / "Retry" button.

---

## 3. API Integration & Clean Data Flow

### A. Feature Folder Structure
Every feature in `lib/features/<feature_name>/` must follow the clean modular pattern:

```
lib/features/<feature_name>/
├── data/
│   ├── datasource/
│   │   └── <action>_datasource/
│   │       └── <action>_datasource.dart
│   ├── model/
│   │   └── <action>_model/
│   │       └── <action>_model.dart
│   └── request/
│       └── <action>_request/
│           └── <action>_request.dart
└── presentation/
    ├── bloc/
    │   └── <action>_cubit/
    │       ├── <action>_cubit.dart
    │       └── <action>_state.dart
    ├── custom_widget/
    └── pages/
        └── <feature>_page.dart
```

### B. Datasource Contract
* Route all requests through `Network` (`lib/core/api/dio_function/dio_controller.dart`).
* Verify and unwrap responses defensively:
  ```dart
  Future<MyFeatureModel> getFeatureData({required MyRequest request}) async {
    try {
      final response = await Network.getDataWithBodyAndParams(
        {},
        request.toJson(),
        ApiLink.myEndpoint,
      );
      final responseData = response.data;
      final bool success = responseData['success'] ?? false;
      if (!success) {
        throw Exception(responseData['message'] ?? 'Unexpected server error');
      }
      return MyFeatureModel.fromJson(responseData['data']);
    } on DioException catch (e) {
      throw Exception(responseOfStatusCode(e.response?.statusCode));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  ```

### C. Cubit State Management Contract
1. **Immutable States**: States must be distinct and immutable (using `Equatable`).
2. **Safe Emits**: Always protect emits against closed cubits:
   ```dart
   if (isClosed) return;
   emit(MyFeatureSuccess(data));
   ```
3. **BlocListener vs BlocBuilder**:
   - Use `BlocListener` / `BlocConsumer` for snackbars, dialogs, and navigation.
   - Use `BlocBuilder` strictly for widget building. Never trigger navigation or side effects inside a builder callback.

---

## 4. Technical Support, Tickets & Omni-Chat Engineering Standard

Benchmark reference: [`lib/features/technical_support/`](file:///d:/Flutter-Projects/web_admin_san/lib/features/technical_support) & [`ADMIN_FIREBASE_CHAT_NOTIFICATION_INTEGRATION_GUIDE.md`](file:///d:/Flutter-Projects/web_admin_san/ADMIN_FIREBASE_CHAT_NOTIFICATION_INTEGRATION_GUIDE.md)

In the San Admin dashboard, customer support and issue tickets are managed as multi-party support threads (Omni-Support System) connecting Admins with Clients (`type: 1`), Drivers (`type: 3`), Providers (`type: 4`), Employees (`type: 5`), and other Admins (`type: 6`).

### A. Role-Based Permissions & Access Control
* **Permission Gate**: The support ticket center must be gated behind:
  ```dart
  if (!user.hasPermission(permissions.support)) {
    // Hide navigation item or show PermissionDeniedWidget
  }
  ```

### B. Responsive 3-Panel Ticket Layout
On Desktop and Web browsers, the ticket center must render a 3-column master-detail layout:
1. **Conversations / Ticket List Panel** (`ChatConversationsPanel`):
   - Shows active ticket threads with search filter (by user name, ticket ID, or phone).
   - Displays party type badge (Client / Driver / Provider), last message snippet, timestamp, and unread counter badge.
2. **Active Ticket Thread Panel** (`ChatThreadPanel`):
   - **Header**: Shows recipient details, online status, and linked Order ID (`orderId`) if the ticket relates to a specific order with a clickable link to order details.
   - **Body**: Chat bubble list with persistent desktop scrollbar (`Scrollbar`), auto-scrolling to newest message.
   - **Footer**: Text input field with attachment option and Enter-to-send keyboard shortcut.
3. **Internal Escalation & Team Panel** (`ChatWorkTeamPanel`):
   - Allows the admin to coordinate with internal support agents (`getWorkTeam`), assign tickets, or escalate issues.

### C. Real-Time Pipeline & Active Ticket Suppression
* **Live Event Stream**: Listen to incoming chat events via `ChatEvents.instance.stream`.
* **Suppress Intrusive Popups for Active Ticket**:
  - Maintain `ChatEvents.instance.activeChatUserId` and `activeChatUserType`.
  - When a message arrives for the **currently open ticket**, append it immediately to the active thread and do **not** trigger a floating snackbar/popup.
  - When a message arrives for a **different ticket**, increment the conversation's unread counter, play audio alert via `AudioService`, and update the global bell badge.

### D. API & Data Flow Contracts
All ticket operations must be routed through `AdminChatRepository` (`lib/features/technical_support/data/datasource/admin_chat_repository.dart`):
1. **Fetch Ticket List**:
   ```dart
   final tickets = await adminChatRepository.getAllMessages(
     userId: adminUserId,
     userType: UserType.adminUser, // 6
   );
   ```
2. **Load Messages & Pagination**:
   - Initial load: `getChatMessages(fromUserId: adminId, fromUserType: 6, toUserId: targetId, toUserType: targetType)`.
   - Older messages pagination: `getOlderMessages(..., date: oldestMessageDate)`.
3. **Send Message / Reply**:
   - Post payload via `sendChatMessage` (`ApiLink.sendMessage`).
   - Add optimistic message entry to the UI list immediately, with retry state on network failure.
4. **Mark Ticket Viewed / Read Receipts**:
   - When an admin selects a ticket thread, immediately invoke:
     ```dart
     await adminChatRepository.makeChatViewed(
       fromUser: adminUserId,
       fromUserType: UserType.adminUser,
       toUser: targetUserId,
       toUserType: targetUserType,
       orderId: activeOrderId,
     );
     ```
   - Reset the unread counter in `AdminChatCubit` and decrement global notifications counter.

---

## 5. Verification & Quality Gates

Before finishing any task, the agent must run:
1. `flutter analyze` — verify 0 errors and no critical warnings.
2. `dart format --output=none --set-exit-if-changed .` — check format consistency.
3. `flutter build web --no-tree-shake-icons` — verify Web target compiles cleanly.

