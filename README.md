# FridgeChef Project 

### Project Description

#### This project is an iOS application that searches for cookable dishes and recommends recipes based on the ingredients a user has added to their refrigerator.

---
### Develop Environment
![Static Badge](https://img.shields.io/badge/-Xcode-%23147EFB?style=for-the-badge&logo=xcode&logoColor=white)
![Static Badge](https://img.shields.io/badge/-Supabase-black?style=for-the-badge&logo=supabase&logoColor=%233FCF8E)
![Static Badge](https://img.shields.io/badge/-Swift-%23F05138?style=for-the-badge&logo=swift&logoColor=white)
![Static Badge](https://img.shields.io/badge/-FastAPI-%23009688?style=for-the-badge&logo=fastapi&logoColor=white)
![Static Badge](https://img.shields.io/badge/-Python-%233776AB?style=for-the-badge&logo=python&logoColor=white)
<br>
### Tools & Agent
![Static Badge](https://img.shields.io/badge/-Claude-%23D97757?style=for-the-badge&logo=claude&logoColor=white)
[![Static Badge](https://img.shields.io/badge/-Notion-black?style=for-the-badge&logo=notion&logoColor=white)](https://app.notion.com/p/FridgeChef-40f91bbc9bb0802b8631dba8763973c4?source=copy_link)

---
### Directory Structure
```
FridgeChef(Root)
├───FridgeChef (실제 코드 파일)
│   ├───FridgeChefApp.swift (앱 시작점 == main)
│   └───ContentView.swift (첫 화면 UI)
├───FridgeChef.xcodeproj (프로젝트 설정 파일)
├───FridgeChefTests (단위 테스트)  
├───FridgeChefUITests (UI 테스트)
├───FridgeChef_ERD.png (ERD 다이어그램)
├───FridgeChef_System_architecture.png (시스템 구성도)
└───README.md
```
---
### System Architecture
<img src="FridgeChef_System_Architecture.png" width="1000" height="600px" title="System Architecture"/>

---
### Entity Relationship Diagram
<img src="FridgeChef_ERD.png" width="1000" height="600px" title="ERD"/>

---
### Database RLS Policy
| Table | Policy Name | Command | Target | USING | WITH CHECK |
|:---:|:---:|:---:|:---:|:---:|:---:|
|profiles|Select own's profiles|SELECT|Authenticated|select auth.uid() = id|X|
|profiles|Update own's profiles|UPDATE|Authenticated|select auth.uid() = id|select auth.uid() = id|
|ingredients_user|Select own's ingredients|SELECT|Authenticated|select auth.uid() = id|X|
|ingredients_user|Insert own's ingredients|INSERT|Authenticated|X|select auth.uid() = id|
|ingredients_user|Update own's ingredients|UPDATE|Authenticated|select auth.uid() = id|select auth.uid() = id|
|ingredients_user|Delete own's ingredients|DELETE|Authenticated|select auth.uid() = id|X|
|ingredients_master|Select for anyone|SELECT|Anon, Authenticated|true|X|
|ingredients_aliases|Select for anyone|SELECT|Anon, Authenticated|true|X|
|recipe|Select for anyone|SELECT|Anon, Authenticated|true|X|
|recipe_ingredients|Select for anyone|SELECT|Anon, Authenticated|true|X|
recipe_steps|Select for anyone|SELECT|Anon, Authenticated|true|X|
recipe_videos|Select for anyone|SELECT|Anon, Authenticated|true|X|
