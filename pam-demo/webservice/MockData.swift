//
//  MockData.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 4/3/2564 BE.
//

import Foundation

let userTable = [
    [
        "email":"a@a.com",
        "name": "T-1000",
        "profile_image": "profile1",
        "cust_id":"a"
    ],
    [
        "email":"b@b.com",
        "name": "Sarah Connor",
        "profile_image": "profile2",
        "cust_id":"b"
    ],
    [
        "email":"c@c.com",
        "name": "John Connor",
        "profile_image": "profile3",
        "cust_id":"c"
    ]
]



var products = [
    ProductModel(
        image: "https://boodabest-static.pams.ai/ecom/public/1ogZgGkGc0OaRiZcP1YOhKOW8ge.jpg",
        title: "เสื้อ HOODIE THE UNCANNY COUNTER FREESIZE สีดำ",
        price: 750,
        description: """
เสื้อ hoodie jacket จากซีรี่ส์ The Uncanny Counter
เสื้อแจ็กเก็ตแขนยาวพร้อมหมวกฮู้ด เนื้อผ้า cotton 100%
มีสองสี คือ สีแดง และ สีดำ สกรีนคาดแถบขาวสองเส้น
ที่แขนสองข้าง หมวดฮู้ดแซกรังดุม ร้อยเชือกถักก้างปลา
สีเดียวกับสีเสื้อ
ขนาด free size หน้าอก 46.5 นิ้ว ยาว 27 นิ้ว
""",
        productID: "p1", isFavorite: false, category: "fashion"),
    ProductModel(
        image: "https://boodabest-static.pams.ai/ecom/public/1ogiPdbUybnM1PA5bzr8h1DGFrO.jpg",
        title: "เสื้อ HOODIE THE UNCANNY COUNTER FREESIZE สีแดง",
        price: 750,
        description: """
เสื้อ hoodie jacket จากซีรี่ส์ The Uncanny Counter
เสื้อแจ็กเก็ตแขนยาวพร้อมหมวกฮู้ด เนื้อผ้า cotton 100%
มีสองสี คือ สีแดง และ สีดำ สกรีนคาดแถบขาวสองเส้น
ที่แขนสองข้าง หมวดฮู้ดแซกรังดุม ร้อยเชือกถักก้างปลา
สีเดียวกับสีเสื้อ

ขนาด free size หน้าอก 46.5 นิ้ว ยาว 27 นิ้ว
""",productID: "p2", isFavorite: false, category: "fashion"),
    ProductModel(
        image: "https://boodabest-static.pams.ai/ecom/public/1mhgTTRebpEZ0Ot4RuAxK1QpKxy.jpg",
        title: "เสื้อยืด DUKE ลาย My WFH be like",
        price: 250,
        description: """
        เสื้อยืด DUKE ลาย My WFH be like ส่งฟรี
        ดุ๊ก เป็นสุนัขพันธ์ บลูเทอเรีย

        เนื้อผ้า พรีเมียมคอตตอน คุณภาพสูง เหมาะกับอากาศประเทศไทย
        ซับเหงื่อ แห้งเร็ว ไม่ทิ้งกลิ่น ซักไม่เสียทรง

        Size S : อก 36", ยาว 26", ไหล่กว้าง 15"
        Size M : อก 38", ยาว 27", ไหล่กว้าง 16"
        Size L : อก 40", ยาว 28", ไหล่กว้าง 17"
        Size XL : อก 42", ยาว 28.5", ไหล่กว้าง 18"
        Size XXL : อก 44", ยาว 29", ไหล่กว้าง 19"
        Size XXXL : อก 46", ยาว 30", ไหล่กว้าง 20"
        Size XXXXL : อก 50", ยาว 31", ไหล่กว้าง 21"
        """,productID: "p3", isFavorite: false, category: "fashion"),
    ProductModel(
        image: "https://boodabest-static.pams.ai/ecom/public/1m9BQpFkzD0FBq9PSqsBGEgGvVn.jpg",
        title: "เมื่อมนุษย์ และหุ่นยนต์ต้องทำงานร่วมกัน จะทำการตลาดอย่างไรในโลกอนาคต",
        price: 250,
        description: """
        หนังสือ Automation Marketing
        ผู้แต่ง ไชยพงศ์ ลาภเลี้ยงตระกูล
        เนื้อหาภาษาไทย 224 หน้า

        หนังสือ "การตลาดอัตโนมัติ Automation Marketing" เล่มนี้ ผลงานเขียนของไชยพงศ์ ลาภเลี้ยงตระกูล ผู้บริหารและนักการตลาดสายธุรกิจดิจิทัล นำเสนอเนื้อหาด้านการตลาดในยุคสมัยใหม่ เหมาะสำหรับนักการตลาด เจ้าของธุรกิจ เจ้าของแบรนด์ รวมถึงคุณผู้อ่านที่ต้องการความรู้ด้านการตลาดอัตโนมัติ เพื่อไปใช้ในการทำงาน หรือการปรับตัวในโลกยุคใหม่ เนื้อหานำเสนอในแง่มุมความรู้ที่น่าสนใจ สามารถนำไปใช้ประโยชน์และต่อยอดในโลกธุรกิจดิจิทัลได้ต่อไป

        "ถ้าคุณพร้อมจะกระโดดเข้าสู่โลกดิจิทัลใบนี้แล้ว กับความรู้และทักษะใหม่ๆที่เพิ่มขึ้น อย่ารอช้า..เปิดอ่านไปด้วยกันเลย"
        """,productID: "p4", isFavorite: false, category: "book"),
    ProductModel(
        image: "https://pam-boodabest.s3-ap-southeast-1.amazonaws.com/ecom/public/1d4Vjlsg4qMVhmeX4zd0du3dpsH.png",
        title: "ผลิตภัณฑ์โฟมทำความสะอาดมือออร์แกนิค ชนิดไม่ต้องล้างน้ำออก",
        price: 240,
        description: """
        คุณสมบัติ

        - ผลิตจากสารสกัดจากธรรมชาติ Natural ingredients
        - ลดการสะสมของเชื้อโรค เชื้อรา และแบคทีเรียต่างๆ
        - ช่วยบำรุงมือให้นุ่ม ชุ่มชื้น
        - ปราศจากแอลกอฮอล์และสารเคมีอันตรายต่างๆ
        """,productID: "p5", isFavorite: false, category: "chemical"),
    ProductModel(
        image: "https://pam-boodabest.s3-ap-southeast-1.amazonaws.com/ecom/public/1bDK2pKFhFtEgmgyTBqkdC6NR3B.jpg",
        title: "แป้งข้าวระงับกลิ่นฮาบุ",
        price: 89,
        description: """
        แป้งข้าวระงับกลิ่นฮาบุ
        """,productID: "p6", isFavorite: false, category: "cosmetic"),
    ProductModel(
        image: "https://pam-boodabest.s3-ap-southeast-1.amazonaws.com/ecom/public/1bDJrSq2aOWNBuiQvwzihUyOMQH.jpg",
        title: "สเปรย์ระงับกลิ่นฮาบุ",
        price: 89,
        description: "สเปรย์ระงับกลิ่นฮาบุ",productID: "p10", isFavorite: false, category: "cosmetic"),
    ProductModel(
        image: "https://boodabest-static.pams.ai/ecom/public/1neLpamCY8JzVic4xjqNuTkU6UQ.jpg",
        title: "TRANEXAMIC ACID",
        price: 350,
        description: """
        TRANEXAMIC ACID กระตุ้นการสร้างคอลลาเจนและอิลาสตินในชั้นผิว ช่วยลดเลือนริ้วรอยได้อย่างดีเยี่ยม ฟื้นฟูผิวเสื่อมสภาพ ให้แลดูอ่อนเยาว์อีกครั้ง
        """,productID: "p7", isFavorite: false, category: "cosmetic"),
    ProductModel(
        image: "https://boodabest-static.pams.ai/ecom/public/1neLvZ4cVkZX1122vnUi21wqIzj.jpg",
        title: "ALOE PEPTIDE-1",
        price: 550,
        description: """
        ALOE PEPTIDE-1 ชะลอการสะสมของเชื้อแบคทีเรีย ซึมซาบล้ำลึก สู่ชั้นผิวทันที ไม่เหนียวเหนอะหนะ สามารถกักเก็บความชุ่มชื้น ลดความหมองคล้ำ ให้ผิวอ่อนเยาว์อยู่เสมอ
        """,productID: "p8", isFavorite: false, category: "cosmetic"),
    ProductModel(
        image: "https://pam-boodabest.s3-ap-southeast-1.amazonaws.com/ecom/public/1dLOVYOmR2GjHWuZHh4zTmChtN2.png",
        title: "ยาสีฟันวิเศษนิยมแบบหลอด",
        price: 119,
        description: """
        ยาสีฟันสมุนไพร สกัดจากสมุนไพรหลากชนิด เช่น
        กานพลู Clove Oil ช่วยฆ่าเชื้อ แก้ปวดฟัน รักษาเหงือก ทำให้ฟันแข็งแรงไม่โยกคลอน ระงับกลิ่นปาก
        เกลือบริสุทธิ์ Purified Salt ลดการเกาะของหินปูน ทำให้ฟันขาว สะอาด แข็งแรง ลดปัญหาเรื่องกลิ่นปาก อีกทั้งเกลือยังมีคุณสมบัติในการรักษาแผล ลดการอักเสบในช่องปาก
        ชะเอมสกัด Glyceriza Extract ให้กลิ่นหอม ปากชุ่มชื้น
        พิมเสน Borneol Camphore ช่วยรักษาฟัน เมื่อฟันแข็งแรงอาการเสียวฟันจะค่อยๆ ลดน้อยลง จนไม่กลับไปเสียวฟันอีก
        อบเชย Cinnamol Oil ช่วยฆ่าเชื้อแบคทีเรียในช่องปาก ลดปัญหาเรื่องกลิ่นปาก
        สเปียร์มินต์ Spearmint ช่วยให้ลมหายใจหอมสดชื่น
        เกล็ดสะระแหน่ Menthol Crystal ระงับกลิ่นปาก
        วิธีใช้: บีบยาสีฟันเพียง 1 ใน 3 ของขนาดแปรงสีฟัน แปรงให้ทั่วถึงทุกซี่ทุกด้าน นาน 2-3 นาที ควรแปรงฟันอย่างน้อยวันละ 2 ครั้ง
        """,productID: "p9", isFavorite: false, category: "home")
    
]
