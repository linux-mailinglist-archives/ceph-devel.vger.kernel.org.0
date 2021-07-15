Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54D93C9894
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Jul 2021 07:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240161AbhGOFzk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 15 Jul 2021 01:55:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29594 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240121AbhGOFzj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 15 Jul 2021 01:55:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626328366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h+8maYeedewDZahRWhUrQb0Q17qgvl2uH1JlBhOIeow=;
        b=RH0fvFMI1ssUjXC2PXG7Zx+7lJDfzxMlyNgx3Av/V9F58RBsrsIupZerNkMcQHJ7rdQPQL
        EJrA23M+JsidlUmUbupzhAhE+c10Nc0/XZVM/W2mOXEaLbMlsUHLup6n2oCAijIMAd5Rqn
        khg2kx5wNJhZWqigCCk1U9xwMUaFyoA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-hYsOg5vuOvCN-ni6EjFLaA-1; Thu, 15 Jul 2021 01:52:43 -0400
X-MC-Unique: hYsOg5vuOvCN-ni6EjFLaA-1
Received: by mail-ed1-f71.google.com with SMTP id o8-20020aa7dd480000b02903954c05c938so2535775edw.3
        for <ceph-devel@vger.kernel.org>; Wed, 14 Jul 2021 22:52:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h+8maYeedewDZahRWhUrQb0Q17qgvl2uH1JlBhOIeow=;
        b=B4VIjt3lXhIUKiet+61QVxiYvCjJRmKrJtgQOMpjLSqed39Ln5anqTGRsMLTkL/lY9
         6GOHTHJnOnCmrrQoAsN4B36TGixWCxBc2WWkNbT7ZoNFVKrhDqIL+6PFqxsDIbnP6asJ
         7TDVA79/FnT94jjmWkSTJF74IVyI+wWWgL0ULzVRDikH7VhDlZutszzu6z7o2QtB+8mT
         NsVcAzCdZRGK4fft85gGLiqUX0FyTl4jqdbXmUHi4Mv2WoO+znNcUAr9BZDpEFxodBr/
         Xz7jZRNmkCV++arI5Fuh8cGtHMLZXMnsqiaQGX60HHN7XH+TIezXM/Fq1JGlM7T07KZJ
         WL2Q==
X-Gm-Message-State: AOAM530IknxGMOOT2Do7BvDgvbErPLdFirNJjIpFrO0rywTVyIRdB/HJ
        vignHtqajw8utU8sARNFqmDEJysEMfVLjERwgw7jWGPiGyCMFVOd7WK4JEfWHNvTU5corNtUvju
        PZ+RASgimZYIeGC4nXVw53Xg4WFqRGyuYGqq+2A==
X-Received: by 2002:a17:906:f0d1:: with SMTP id dk17mr3234050ejb.424.1626328361994;
        Wed, 14 Jul 2021 22:52:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzu025AUEl/I/cop0qeKzhNtMkHNWL20nwhywNiemRHAeRtfJwvpmtRzlqiGXx/+9okaVOQA34fs9w8MCfB1jM=
X-Received: by 2002:a17:906:f0d1:: with SMTP id dk17mr3234034ejb.424.1626328361861;
 Wed, 14 Jul 2021 22:52:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210714100554.85978-1-vshankar@redhat.com> <20210714100554.85978-5-vshankar@redhat.com>
 <848d919c6a791ab9b7c61d7cb89f759b55195c18.camel@redhat.com>
In-Reply-To: <848d919c6a791ab9b7c61d7cb89f759b55195c18.camel@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Thu, 15 Jul 2021 11:22:05 +0530
Message-ID: <CACPzV1npESD7-LFb-3gCmuydF-VTuuTtVJFicQ7r9w20GLcvUA@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] ceph: record updated mon_addr on remount
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Luis Henriques <lhenriques@suse.de>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jul 14, 2021 at 9:47 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Wed, 2021-07-14 at 15:35 +0530, Venky Shankar wrote:
> > Note that the new monitors are just shown in /proc/mounts.
> > Ceph does not (re)connect to new monitors yet.
> >
> > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > ---
> >  fs/ceph/super.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index d8c6168b7fcd..d3a5a3729c5b 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -1268,6 +1268,13 @@ static int ceph_reconfigure_fc(struct fs_context *fc)
> >       else
> >               ceph_clear_mount_opt(fsc, ASYNC_DIROPS);
> >
> > +     if (strcmp(fsc->mount_options->mon_addr, fsopt->mon_addr)) {
> > +             kfree(fsc->mount_options->mon_addr);
> > +             fsc->mount_options->mon_addr = fsopt->mon_addr;
> > +             fsopt->mon_addr = NULL;
> > +             printk(KERN_NOTICE "ceph: monitor addresses recorded, but not used for reconnection");
>
> It's currently more in-vogue to use pr_notice() for this. I'll plan to
> make that (minor) change before I merge. No need to resend.

Got it. ACK.

>
> > +     }
> > +
> >       sync_filesystem(fc->root->d_sb);
> >       return 0;
> >  }
>
> --
> Jeff Layton <jlayton@redhat.com>
>


-- 
Cheers,
Venky

