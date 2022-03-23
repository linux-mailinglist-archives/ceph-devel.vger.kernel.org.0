Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837984E4CB9
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Mar 2022 07:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbiCWG30 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 23 Mar 2022 02:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiCWG3Y (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 23 Mar 2022 02:29:24 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EDD710EB
        for <ceph-devel@vger.kernel.org>; Tue, 22 Mar 2022 23:27:55 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id y142so881506ybe.11
        for <ceph-devel@vger.kernel.org>; Tue, 22 Mar 2022 23:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to;
        bh=3uXPBCjbKDf6MSQFK1r/Wo1P1Nt4GLx/YIZIqkOYc8E=;
        b=bdbLXn3NzM2FV7hL5VczCwLMtFLlIoUHmkNzvdxYEDsbAvcjLyLUJTEf5VQe3LUZBE
         6C9fY+Qvy+N28sFFXo/3O6aLilk8f6j4LXzjzy0sU2wF4qpvcx7MRC7ny1ubyTDlaX9C
         egbjBUPODS1Icrz/HSQe1FVgkt4ecPmqaI9DAjvedJsQJL+TIMnRIHYu4zwXuTQwWzuo
         SrhUeK+AmMAs7XvfTFBpSFTwZDCF6ha76jNzlKqk0AfbM0hczlDd4CYoNHnaxIXu7sWD
         X/YGVBe9SP1MuncZUXQCv6MRgi67h2zZyL2wnUlkg4/NaOCKcRQGiEOvBRzN/+w9f/5K
         t01g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to;
        bh=3uXPBCjbKDf6MSQFK1r/Wo1P1Nt4GLx/YIZIqkOYc8E=;
        b=rgWRk+OkMCJ9kWRrPwqUTbefGejtYjOEZf5FfuvFOQU3xt5N/+hwbtG6yKmbgh5Rny
         9wN+l2RmIVKikKsMRMvv9E2ZjBY9fnUq4mLDQrJtF7EfxZUmlB2cf6gdpmeuZNSdeY9k
         s2OszKxVqakK5wqpqQMZBuPK13A+VeyT3ujhSTxHyWzn1mvhhTjVi3CJAIBZDfTA6kLp
         hQzDHWeTJtst84ThHg8w2oJSQBUi0T/TSZQBUBk2FEsjBS5/oADm2Gf4oiVZ6kvTXUGQ
         a6Xq/Nn344XIanCH99HJaHDwujx++cDNDm7Cc52rI/hSld3ugTLwuFjbsVY3yqWbFAR4
         IJYw==
X-Gm-Message-State: AOAM531NyhkhN1lHgRpVf3poxkLSUVCJHsUPZx0WgTa9LSSdwVh54vEx
        6/wK65SrMSuzFyvtSCOPX5obI43KkVR5kdVM7ow=
X-Google-Smtp-Source: ABdhPJy0NzYWWSlmsVzNEdqpRgEImKWYAgaailMqJlMtr3qPl6AuL3MsDzBDZb/fwYhfsvTWbArfv0ryKLTMC0NuuQQ=
X-Received: by 2002:a25:53c4:0:b0:628:a0de:b4d6 with SMTP id
 h187-20020a2553c4000000b00628a0deb4d6mr30322362ybb.299.1648016874632; Tue, 22
 Mar 2022 23:27:54 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:a39b:b0:236:42d8:3c9 with HTTP; Tue, 22 Mar 2022
 23:27:53 -0700 (PDT)
Reply-To: michealthompson2019consultant@gmail.com
In-Reply-To: <CAFDkaNUMmvPN6KaApGkJsy33QKNnRNzdt4fja4wEHEkSwASVTA@mail.gmail.com>
References: <CAFDkaNXqk_rp0pVfFPSSr-uFi8Fw5qLZSS2OEfny2pPh8Tyb9w@mail.gmail.com>
 <CAFDkaNX4YEd_mvLESa1YdGRt0q6OT=tC-hvj4-s=NhFvGNsgGg@mail.gmail.com>
 <CAFDkaNUpgqfFHOWLNzi4uZeoc_M=gv-nmS=W+yGb3b3rMPE0mQ@mail.gmail.com>
 <CAFDkaNVEotEW5VTRWxShow+U95Jyuk+YNO=_9eS3xQ5+94hSzQ@mail.gmail.com>
 <CAFDkaNXT8hm=JaW4bibBzwiyy=BC-4mZLnSXo=TB975+s08N5g@mail.gmail.com>
 <CAFDkaNVrtZa26AUXJ=ijv-EvU77P8c7u3WAFZEKVbv=JDOBb_g@mail.gmail.com>
 <CAFDkaNXz3+MdwHfptrVnZECjqX7nq_A8jMNQeQKcBbcGvDbPXw@mail.gmail.com>
 <CAFDkaNV5jDEfht-WGn-+8Pg-oa+8C9B336rUZTPY49-itZBydQ@mail.gmail.com>
 <CAFDkaNVwvQGj7wHGfmtHBMN8PW4DhONnopDdpLv+NpcyvV+8Lw@mail.gmail.com>
 <CAFDkaNUPuTt=d7LhAYQWD_qTAfWtUCpT3So7YijNWLYNCYp7Cg@mail.gmail.com>
 <CAFDkaNV06OYHARa-YAQ3Bg6M2YUx81cuKOAS4geT-wCtZD=i9Q@mail.gmail.com>
 <CAFDkaNUPe-y54h1Ev8-V1hrQDc0u-NkViD8iFjPYCBDqjdC2WA@mail.gmail.com>
 <CAFDkaNV_ZBqAHXwawm4UyHANbAu+ES-WCLh---Q2d=wEFmgiVA@mail.gmail.com>
 <CAFDkaNVEeQducV+skxROxsEguSffrCJMzesVETAzA=1hfKdjdA@mail.gmail.com>
 <CAFDkaNUpQh1t-tDmQ32vLZdtwjOb_hOWX2Zvy6jSNSG5AuP_8g@mail.gmail.com>
 <CAFDkaNWNXJ64yOMgWP96x9KYPsXyOfu_oTm3gTNT9To9hq4ing@mail.gmail.com>
 <CAFDkaNUcwBiR4Rzrp_K=AuoL_wk0nQ6D+ToQna3DtqkK_+DNRA@mail.gmail.com>
 <CAFDkaNX1WvPBje73pjfCM4_mueVsiB90Ye_kJSb_4PFLmCiLAg@mail.gmail.com>
 <CAFDkaNWY_9Sd-gConfz79NCRxUAwn5U6Vqu+EFQgmxr1PxXetQ@mail.gmail.com>
 <CAFDkaNWgBbZOfUgZ94BBEgfcS-crBTr8TGbxSsEvmSvpg-32WQ@mail.gmail.com>
 <CAFDkaNXosoBcnyvzh4-MvjyxgL2g8N0iWtTJM63MGveBDGUcJg@mail.gmail.com>
 <CAFDkaNVQz1Lr4zRCjjVwZMqJ0s6Wq4mPNkdNpqZoyOOnUHu85Q@mail.gmail.com>
 <CAFDkaNU5nqMCiBboo2b_L4HWqMeHURLaW90FxkLO1jpk7fdu9g@mail.gmail.com>
 <CAFDkaNVJ-dAtkS1R-+rLstWSt2vH0QK6v83rvBQyyPs57+CwVQ@mail.gmail.com>
 <CAFDkaNUCME-yGU6MV4hUPJhaJPVTZmGwh976J_UYbKF1tqgfvQ@mail.gmail.com>
 <CAFDkaNWaW5wK_WST8nBE+m0bSu2CCCXwJCrXjJtx2MQUtH2=Jg@mail.gmail.com>
 <CAFDkaNVuiBGk2dOkfYqAw3Qgb3giFFCvjxZ6vAMZz=h5mBWDWQ@mail.gmail.com>
 <CAFDkaNUVb81gAwWTJt9h33bDt+rG7M8SvADzQJ=xiGnStzv0Eg@mail.gmail.com>
 <CAFDkaNXL1E8Ze-Pj-rAEXQ169TCoE4dnONXaaJezma9hxudbfw@mail.gmail.com> <CAFDkaNUMmvPN6KaApGkJsy33QKNnRNzdt4fja4wEHEkSwASVTA@mail.gmail.com>
From:   "Mr. Micheal" <themba2019mthembu@gmail.com>
Date:   Wed, 23 Mar 2022 08:27:53 +0200
Message-ID: <CAFDkaNVy-ea7ZgfRc2bt9r-M8OGtHXY24g5nsHq5TWTpU9HRuQ@mail.gmail.com>
Subject: Financing Your Project.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b42 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5006]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [themba2019mthembu[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

ATTN: Managing Director,
Sir/Ma

My investor will sponsor your project. My name is Mr. Michael Thompson
a financial consultant and agent, I contact you regarding the
interested project owners and investors to our project financing
program. I am the investment consultant & financial officer of a UAE
based investment private business man who is ready to help you with a
loan to your company and personal business projects.

We are ready to fund projects outside the Dubai or Worldwide, in the
form of debt finance, we grant loans to both Corporate and Private
Companies entitles at a low interest rate of 2.5% ROI per year.

The terms and conditions are very interesting. Kindly reply back to me
for more details if you have projects that need financing, get in
touch for negotiation.

Kind Regards,
Mr. Michael Thompson,
Email: michealthompson2019consultant@gmail.com
