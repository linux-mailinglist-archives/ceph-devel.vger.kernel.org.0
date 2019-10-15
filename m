Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52D00D80E8
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Oct 2019 22:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732979AbfJOUYC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Oct 2019 16:24:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55332 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729459AbfJOUYB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Oct 2019 16:24:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571171040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EA/Scvo3deg5c52OW/t0zkTBKN3YO6gOmx+xGhb0qV8=;
        b=Y2Cps305am1gJXwfeD1w/TJlpex7L/QKUIHTCJNflJFfaqo5tqiGKt3eC23ApUY+KITTcn
        x3xcSXELh/W52fZK+CsaXeizGWyNR/KXeHrN40lrQv8fcEbqPdpUSt3b4qNrTEQkC6gJeN
        aqVUsA0/9O+eI9h7g7YYb9rQcr5z6z8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-ojsA7uCMPYKu5UqB4WDgjA-1; Tue, 15 Oct 2019 16:23:56 -0400
Received: by mail-wm1-f72.google.com with SMTP id z205so173930wmb.7
        for <ceph-devel@vger.kernel.org>; Tue, 15 Oct 2019 13:23:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EA/Scvo3deg5c52OW/t0zkTBKN3YO6gOmx+xGhb0qV8=;
        b=NKfV1lLQ1fpdhVXtWdXMIwQhbCFl4U4orSuzF4XmPW1VQSuXGOP0pMoPzSWj40LjLZ
         OJBTa4XDCMSbsWjw/X80gg5yVzFNr7tdKOF0nRWoEtaaFtmeaF8m/Or583V5BjS6HTaZ
         j4Tp+r14g74uy3CGfOj+ZibM2BHmQiluWuiScuFiMJd3awmsMJ4FGg4odBHAdgMVeSYP
         xWyIPZUFDd4Y6oWk30arxznm60NEIWiymxiAbDjcxMvE9/41bqsbvHMNUpPuelSAwsPZ
         ivH/lSmvPzDMqc7s5zcoV8yp7u7a6ubjWroyB14iE4o9W+Pj4IcehO1GiaUmW9qdEGGW
         sb2A==
X-Gm-Message-State: APjAAAWJ+JJ6TGIiq3KVOltgDtMPUi7SqDEb5kKsQc96MsaKiRnL8DAe
        ZqU5d79EQsD8PlgwLYOeC6/eKi8rTbTkjFmY54RrnY7GPEFwi7uIKy4hhdKkZLcjMUqqdoTcZwW
        bmQt1XX1Vi7d7jXTBKcF5Kqa4GIWDXUz5rvLdIQ==
X-Received: by 2002:a1c:7dce:: with SMTP id y197mr265498wmc.171.1571171035003;
        Tue, 15 Oct 2019 13:23:55 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw6dPbY3o+xhnt/N4OSvEHhKVeVD2O61/adZLW5o8iaRjYULAs7MaDP/V/hEmHawBJhMyivm+o31H706DD0jjA=
X-Received: by 2002:a1c:7dce:: with SMTP id y197mr265488wmc.171.1571171034694;
 Tue, 15 Oct 2019 13:23:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAMrPN_JjckOAnQC_=C+YJ1+QTMRbUkGSu24Pyuo1EC=rfXGuRQ@mail.gmail.com>
 <CALZt5jz3F45NJZpPwAzcegtVcf6556z07MCTJx2Q0e4q8Jb5wg@mail.gmail.com>
In-Reply-To: <CALZt5jz3F45NJZpPwAzcegtVcf6556z07MCTJx2Q0e4q8Jb5wg@mail.gmail.com>
From:   Sam Just <sjust@redhat.com>
Date:   Tue, 15 Oct 2019 13:23:43 -0700
Message-ID: <CAFwUJS3SQGF=Ni-Ws-e9vaM5a0xoh=O5_t3KPa5QKR2rm7UeOw@mail.gmail.com>
Subject: Re: local mode -- a new tier mode
To:     Ning Yao <zay11022@gmail.com>
Cc:     "Honggang(Joseph) Yang" <eagle.rtlinux@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
X-MC-Unique: ojsA7uCMPYKu5UqB4WDgjA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is quite interesting.  I'll have a closer look this week and get
back to you with questions!
-Sam

On Tue, Oct 15, 2019 at 5:15 AM Ning Yao <zay11022@gmail.com> wrote:
>
> Honggang(Joseph) Yang <eagle.rtlinux@gmail.com> =E4=BA=8E2019=E5=B9=B410=
=E6=9C=8812=E6=97=A5=E5=91=A8=E5=85=AD =E4=B8=8A=E5=8D=8812:04=E5=86=99=E9=
=81=93=EF=BC=9A
>>
>> Hi,
>>
>> We implemented a new cache tier mode - local mode. In this mode, an
>> osd is configured to manage two data devices, one is fast device, one
>> is slow device. Hot objects are promoted from slow device to fast
>> device, and demoted from fast device to slow device when they become
>> cold.
>>
>>
>
> I'm quite interesting about this and seems quite promising. But it seems =
objects level tier seems still not efficient enough in the small write scen=
ario (4k ~ 8k based on your fio test result), right?
> Now, in bluestore, it is possbile to implement a fine-grain local tier. i=
t seems bluestore_pextent_t may be allocated from different devices and str=
ategies like extent level hitset to evaluate whether some extents need to d=
emote to slow devices. A promotion or demotion may submit a read with write=
 operations in a transactions, and finished with a onode or blobs flushed i=
nto rocksdb.
>
>> The introduction of tier local mode in detail is
>> https://tracker.ceph.com/issues/42286
>>
>> tier local mode: https://github.com/yanghonggang/ceph/commits/wip-tier-n=
ew
>>
>> This work is based on ceph v12.2.5. I'm glad to port it to master
>> branch if needed.
>>
>> Any advice and suggestions will be greatly appreciated.
>>
>> thx,
>>
>> Yang Honggang
>> _______________________________________________
>> Dev mailing list -- dev@ceph.io
>> To unsubscribe send an email to dev-leave@ceph.io
>
> _______________________________________________
> Dev mailing list -- dev@ceph.io
> To unsubscribe send an email to dev-leave@ceph.io

