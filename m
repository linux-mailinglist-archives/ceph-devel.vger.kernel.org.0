Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E1F421F01
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Oct 2021 08:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhJEGrZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 5 Oct 2021 02:47:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21092 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232460AbhJEGrY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 5 Oct 2021 02:47:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633416333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tzl3XwKAEYW7NJWFaQy5Ponspx/fYmlKOSpu823JLss=;
        b=fnCb3ifaXifCicdq+rDc5IEXpQvnZYRzAm7zMguz5pxXc9TvwCVBl//OIu4lqzafNy7EHc
        /7fyrmI3pDCv9rfH4UiPmbptZj1nAZWhxUxcdr0bUcKENitSPlhpOzHW3cCoZqGh84OlIU
        di+Shu4KRl6YM1nsRHjDZ2q7uK0pJg8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-aq-hwtmmMWu7TALjbLyiCQ-1; Tue, 05 Oct 2021 02:45:33 -0400
X-MC-Unique: aq-hwtmmMWu7TALjbLyiCQ-1
Received: by mail-ed1-f72.google.com with SMTP id i7-20020a50d747000000b003db0225d219so2477425edj.0
        for <ceph-devel@vger.kernel.org>; Mon, 04 Oct 2021 23:45:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tzl3XwKAEYW7NJWFaQy5Ponspx/fYmlKOSpu823JLss=;
        b=ihpgtLJu9+a9HIoNhosMKZkVtRlpBP18baGS8GqqPj0s079rqrSMtppvlGlkBT9bjW
         /9MMJRAdoCynSiIsBhbLoqe969Yu3wrZW69UsE4vQv7/A78L+Vybyylx9BJF2GNPSBjH
         i64uCmLeXKTQqMSVblhl7RvLpEw0kTBb/NiRK8YwEJ5Cy0u+DAjtbCjkSiLNI7N2P99h
         vepPUVYTNgkoo6TprzwY4jaXIs/7EISzolzbmqSyQ3WTROoxvt1qc/9UXyQxzgb8IDCJ
         VlmbJqsXOyfOZB4zBIOPF/X+xaUJpAksxdDGKOvWJt9SshY0z8xpxUQjEmqCJQIlPSkK
         pVtg==
X-Gm-Message-State: AOAM5325oBfTyh6sjzz7/DBhaVJZ+Ty+bzUIOCextOBr7oQI2Hmweclr
        hw6dPiu8Shhye+5O2ncC7hU9O2kI4EAW41ja7yZoyf4GnPap27DqyqScD72K5+kr+eAvADAIxy3
        5EjxcwnVnFg+J6/F2TkoVcFpHLVACKJhZ4sf66w==
X-Received: by 2002:a17:907:767a:: with SMTP id kk26mr22180810ejc.134.1633416331515;
        Mon, 04 Oct 2021 23:45:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsy4L/A7DMct1jFw8jjZ5Fa7RdmdrOLK6Qlk3vwc1/vSEBb1vW6J525sLkQgyIl9lj3BrdBzlag1G2V10AdOo=
X-Received: by 2002:a17:907:767a:: with SMTP id kk26mr22180799ejc.134.1633416331374;
 Mon, 04 Oct 2021 23:45:31 -0700 (PDT)
MIME-Version: 1.0
References: <20211001050037.497199-1-vshankar@redhat.com> <e0f529e2e17cb886bd6a906541fb978be45e0e4e.camel@redhat.com>
 <CA+2bHPYGr4rpJhHb_aX3j-7iYa-tQMfjOmNL6T7R_+26HrUY3A@mail.gmail.com> <32e55634cc84b93ae70598f538b4a74f92c6907f.camel@redhat.com>
In-Reply-To: <32e55634cc84b93ae70598f538b4a74f92c6907f.camel@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Tue, 5 Oct 2021 12:14:55 +0530
Message-ID: <CACPzV1nQSmznxNduN1jhcpVj+_DFO+RgdG_0=wthvP4X_eRr8A@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] ceph: add debugfs entries signifying new mount
 syntax support
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, Oct 2, 2021 at 1:54 AM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Fri, 2021-10-01 at 16:18 -0400, Patrick Donnelly wrote:
> > On Fri, Oct 1, 2021 at 12:24 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > Note that there is a non-zero chance that this will break teuthology in
> > > some wa. In particular, looking at qa/tasks/cephfs/kernel_mount.py, it
> > > does this in _get_global_id:
> > >
> > >             pyscript = dedent("""
> > >                 import glob
> > >                 import os
> > >                 import json
> > >
> > >                 def get_id_to_dir():
> > >                     result = {}
> > >                     for dir in glob.glob("/sys/kernel/debug/ceph/*"):
> > >                         mds_sessions_lines = open(os.path.join(dir, "mds_sessions")).readlines()
> > >                         global_id = mds_sessions_lines[0].split()[1].strip('"')
> > >                         client_id = mds_sessions_lines[1].split()[1].strip('"')
> > >                         result[client_id] = global_id
> > >                     return result
> > >                 print(json.dumps(get_id_to_dir()))
> > >             """)
> > >
> > >
> > > What happens when this hits the "meta" directory? Is that a problem?
> > >
> > > We may need to fix up some places like this. Maybe the open there needs
> > > some error handling? Or we could just skip directories called "meta".

That seems to be the only place where dir entries are fetched.
Skipping the meta dir should suffice.

I'll push a change for this fix.

> >
> > Yes, this will likely break all the kernel tests. It must be fixed
> > before this can be merged into testing.
> >
>
> Ok, I'll drop these patches for now. Let me know when it's clear to
> merge them again, and I'll do so.
>
> Thanks,
> --
> Jeff Layton <jlayton@redhat.com>
>


-- 
Cheers,
Venky

