Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF398EBBA
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Aug 2019 14:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731439AbfHOMl5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 15 Aug 2019 08:41:57 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:46053 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfHOMl5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 15 Aug 2019 08:41:57 -0400
Received: by mail-ed1-f52.google.com with SMTP id x19so1967393eda.12
        for <ceph-devel@vger.kernel.org>; Thu, 15 Aug 2019 05:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=croit.io; s=gsuite-croitio;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=knfJJVkNJbQdC/pURp0ONbhnq47NdnkWVqW0lOiuBCk=;
        b=gJMIwDiwy8rlH6RGOrrdyJlWMV9gCUOAv3U7Lzmf9gOBSQvm7qpq8Os0JJugvDP9d1
         N14Jsvgv2coTaymXjC1nfJDMgrw/a8mn9DhWm51BJ8lbaRZA8JqeEjpQ13A9U+/jpktL
         9XhruxAqD2OGkF8l1e2CcUaDc30fvM5Gos5scPMoBY7Kv1MMU3EC1RJSYOpvpkBLcQhL
         U+rsI80Q+vExMf4JNlweSCQELUGnAeBNYUW90H3mF7eF8yhOofmbv27hPcehUX/nO9HX
         f8/4DggpVcFQOZhpxW5P5P6TDSg1aRgP/OfIllpBtX4Cdbi4Q7q2EnucE8vXkvjbQ9Bh
         4F4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=knfJJVkNJbQdC/pURp0ONbhnq47NdnkWVqW0lOiuBCk=;
        b=rxLJF1zVnPEcIxDLvIGRLCtA/5dOU0xHeFF1rVVjHJoKDwHJE/WxIJc9xNKCn2vQeG
         UNwvyLzwjeMKPvQCgJglEDW+U9LUtVwCs7JCXULDTPu2Nm3uVRgHuXwYkNlcK3h9C0ZN
         eBhsNes3q1P5s9FioezPeczdHL5vYeWjms7gK7X7L0A4cntL4jv7QorXRdo++LySTd1N
         7N0xqgmAsO3WtwQhgxVMxMszJNxOTElPv/je2xRWVm58A+nmGHxAKeN42WcVPxjuqpTa
         mkVhjXNEDbYrFJvAX7W8VKKS9s6snin36Jffro+3rCypA+88PuDlkyIgcntoJwC+K4NN
         Fg/Q==
X-Gm-Message-State: APjAAAVrWSExx9nwBwlLoMTFbyJAvb7majXlmYrsd09fdI58tkQo/R9o
        cpaa8nbimho/Ger0t9ZGQaTqseU9sTlK6kIZ/d5O1Q==
X-Google-Smtp-Source: APXvYqx0/o7iYkADQ6A/3itdTpdc6KQFGTh/eyCfz22EDRxMdFX8tEYhK4hQjl+euXc/6eHp5Z6Re+1VqG0Ii+9CjNA=
X-Received: by 2002:a50:93a4:: with SMTP id o33mr5179843eda.30.1565872915300;
 Thu, 15 Aug 2019 05:41:55 -0700 (PDT)
MIME-Version: 1.0
References: <B44994A6-D75F-4793-8599-7C3B7C53B3AB@godaddy.com>
In-Reply-To: <B44994A6-D75F-4793-8599-7C3B7C53B3AB@godaddy.com>
From:   Paul Emmerich <paul.emmerich@croit.io>
Date:   Thu, 15 Aug 2019 14:41:44 +0200
Message-ID: <CAD9yTbFrs0Mu3XGnHiYUNob3zkpgPQquSvboUJDBpmwRX-mP4A@mail.gmail.com>
Subject: Re: backfill_toofull seen on cluster where the most full OSD is at 1%
To:     Bryan Stillwell <bstillwell@godaddy.com>
Cc:     "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We've also seen this bug several times since Mimic, it seems to happen
whenever a backfill target goes down. Always resolves itself but is
still annoying.

The original fixmaking this a warning instead of an error
unfortunately doesn't help on Nautilus because we often have clusters
that would be HEALTH_OK without this bug on Nautilus (i.e., some PGs
in remapped+backfill*) but they will show up as HEALTH_WARN with this
fix (and HEALTH_ERR without it).



Paul



On Wed, Aug 14, 2019 at 11:44 PM Bryan Stillwell <bstillwell@godaddy.com> w=
rote:
>
> We've run into this issue on the first two clusters after upgrading them =
to Nautilus (14.2.2).
>
> When marking a single OSD back in to the cluster some PGs will switch to =
the active+remapped+backfill_wait+backfill_toofull state for a while and th=
en it goes away after some of the other PGs finish backfilling.  This is ra=
ther odd because all the data on the cluster could fit on a single drive, b=
ut we have over 100 of them:
>
> # ceph -s
>   cluster:
>     id:     XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
>     health: HEALTH_ERR
>             Degraded data redundancy (low space): 1 pg backfill_toofull
>
>   services:
>     mon: 3 daemons, quorum a1cephmon002,a1cephmon003,a1cephmon004 (age 21=
h)
>     mgr: a1cephmon002(active, since 21h), standbys: a1cephmon003, a1cephm=
on004
>     mds: cephfs:2 {0=3Da1cephmon002=3Dup:active,1=3Da1cephmon003=3Dup:act=
ive} 1 up:standby
>     osd: 143 osds: 142 up, 142 in; 106 remapped pgs
>     rgw: 11 daemons active (radosgw.a1cephrgw008, radosgw.a1cephrgw009, r=
adosgw.a1cephrgw010, radosgw.a1cephrgw011, radosgw.a1tcephrgw002, radosgw.a=
1tcephrgw003, radosgw.a1tcephrgw004, radosgw.a1tcephrgw005, radosgw.a1tceph=
rgw006, radosgw.a1tcephrgw007, radosgw.a1tcephrgw008)
>
>   data:
>     pools:   19 pools, 5264 pgs
>     objects: 1.45M objects, 148 GiB
>     usage:   658 GiB used, 436 TiB / 437 TiB avail
>     pgs:     44484/4351770 objects misplaced (1.022%)
>              5158 active+clean
>              104  active+remapped+backfill_wait
>              1    active+remapped+backfilling
>              1    active+remapped+backfill_wait+backfill_toofull
>
>   io:
>     client:   19 MiB/s rd, 13 MiB/s wr, 431 op/s rd, 509 op/s wr
>
>
> I searched the archives, but most of the other people had more full clust=
ers where sometimes this state could be valid.  This bug report seems simil=
ar, but the fix was just to make it a warning instead of an error:
>
> https://tracker.ceph.com/issues/39555
>
>
> So I've created a new tracker ticket to troubleshoot this issue:
>
> https://tracker.ceph.com/issues/4125
>
>
> Let me know what you guys think,
>
> Bryan

--=20
Paul Emmerich

Looking for help with your Ceph cluster? Contact us at https://croit.io

croit GmbH
Freseniusstr. 31h
81247 M=C3=BCnchen
www.croit.io
Tel: +49 89 1896585 90
