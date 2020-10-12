Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A9B28BB05
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Oct 2020 16:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388334AbgJLOoI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Oct 2020 10:44:08 -0400
Received: from sonic301-2.consmr.mail.bf2.yahoo.com ([74.6.129.41]:46003 "EHLO
        sonic301-2.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728269AbgJLOoI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 10:44:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602513847; bh=68B2XLNQFcI1rvBSV0kYRIwdWvrTJ1HrtMu9qHT31RA=; h=Date:From:Reply-To:Subject:References:From:Subject; b=qjUCgDfB8PS1FrOfWhLwgmI01gJLAhocQz2C0BuLc5Vio/YR32xmhrczfcgE9aI1kmcLezBi9+8Qvgjp7oZOJzJ2amieJTDiIHCvdUBPyEVXCM8pOnjLfCBz43sVWNHJLHxLllWDV8cOkKh/r8xnQp7247mm5DROwOdqq2KrWJM4Bx4VgqYpfq0IDsLqO+w8JsFBjZaGd7bvu8wbrWsPr+xNHXPgweIuG69T0ATkLHtqlchdCQNS3mxbbA4IXpzAZJxcCGUhGQ4XtneeyQB5EIe75ukx7sEQ86UKHUnXF13lWdcUTZsY8K7lEZBkX/JALH+f1cN+w/j7EerlzUFACA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602513847; bh=Zy7Z0dvhWgHUuPXb3mbqGBF9VWwuRcSjYYNv+wPdZWm=; h=Date:From:Subject; b=Uv6H4D6557QHI4Bx+Ct4zu7Nd6Hzvwr0SI7WJCJrg/44EuTsTaiL6n16aSv5S49q2wA2r06xJhV8PWNLFPTKy3heSZZ1nhz9fwuIVepSNHFjAVXtvwt8FAamMyFY9QfX3IMqdka5ofOe0GqNiOkYUruVoNxbq0867z0hX6riE0+N6/jr1zZo1xnwow7AdxvylY6MNvJ3NKZWliFaH2p/lm1/n79orq5H47X3EWgzMZzrg/xcJj4CGYcfsp0sAjIhSoEMrnrphVDoEDHOBkhLpJG9qjQKpvGkkRNam6HVrTD2afJArxR9NHNZzRDU04nT25bjFDQXD3ov2uhFXzth6Q==
X-YMail-OSG: uHohiqsVM1li1Ca4PHrltgkNd7dJxuqSt3eolWsFeiAmppgOpvm4E0GFF__AnQe
 4uDfwrcFT2_GwmBW8HceZWVL5aIszjfF7epNpoh.RERHzKCJOqt.6nrXECYtwDRPNwkszP6vUz0g
 4j6jKTyvwblQqhHsOcEg0tadkFTdZoi_Ahh2t89BNDWMKzUd6FiiM8OWcmapzZDI01WZCf7UBrr_
 pwX9PfNtypApS3ERatANmx__74p05DrrX1sQIru9KhYtdCTxTJJoZPG0kpa7oVMrw_awul2YVGA.
 waXnKrEnRVBiWpIdyIHUnH7FKLIsuCgxo8HN.bOg07AGWFXR37zOfkdN5fa9y8qAGaCxnbOQwUTR
 Z8tskSgZmr0lByHJXF8xxJhPlh_rdEBscPn99mjjJOC8UPbNpM.bBc08Eg3JTafmcXC5jzHLxyha
 ItMXiKCWSszb6W8yYrQf4kWdMyTAi3Q.YRiCVuHQrbrr.xrHdco.dtcgbfd9Bm.SHQlGJbDZlHfx
 7Zm4vGw7eJ4uKGmlPy2NaMLx3XmgAk5KMDtZzaRdPltGHE4RWAW40MASz8tmaK7IC9WnJBLHHz9X
 K8Sx1.Fd6D8LpBWDuLu2tSozbPWQq4v1PX8umHPyejupUKI3Dkg_zwD5fcm3MwahDRCsSiZJHzxH
 VoH37WwWNqwobjVJ6kewC1LXTu9C9b7ICZpA5kBt.INBeqB6slVpN47UJkHqJHnSgY6DfLbQ5UEe
 dqQu9vz1LOucI6pYbPzNv6UOBRwGoau0y_wwU0DT5aNsTeUBVQuq4iFCZZDf5LHXNOGBQmav3CAt
 kPhcK8NQw84bsiqLdd9UwbNvACXbAnQOPyNSBiBXC.657jwSX1GFw0z82wHflaIwtR.Tvg4HxoW7
 GcWCPx.G1NUr0seCL.eUpeWpII_xurGMde_AnHiyWoyHrJ1rybQoO1P6iYNVXxcS3mMjXJgYfrCl
 WfB9Nr.qLXMW8sCu3tL2hZAa6Vu5Czu9LAJhxvVb930Pw3h5dnXNBRR7kibKxr8PzdFk0sHpsh7.
 TkKQzyUbr1dW2GARBv.qlILRq2R8FKq48J09Ehty.F9kQyrSXUV4hsOwa728WrcXTyUx_mwAyzXe
 vXuhflo1q36HK7IiG2759yDvsGqMx5pG6qEgCP8kzPwPbhmAFgQh8t8f39PxfzqS9Po8mwTNQBUS
 ZXI1dXKdP7AD4X5p5MakDWZKY7LJOkere2QM8EBzX70OdlX9_t0oNEn0r35z1Z1b0vUJYzmlM2EG
 RwBqHFYg58tkOlmnhAtp_PeLbhswjUAWnxKaRRVGRGS4aHbY6868VWSi2oU_OLCw9KWCh.3XDGuR
 QEJb85d9sn5a33SWpy2znmm35VrrWnADAEvxhQuaUzmwCiHyYBWUP11DunbvFG.UmCLgQ8FHQPzY
 gau5bi8RrWDqDCpD6yo1bJhCGgj_ZUW8qXSFFR6JcDy0l_ezu
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.bf2.yahoo.com with HTTP; Mon, 12 Oct 2020 14:44:07 +0000
Date:   Mon, 12 Oct 2020 14:44:04 +0000 (UTC)
From:   mrsflora.the1983@gmail.com
Reply-To: manueke.flora@gmail.com
Message-ID: <1787509092.423290.1602513844313@mail.yahoo.com>
Subject: Greetings.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1787509092.423290.1602513844313.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16795 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Greetings.
 
Please let this not sound strange to you because I am not asking you for money and no money is needed from you in helping me. I got your email address on country guest books and I pray it is still valid. I want to solicit your assistance in the discharge of my will, I am Mrs. Theresia Manueke, a native of Indonesia, and am age 52 years suffering from endometrial cancer. Please, I want you to help me create a charitable project in your community with the money that I inherited from my deceased husband who was poisoned by a friend in 2016.  I was brought up from a motherless baby's home and was married to my late husband for twenty-nine years without a child.

My friends have plundered so much of my wealth since my illness and I cannot live with the agony of entrusting this huge responsibility to any of them anymore, so I sold all my inherited belongings and deposited all with my bank. All I need is an honest person who will use at least %60 of the funds as I instructed, then the rest will go to you for helping me accomplish this mission because donating this money to charity is the only legacy I can leave behind after my death. No money is required from you to carry on with this project because it is my heart desire to make a generous gift to you to work for a charity in your community, I don't mind your religion, but I don't know if I can trust you because there are greedy and fraudulent people over the world especially on the internet. I will give you more details as soon as I hear from you.

Looking forward to your urgent response.
Regards.
Mrs Theresia
