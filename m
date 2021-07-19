Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6482D3CCE34
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Jul 2021 09:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbhGSHGn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Jul 2021 03:06:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234441AbhGSHGn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 19 Jul 2021 03:06:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626678223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7HerrG2wibrtk4RPZ7QRoS/Jolkz29snwELng/Cg1PY=;
        b=hHmhADqyQLz5aq47av2FMf3xcbH9cI14HL0uX6IVLNoa/GBh2qRkjWP5+c2wCvJCCI7m9y
        uzOY3+jQ54rR9mcHbpFh2Z48IhX5nWwCVRZB7P+B+Zv/K3FSdrdeNOM1lDTLvl1UteiEy6
        5QIPY6CXAh00H8ugyHp6KMUb3tMoOe4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-SCVdXzGfPsijfr82V8kPKg-1; Mon, 19 Jul 2021 03:03:42 -0400
X-MC-Unique: SCVdXzGfPsijfr82V8kPKg-1
Received: by mail-ed1-f70.google.com with SMTP id i19-20020a05640200d3b02903948b71f25cso8741180edu.4
        for <ceph-devel@vger.kernel.org>; Mon, 19 Jul 2021 00:03:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7HerrG2wibrtk4RPZ7QRoS/Jolkz29snwELng/Cg1PY=;
        b=CSyz5t8GQAktCkruquzxAcRCRdeOE3PF8QiIEXelczE4ekIvde0c4wtEwM+IG4LcPb
         ZWEE5rnFpe5Pwa9zXy53iBYk/wb32q50zS4DKlna9qZMk2jTvdREmguNBuVm0icYxAV7
         yilc5/FwGkCL+Yu9Hf/YguSzk7w8o8oQ7Z/URaqEqI1koIt3V9+IOH1Pw2i5KWIan18d
         3S+GK+rtNceS/o5BC9HHphws6Dn1s0J/99VFz3UyxXjKV1JGT4EsB2shWJ4k+zmeS9TL
         dE4jczHAVoaKOlWmm1eH16YUQpuJwg0dxxLV3yt13mRBjRrLYZAgWthua8V1n0Rz7i4A
         T64Q==
X-Gm-Message-State: AOAM533JvcYoMaeNGxhAkDig9JC7aM3iOj73DvvaFIJHfzrdZasK7SM/
        rq1bcvvolwTomVzr7GUN+PHeM/xNu2eiVJhBga62dTdbT40sNkFgzNNiQ7NPv6rl6M5jmuxuop6
        XaJavZzXfn+jdes4ATOxQoxmBbhZ8AYCk5mPCYg==
X-Received: by 2002:a05:6402:298:: with SMTP id l24mr32466445edv.125.1626678221120;
        Mon, 19 Jul 2021 00:03:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPaQToDw6FOg387gtBnZ2qvQPTOQD7VxAJ6FseFb29k0rF9dpJ6uUe5lVbYpGwCmbkt/xrp6jllWraxoiLSek=
X-Received: by 2002:a05:6402:298:: with SMTP id l24mr32466435edv.125.1626678221024;
 Mon, 19 Jul 2021 00:03:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210714100554.85978-1-vshankar@redhat.com> <75e674f7be189192a869b971f6e36da01d5ef997.camel@redhat.com>
In-Reply-To: <75e674f7be189192a869b971f6e36da01d5ef997.camel@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Mon, 19 Jul 2021 12:33:04 +0530
Message-ID: <CACPzV1kjKBUqE46O=kW0q-j1YUNWLfMrKKKBJO-KaohjzsjCWw@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] ceph: new mount device syntax
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Luis Henriques <lhenriques@suse.de>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, Jul 17, 2021 at 12:17 AM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Wed, 2021-07-14 at 15:35 +0530, Venky Shankar wrote:
> > v4:
> >   - fix delimiter check in ceph_parse_ips()
> >   - use __func__ in ceph_parse_ips() instead of hardcoded function name
> >   - KERN_NOTICE that mon_addr is recorded but not reconnected
> >
> > Venky Shankar (5):
> >   ceph: generalize addr/ip parsing based on delimiter
> >   ceph: rename parse_fsid() to ceph_parse_fsid() and export
> >   ceph: new device mount syntax
> >   ceph: record updated mon_addr on remount
> >   doc: document new CephFS mount device syntax
> >
> >  Documentation/filesystems/ceph.rst |  25 ++++-
> >  drivers/block/rbd.c                |   3 +-
> >  fs/ceph/super.c                    | 151 +++++++++++++++++++++++++++--
> >  fs/ceph/super.h                    |   3 +
> >  include/linux/ceph/libceph.h       |   5 +-
> >  include/linux/ceph/messenger.h     |   2 +-
> >  net/ceph/ceph_common.c             |  17 ++--
> >  net/ceph/messenger.c               |   8 +-
> >  8 files changed, 186 insertions(+), 28 deletions(-)
> >
>
> I've gone ahead and merged these into the testing branch, though I have
> not had time to personally do any testing with the new mount helper or
> new syntax. It does seem to behave fine with the old mount helper and
> syntax.
>
> Venky, I did make a couple of minor changes to this patch:
>
>     ceph: record updated mon_addr on remount
>
> Please take a look when you have time and make sure they're OK.

Looks good, Thanks.

>
> Thanks,
> --
> Jeff Layton <jlayton@redhat.com>
>


-- 
Cheers,
Venky

