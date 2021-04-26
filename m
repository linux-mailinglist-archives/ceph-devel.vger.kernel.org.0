Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA5336BABD
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Apr 2021 22:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbhDZUeZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 26 Apr 2021 16:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235996AbhDZUeZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 26 Apr 2021 16:34:25 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671BFC061574
        for <ceph-devel@vger.kernel.org>; Mon, 26 Apr 2021 13:33:43 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id g125so3046391iof.3
        for <ceph-devel@vger.kernel.org>; Mon, 26 Apr 2021 13:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NH6NK9TYYvPqpV3WHirUXYUIXwOisAoo24l7QhmktMI=;
        b=jR+ScQiKJ1blSv2gEfSHBafhRtIWmtvYk+jDZ6AsOUJEGOpO5gptEfV/Cik9GCmHIO
         D5L8M2vbF2tggAOoAPCPZ0tR3JFqvT+oBtE0DNm/bCUtNM25t+5tN66uVawQzkISCATr
         A+E+8AiBZMXg64CSPHgDFFbq+MhGcyOPT1EziHKDwkjx7oQssypJibBlUlvspbFIiTrQ
         87QlUmcseRusG5fjPtr63y+3KrfJ9X55NNmqwtsPIa58iWk4yowZrBVouupO55IGTUXH
         rqnjFUog48JUPq1NDMykBkY/CUP0879T40luJmPiTdJ97q+nLh0fxPc8lTEr4+aadjs+
         XT6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NH6NK9TYYvPqpV3WHirUXYUIXwOisAoo24l7QhmktMI=;
        b=LQ4PJ8382t/Nl5u1LdoWsrxPhNaSgH+TW+78Fyn+rIZht5ZGMz8zWGrSAIefisaHYO
         UPVj445FHBBDmLnuLy7xeiu+Tr2J0uQabegx1vbRJLrO6qnXfJnjIi4tfstdaKh3Q8tE
         WLsTEwa7FXX6BjbLwZRNEQZc1+GfwJ8YvwxwIbGPEjtJ1EPCzvj1TDbm0zE4dGtOVNyA
         H9UmBMcgw8mW5OFedTBzFFJR44PM+EVIoa11Aj9b3+QRSmCmcuUxjPj8zT6iKc4LrlKU
         /Q8aVcgJQvlrpJHqU8th1Ex6hPl1ofRApQ4WcCm61orxcjlRDhJAvWoPojfXju04qcqm
         BeDw==
X-Gm-Message-State: AOAM530nTmfyrmU0z7WEgAbIHpqQr+q67HpTQexRhxvAd35zNTYfh/QP
        m3VN9Z+ax16b309usHrJre0hXKqzcBAWX7X4olA=
X-Google-Smtp-Source: ABdhPJyxMVHqSekKbKwK0++CIvOYxIDLAEpNt6dZOS3g0tdwh5+0+P992b/0Vzk0hUMDYNkTn7YEok2k7IEVZWktpV4=
X-Received: by 2002:a02:cd87:: with SMTP id l7mr11598632jap.10.1619469222959;
 Mon, 26 Apr 2021 13:33:42 -0700 (PDT)
MIME-Version: 1.0
References: <20201110141937.414301-1-xiubli@redhat.com> <CAOi1vP-tBRNEgkmhvieUyBzOms-n=vge4XpYSpnU6cnq86SRMQ@mail.gmail.com>
 <96d573ba-c82c-a22a-ee9d-bbc2156910ab@redhat.com> <7a63b9bd92cf3cd9f05530157fcc5d3d90b31b9e.camel@kernel.org>
In-Reply-To: <7a63b9bd92cf3cd9f05530157fcc5d3d90b31b9e.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 26 Apr 2021 22:33:47 +0200
Message-ID: <CAOi1vP-RfOtZiCpnBb9jiHWJqepXG0+T7y7O=YjYfE9W5Mx9SA@mail.gmail.com>
Subject: Re: [PATCH v3] libceph: add osd op counter metric support
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Apr 26, 2021 at 7:56 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2020-11-11 at 09:32 +0800, Xiubo Li wrote:
> > On 2020/11/10 23:44, Ilya Dryomov wrote:
> > > On Tue, Nov 10, 2020 at 3:19 PM <xiubli@redhat.com> wrote:
> > > > From: Xiubo Li <xiubli@redhat.com>
> > > >
> > > > The logic is the same with osdc/Objecter.cc in ceph in user space.
> > > >
> > > > URL: https://tracker.ceph.com/issues/48053
> > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > ---
> > > >
> > > > V3:
> > > > - typo fixing about oring the _WRITE
> > > >
> > > >   include/linux/ceph/osd_client.h |  9 ++++++
> > > >   net/ceph/debugfs.c              | 13 ++++++++
> > > >   net/ceph/osd_client.c           | 56 +++++++++++++++++++++++++++++++++
> > > >   3 files changed, 78 insertions(+)
> > > >
> > > > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> > > > index 83fa08a06507..24301513b186 100644
> > > > --- a/include/linux/ceph/osd_client.h
> > > > +++ b/include/linux/ceph/osd_client.h
> > > > @@ -339,6 +339,13 @@ struct ceph_osd_backoff {
> > > >          struct ceph_hobject_id *end;
> > > >   };
> > > >
> > > > +struct ceph_osd_metric {
> > > > +       struct percpu_counter op_ops;
> > > > +       struct percpu_counter op_rmw;
> > > > +       struct percpu_counter op_r;
> > > > +       struct percpu_counter op_w;
> > > > +};
> > > OK, so only reads and writes are really needed.  Why not expose them
> > > through the existing metrics framework in fs/ceph?  Wouldn't "fs top"
> > > want to display them?  Exposing latency information without exposing
> > > overall counts seems rather weird to me anyway.
> >
> > Okay, I just thought in future this may also be needed by rbd :-)
> >
> >
> > > The fundamental problem is that debugfs output format is not stable.
> > > The tracker mentions test_readahead -- updating some teuthology test
> > > cases from time to time is not a big deal, but if a user facing tool
> > > such as "fs top" starts relying on these, it would be bad.
> >
> > No problem, let me move it to fs existing metric framework.
> >
>
> Hi Xiubo/Ilya/Patrick :
>
> Mea culpa...I had intended to drop this patch from testing branch after
> this discussion, but got sidetracked and forgot to do so. I've now done
> that though.

On the subject of metrics, I think Xiubo's I/O size metrics patches
need a look -- he reposted the two that were skipped a while ago.

Thanks,

                Ilya
