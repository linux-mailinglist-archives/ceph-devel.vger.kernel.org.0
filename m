Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631192AF49B
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Nov 2020 16:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbgKKPTC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Nov 2020 10:19:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40011 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726885AbgKKPTC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Nov 2020 10:19:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605107940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6DAsKWwppASUyiE8uSGqZ4gHEIjlkFW7hzJbqKEWbVw=;
        b=SlXqseksLNeS5z2eF/xCQLKybISDiZ59qT3HLFKsWcWdUZz+1WUKPHRS7OO6wQWFYxQOd0
        9M7AmnZKgzG33hZZXs6UbrhFY23IlFFc3xq7wLREKQHdAyj9ZpCEsXCYjwPVMsJ3ZGlzpg
        d21RaCa69dUd/jzv7WwbuRrpwLBm7II=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-zyub4GsjOCSNMuqto1Cmww-1; Wed, 11 Nov 2020 10:18:56 -0500
X-MC-Unique: zyub4GsjOCSNMuqto1Cmww-1
Received: by mail-il1-f198.google.com with SMTP id g14so1568873ilr.7
        for <ceph-devel@vger.kernel.org>; Wed, 11 Nov 2020 07:18:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6DAsKWwppASUyiE8uSGqZ4gHEIjlkFW7hzJbqKEWbVw=;
        b=J2NB46qrSkgJusGfVRUZszDbuRKbjNccoZTGv4JquCcT1DtSmYjdn/VuLurMX9jAji
         HafGS17Qm0GLU8PQ6zYoEsxMirbGLrWgva0B88r+eppcuErZWWJDXsx1EZ2dDPjKW9UR
         RtSdtKgfR3qIKlDpmBA00HyyZVKEs0KVSPWoF7mW8niWhY7Qngud3fv/H+TOidzNp6zi
         +DI3Dm8KMJ0HkEAvzPRbzjMvkBZPasoZXmR1W4/zsRyS2PWAFo9yEjkl3a1i9mZXuw+M
         icjQ15Km3SurLhEK9xzdWbwEQyolchsurGpV8WEk4O27G5QGC0aeK2Zlxo/Yyn5rl75y
         Re3A==
X-Gm-Message-State: AOAM531v6s21VkFtPfFtIsJ8qST+3bK/03rgoiJ+/AE2l9awlUs3Ps7A
        1WTwMy+Ngxp9dTEKxMJd55za6aDaO6RKrgWSJxeX8s3z565keL9RuW8B1Xu9AgkdUIEfR3xMu0u
        NFE94Oto3inQFn1mo+T7a389DDDq4yuQGP4utQA==
X-Received: by 2002:a6b:7205:: with SMTP id n5mr18645230ioc.208.1605107934810;
        Wed, 11 Nov 2020 07:18:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzY6oJ9gPkBaMc37oQn542JvclE8J/GHirdcRh4f6gMBktzaQY/GVJqyb7Dz7Au0h+Kl7EYHzeLCz6XaxOG4Vg=
X-Received: by 2002:a6b:7205:: with SMTP id n5mr18645211ioc.208.1605107934618;
 Wed, 11 Nov 2020 07:18:54 -0800 (PST)
MIME-Version: 1.0
References: <20201110141937.414301-1-xiubli@redhat.com> <CAOi1vP-tBRNEgkmhvieUyBzOms-n=vge4XpYSpnU6cnq86SRMQ@mail.gmail.com>
In-Reply-To: <CAOi1vP-tBRNEgkmhvieUyBzOms-n=vge4XpYSpnU6cnq86SRMQ@mail.gmail.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Wed, 11 Nov 2020 07:18:28 -0800
Message-ID: <CA+2bHPb1pP-xRGVrKfOqB8D94Nku_s5Kj+kVSzOzg3Zxpypzfg@mail.gmail.com>
Subject: Re: [PATCH v3] libceph: add osd op counter metric support
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Nov 10, 2020 at 7:45 AM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Tue, Nov 10, 2020 at 3:19 PM <xiubli@redhat.com> wrote:
> >
> > From: Xiubo Li <xiubli@redhat.com>
> >
> > The logic is the same with osdc/Objecter.cc in ceph in user space.
> >
> > URL: https://tracker.ceph.com/issues/48053
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >
> > V3:
> > - typo fixing about oring the _WRITE
> >
> >  include/linux/ceph/osd_client.h |  9 ++++++
> >  net/ceph/debugfs.c              | 13 ++++++++
> >  net/ceph/osd_client.c           | 56 +++++++++++++++++++++++++++++++++
> >  3 files changed, 78 insertions(+)
> >
> > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> > index 83fa08a06507..24301513b186 100644
> > --- a/include/linux/ceph/osd_client.h
> > +++ b/include/linux/ceph/osd_client.h
> > @@ -339,6 +339,13 @@ struct ceph_osd_backoff {
> >         struct ceph_hobject_id *end;
> >  };
> >
> > +struct ceph_osd_metric {
> > +       struct percpu_counter op_ops;
> > +       struct percpu_counter op_rmw;
> > +       struct percpu_counter op_r;
> > +       struct percpu_counter op_w;
> > +};
>
> OK, so only reads and writes are really needed.  Why not expose them
> through the existing metrics framework in fs/ceph?  Wouldn't "fs top"
> want to display them?  Exposing latency information without exposing
> overall counts seems rather weird to me anyway.

`fs top` may want to eventually display this information but the
intention was to have a "perf dump"-like debugfs file that has
information about the number of osd op reads/writes. We need that for
this test:

https://github.com/ceph/ceph/blob/master/qa/tasks/cephfs/test_readahead.py#L20

Pulling the information out through `fs top` is not a direction I'd like to go.

> The fundamental problem is that debugfs output format is not stable.
> The tracker mentions test_readahead -- updating some teuthology test
> cases from time to time is not a big deal, but if a user facing tool
> such as "fs top" starts relying on these, it would be bad.

`fs top` will not rely on debugfs files.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

