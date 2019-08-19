Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1462D91AB3
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2019 03:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfHSB0t convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Sun, 18 Aug 2019 21:26:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48198 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfHSB0t (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 18 Aug 2019 21:26:49 -0400
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7942DC08EC21
        for <ceph-devel@vger.kernel.org>; Mon, 19 Aug 2019 01:26:48 +0000 (UTC)
Received: by mail-lf1-f72.google.com with SMTP id z14so247110lfq.21
        for <ceph-devel@vger.kernel.org>; Sun, 18 Aug 2019 18:26:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Cs+we+uw+vNYzEtTLHqa8i8XrUL//GNJXqLZXhtmp2o=;
        b=kEAr2wdJL09CuCMBMlAzDbpoHZ9mUyer6CEqEVmaIxbojmgnf0sUjCtPdArTVuOYR/
         8dteM1VPIXxqnoHAdLxrJ2jEvH2Ub9Vy+jblxF4qxl45LJcZ+kGs48UfpDg6hf3NIPDl
         fLjzbu3nFbznhFgPrbkDUKU6C9vjRWkGUSn1BdkgHsbQgYtKBqAX4BPX3LohRCi9gXTH
         MAm1235sa5340GC88nLg8AXxcsegswZPBMB4t7tIPcRU/2BFc26S9w+YaCqDG3P0NnE6
         s8EkAu8Vf6gocnPRq4vM5ijD746IMa8wbCkSoJNL3q+N77o7MOoS4jKbM8Bp4rlYAzNe
         jpxQ==
X-Gm-Message-State: APjAAAXVv+kx+liJ3jdDT3BLfdVrDP6IqLjLEYDYvtcOzT+42e5/isws
        1nswHJ1zp2LhS1KCp99l0Gl8VP1oVLKxLXDdLKSFnTtJdSHzuq/Q1uz8M5+IUPYwku7DeX9+//b
        aIteQ+jiYcXifMsc3p56rQj+75lILWK/+FqHwFw==
X-Received: by 2002:ac2:42c3:: with SMTP id n3mr3076520lfl.117.1566178006423;
        Sun, 18 Aug 2019 18:26:46 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwPXxW9h0UDxgWELZ1QWApeHXbzhADRZDAq1R71JQ62/+k1vLOv/k1s/T89tkXPu77XMFGoIQdq2/PIanuiLAs=
X-Received: by 2002:ac2:42c3:: with SMTP id n3mr3076515lfl.117.1566178006249;
 Sun, 18 Aug 2019 18:26:46 -0700 (PDT)
MIME-Version: 1.0
References: <B44994A6-D75F-4793-8599-7C3B7C53B3AB@godaddy.com> <CAD9yTbFrs0Mu3XGnHiYUNob3zkpgPQquSvboUJDBpmwRX-mP4A@mail.gmail.com>
In-Reply-To: <CAD9yTbFrs0Mu3XGnHiYUNob3zkpgPQquSvboUJDBpmwRX-mP4A@mail.gmail.com>
From:   Brad Hubbard <bhubbard@redhat.com>
Date:   Mon, 19 Aug 2019 11:26:34 +1000
Message-ID: <CAF-wwdH1suKzUGvnZv6NRDw78XZQB2CZgWK8RGFH7N7bYYYbtQ@mail.gmail.com>
Subject: Re: backfill_toofull seen on cluster where the most full OSD is at 1%
To:     Paul Emmerich <paul.emmerich@croit.io>
Cc:     Bryan Stillwell <bstillwell@godaddy.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

+dev@ceph

On Thu, Aug 15, 2019 at 10:42 PM Paul Emmerich <paul.emmerich@croit.io> wrote:
>
> We've also seen this bug several times since Mimic, it seems to happen
> whenever a backfill target goes down. Always resolves itself but is
> still annoying.
>
> The original fixmaking this a warning instead of an error
> unfortunately doesn't help on Nautilus because we often have clusters
> that would be HEALTH_OK without this bug on Nautilus (i.e., some PGs
> in remapped+backfill*) but they will show up as HEALTH_WARN with this
> fix (and HEALTH_ERR without it).
>
>
>
> Paul
>
>
>
> On Wed, Aug 14, 2019 at 11:44 PM Bryan Stillwell <bstillwell@godaddy.com> wrote:
> >
> > We've run into this issue on the first two clusters after upgrading them to Nautilus (14.2.2).
> >
> > When marking a single OSD back in to the cluster some PGs will switch to the active+remapped+backfill_wait+backfill_toofull state for a while and then it goes away after some of the other PGs finish backfilling.  This is rather odd because all the data on the cluster could fit on a single drive, but we have over 100 of them:
> >
> > # ceph -s
> >   cluster:
> >     id:     XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
> >     health: HEALTH_ERR
> >             Degraded data redundancy (low space): 1 pg backfill_toofull
> >
> >   services:
> >     mon: 3 daemons, quorum a1cephmon002,a1cephmon003,a1cephmon004 (age 21h)
> >     mgr: a1cephmon002(active, since 21h), standbys: a1cephmon003, a1cephmon004
> >     mds: cephfs:2 {0=a1cephmon002=up:active,1=a1cephmon003=up:active} 1 up:standby
> >     osd: 143 osds: 142 up, 142 in; 106 remapped pgs
> >     rgw: 11 daemons active (radosgw.a1cephrgw008, radosgw.a1cephrgw009, radosgw.a1cephrgw010, radosgw.a1cephrgw011, radosgw.a1tcephrgw002, radosgw.a1tcephrgw003, radosgw.a1tcephrgw004, radosgw.a1tcephrgw005, radosgw.a1tcephrgw006, radosgw.a1tcephrgw007, radosgw.a1tcephrgw008)
> >
> >   data:
> >     pools:   19 pools, 5264 pgs
> >     objects: 1.45M objects, 148 GiB
> >     usage:   658 GiB used, 436 TiB / 437 TiB avail
> >     pgs:     44484/4351770 objects misplaced (1.022%)
> >              5158 active+clean
> >              104  active+remapped+backfill_wait
> >              1    active+remapped+backfilling
> >              1    active+remapped+backfill_wait+backfill_toofull
> >
> >   io:
> >     client:   19 MiB/s rd, 13 MiB/s wr, 431 op/s rd, 509 op/s wr
> >
> >
> > I searched the archives, but most of the other people had more full clusters where sometimes this state could be valid.  This bug report seems similar, but the fix was just to make it a warning instead of an error:
> >
> > https://tracker.ceph.com/issues/39555
> >
> >
> > So I've created a new tracker ticket to troubleshoot this issue:
> >
> > https://tracker.ceph.com/issues/4125
> >
> >
> > Let me know what you guys think,
> >
> > Bryan
>
> --
> Paul Emmerich
>
> Looking for help with your Ceph cluster? Contact us at https://croit.io
>
> croit GmbH
> Freseniusstr. 31h
> 81247 München
> www.croit.io
> Tel: +49 89 1896585 90



-- 
Cheers,
Brad
