Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1263B3114
	for <lists+ceph-devel@lfdr.de>; Thu, 24 Jun 2021 16:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhFXORH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 24 Jun 2021 10:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhFXORG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 24 Jun 2021 10:17:06 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5001C061574
        for <ceph-devel@vger.kernel.org>; Thu, 24 Jun 2021 07:14:46 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id r16so7944063ljk.9
        for <ceph-devel@vger.kernel.org>; Thu, 24 Jun 2021 07:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to;
        bh=ANhbTggsY3NFhRZExKMwUmb3VzJqye8XLvWVXSvNBkQ=;
        b=fcSW40DFsIATqFHTtfdP2c0mPv3fbwk0s35UzLJKI9hHfvzUNLfYZq7BKLvzwEeKqa
         CFXewDqTc9OJjxBosiOTpiXLmNPXX4UU9zKUuozYbH8RZb4Kld9Mrja4y7t0ti67Vaza
         Xt8XXJrullX249mFzs0dGUvu8CGjTFLYpigvHoO+DI2/xMRyEBffriJR1e9y2xEQ1WDG
         qK19IxmW0VqhReyM+B3yoLazyc0hNj3KXKdDzNcjjTxbbmRigxGGzRJY//QOrqihrsEX
         kL5ukxBGJUduYVilYkODtODijpDDdLkqybaUL//POo5QMbm/rI9YmwQ2bCSBlKe055GW
         vRAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to;
        bh=ANhbTggsY3NFhRZExKMwUmb3VzJqye8XLvWVXSvNBkQ=;
        b=SGe6RJjQpUSsBH5jv5W4HI3ngPLT/PlA9vynRwMB7rRlxjvYZ8an1vn7c4srKmjLJ7
         qRiPVy7Z44g7R2A02H1AFbigQPUSIefOvakmcFpdEDkm0i49HuMB95qOBYqLOB+F9yVH
         p93ZMRRVmU6DzOw5nmYCokP27kTVpMVmr6eGMpN+G/HSqY5+NMdjqUPOjfInCaRSNlj1
         qj8IywufkhnJuKUnz7C0t7EbHpGXE/BV+uquOOOjjQg6yt6YsFIoK2ThwrWuRdmEhYDJ
         CtZhXHsq2NJfMyRz/qaRhNNeT+Va3Mt4RTC6jif4RZhe3841jbG0+7JdEW2zBZETT2R7
         TX7w==
X-Gm-Message-State: AOAM532DQnykLefihWnXmEZGa55+Nd/3mP+Avu8/Abe2ncJcspeA0AHC
        psOh6f8h3o1BPHVO2XtaH1IDUwcqCiCLD+tmcjM=
X-Google-Smtp-Source: ABdhPJyrVuyFZWmyoM//E0mvqmq84mHHVhnf4vs1hqy3o+Z4MZaxYa0BQtilbLmDDlOfdRezQLMFnKtCq3kAaTpPix8=
X-Received: by 2002:a2e:6e0b:: with SMTP id j11mr4101497ljc.464.1624544085135;
 Thu, 24 Jun 2021 07:14:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:651c:1a1:0:0:0:0 with HTTP; Thu, 24 Jun 2021 07:14:44
 -0700 (PDT)
Reply-To: tutywoolgar021@gmail.com
In-Reply-To: <CACGGhyQDhNjM7pPW0wTzyn7LBiGmaBAqeP5L66y=E2TL4U9+PQ@mail.gmail.com>
References: <CACGGhyQDhNjM7pPW0wTzyn7LBiGmaBAqeP5L66y=E2TL4U9+PQ@mail.gmail.com>
From:   tuty woolgar <assihbernard6@gmail.com>
Date:   Thu, 24 Jun 2021 14:14:44 +0000
Message-ID: <CACGGhyTk8d81tBDLh-LOvM3QPEt9+bhHuzuN7rsNzCyJpRO_bg@mail.gmail.com>
Subject: greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

My greetings to you my friend i hope you are fine and good please respond
back to me thanks,
