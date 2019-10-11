Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC23D38C9
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Oct 2019 07:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfJKFpH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Oct 2019 01:45:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34176 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbfJKFpH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 11 Oct 2019 01:45:07 -0400
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com [209.85.208.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9A69983F3D
        for <ceph-devel@vger.kernel.org>; Fri, 11 Oct 2019 05:45:06 +0000 (UTC)
Received: by mail-lj1-f199.google.com with SMTP id w26so1509321ljh.9
        for <ceph-devel@vger.kernel.org>; Thu, 10 Oct 2019 22:45:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qeuTo8X/oVOZm8y6iZFzztGDEPo7S4JgpKNk8sZGfYI=;
        b=k/W12MR2cADfcaDtylbZq/veqieh+T+zDqp4xUucrBdKlmbJ6JkLjjm0UGM0I9aamI
         hasu9ww9Y3pSxr5vwxkMvAdw1P1JwZmYSIhRVZrHfyTT0DbT00L4pMUAHANknegrui8d
         m5bRriPNOhZZHmfw25xnapyrekiNml8LmEVZZEmwDdgBEec9LUZ8LMWU91KcZQD2nU15
         ESI8EzpA+2974iXbn0MSsvEmnN+cjJ4SMOfL6HoJOy7oAOsIiAuAp/XerJ/BupGl2Uvd
         nVnub70VtdAzHe/ex9M+JMSLpNCoNMaFjjNMGLjnggQkh2uwez9+QUcuoNg8Wr6vMecI
         xWqw==
X-Gm-Message-State: APjAAAWQmks9BkD024Hcr/2ZUxesmuiS2kMCIUPC+qwwjoxm8RjxtSu5
        GKmU8oZTY5t4/xaJwKIvc2QNfAdy/de50JiD5Td13ane1jmygiOR0Oywfsy8BACmqcoHPK+GGuQ
        +ePLlFO8FtINjLJ343nW750tIIUa5LU/heB/RPQ==
X-Received: by 2002:a2e:8ec2:: with SMTP id e2mr7962425ljl.151.1570772705060;
        Thu, 10 Oct 2019 22:45:05 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwZS9wcGIB16tiMCTc64WIG57dAKD6hIjVK+ZMPnGpKzoV1Kzg/bO9gsla++Wmsv3ZNE9LJZLFWE4grG9q2xg0=
X-Received: by 2002:a2e:8ec2:: with SMTP id e2mr7962416ljl.151.1570772704869;
 Thu, 10 Oct 2019 22:45:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAF-wwdHoUAEqJ7_ep+uDtnqsVDfaNdKQ2XM8T_+a=70mFd=80Q@mail.gmail.com>
 <CACBud-DDEsbR16BEwHgsvK_z=paXggjgAqGCUT_yryiNN8Cb9A@mail.gmail.com>
In-Reply-To: <CACBud-DDEsbR16BEwHgsvK_z=paXggjgAqGCUT_yryiNN8Cb9A@mail.gmail.com>
From:   Brad Hubbard <bhubbard@redhat.com>
Date:   Fri, 11 Oct 2019 15:44:52 +1000
Message-ID: <CAF-wwdEEf=MCPTOthKeT8-raUFtN6u1SBi3VrNDi2kmFanSrbA@mail.gmail.com>
Subject: Re: Static Analysis
To:     Yuval Lifshitz <ylifshit@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Oct 10, 2019 at 3:41 PM Yuval Lifshitz <ylifshit@redhat.com> wrote:
>
> This is awesome!

First thing to note is these scans each take a long time to run.

> How difficult would it be to add these as cmake targets?

With Coverity, currently impossible since the only version I can find
that works is not publicly available.

As for the others I use the following script to run them so it
wouldn't be that hard I guess. There's some changes in there at the
moment to try and get them to only scan 'ceph code' (not submodule
code) but that seems to be confusing scan-build as it currently
produces zero results. I have some work to do there and there seems to
be a lot of maintenance work around these scans. I'm not sure how much
bang for our buck we would get by adding any of them as cmake targets.

>
> On Thu, Oct 10, 2019 at 8:18 AM Brad Hubbard <bhubbard@redhat.com> wrote:
>>
>> Latest static analyser results are up on  http://people.redhat.com/bhubbard/
>>
>> Weekly Fedora Copr builds are at
>> https://copr.fedorainfracloud.org/coprs/badone/ceph-weeklies/
>>
>>
>> --
>> Cheers,
>> Brad
>> _______________________________________________
>> Dev mailing list -- dev@ceph.io
>> To unsubscribe send an email to dev-leave@ceph.io



-- 
Cheers,
Brad
