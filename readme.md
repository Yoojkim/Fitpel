## 소상공인을 위한 근태관리 시스템 핏플 📋 

![image](https://github.com/user-attachments/assets/ca2a0cb7-a4a8-46e9-98ac-42915512baac)


<div align="center">
<a href="https://apps.apple.com/kr/app/%ED%95%8F%ED%94%8C-%EC%86%8C%EC%83%81%EA%B3%B5%EC%9D%B8-%EB%A7%9E%EC%B6%A4%ED%98%95-%EA%B7%BC%ED%83%9C-%EA%B4%80%EB%A6%AC-%EC%86%94%EB%A3%A8%EC%85%98/id6708238033" target="_blank">
  <img src="https://upload.wikimedia.org/wikipedia/commons/6/67/App_Store_%28iOS%29.svg" width="60"/>
</a>
<div></div>
<a href="https://play.google.com/store/apps/details?id=com.fitple.app&pcampaignid=web_share" target="_blank">
  <img src="https://upload.wikimedia.org/wikipedia/commons/7/78/Google_Play_Store_badge_EN.svg" width="100"/>
</a>
</div>

### 핏플
소상공인을 위한 근태관리 시스템으로, 사업장과 직원을 등록하여 효과적인 근태관리를 수행할 수 있습니다. 

<div align="center">
  <img src="image/main.gif" width="200"/>
</div>

### 🚀 기술 스택
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-75C46B?style=for-the-badge&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAFo9M/3AAA...)  
![Freezed](https://img.shields.io/badge/Freezed-6C757D?style=for-the-badge&logo=freebsd&logoColor=white)
![OAuth](https://img.shields.io/badge/OAuth-512BD4?style=for-the-badge&logo=auth0&logoColor=white)
![Jira](https://img.shields.io/badge/Jira-0052CC?style=for-the-badge&logo=jira&logoColor=white)


### 근태관리 
- 커스텀 캘린더를 이용하여 근태기록 확인 시작일~종료일까지의 근태 기록을 확인할 수 있습니다.
- 근무 기록에서 수행한 시간이 지나면, 사용자가 근무 완료를 지정하고 해당 데이터가 근무 완료 시에, 근무 기록으로 기록됩니다. 
- 캘린더를 통해 지정한 날짜의 모든 근태기록을 간략하게 리스트로 나타낼 수 있습니다. 
- 사용자 친화적 UX를 위해 근무 기록 추가 화면에서도 날짜를 변경할 수 있습니다.
- 근무 기록을 수정, 삭제 할 수 있습니다. 
- 상대 크기를 사용하여 화면 크기에 반응하는 반응형 UI로 구현하였습니다.

---

#### 커스텀 캘린더 구현
사용자가 근무 기록을 보다 더 원활하게 이용하기 위해 커스텀 캘린더를 구현하였습니다. 시작-종료 날짜를 사용자가 확실히 확인하기 위하여, 색 변경과 시작-종료 까지의 이어짐 처리와 같은 UI 요소들을 구현하였습니다. 

| ![alt text](image/IMG_6178.PNG) | ![alt text](image/IMG_6183.PNG) |
|----------------|----------------|

#### 

#### 근무 기록 기능 구현
| ![alt text](image/IMG_6177.PNG) | ![alt text](image/IMG_6180.PNG) |
|----------------|----------------|
| ![alt text](image/IMG_6181.PNG) | ![alt text](image/IMG_6182.PNG) |

