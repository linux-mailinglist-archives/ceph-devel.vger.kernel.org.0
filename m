Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982032ADCA2
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 18:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgKJRLI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 12:11:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726344AbgKJRLH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 12:11:07 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FE6D206D8;
        Tue, 10 Nov 2020 17:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605028267;
        bh=PSrGS6WprQNbVL7NlM/3jl/RlYjHVX3KTtmWe13aqfg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JCl3iGwTBKrFWpxbCm1/aIX+XmgMjUXfYHC8TrCML5sgmrKVXr4cg7ilFbysUdCB9
         /EZuXVoy9RUbkq85+KHoGE3lQo3Yj4dzsxfRulY/XVT6JC5zi4Ta6RMxKd/hN4KTdG
         2yzis/cifg3FblysjZB/PtLPn8e2ub3lWzwSgYcY=
Message-ID: <0ba63df09fe52cb3f650473f4d005a1abe301e3c.camel@kernel.org>
Subject: Re: [PATCH v3] libceph: add osd op counter metric support
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Tue, 10 Nov 2020 12:11:05 -0500
In-Reply-To: <CAOi1vP-tBRNEgkmhvieUyBzOms-n=vge4XpYSpnU6cnq86SRMQ@mail.gmail.com>
References: <20201110141937.414301-1-xiubli@redhat.com>
         <CAOi1vP-tBRNEgkmhvieUyBzOms-n=vge4XpYSpnU6cnq86SRMQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-11-10 at 16:44 +0100, Ilya Dryomov wrote:
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
> >  include/linux/ceph/osd_client.h |  9 ++++++
> >  net/ceph/debugfs.c              | 13 ++++++++
> >  net/ceph/osd_client.c           | 56 +++++++++++++++++++++++++++++++++
> >  3 files changed, 78 insertions(+)
> > 
> > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> > index 83fa08a06507..24301513b186 100644
> > --- a/include/linux/ceph/osd_client.h
> > +++ b/include/linux/ceph/osd_client.h
> > @@ -339,6 +339,13 @@ struct ceph_osd_backoff {
> >         struct ceph_hobject_id *end;
> >  };
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
> 
> The fundamental problem is that debugfs output format is not stable.
> The tracker mentions test_readahead -- updating some teuthology test
> cases from time to time is not a big deal, but if a user facing tool
> such as "fs top" starts relying on these, it would be bad.
> 
> Thanks,
> 
>                 Ilya

Those are all good points. The tracker is light on details. I had
assumed that you'd also be uploading this to the MDS in a later patch.
Is that also planned?

I'll also add that it might be nice to keeps stats on copy_from2 as
well, since we do have a copy_file_range operation in cephfs.
-- 
Jeff Layton <jlayton@kernel.org>

