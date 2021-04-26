Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF06836B870
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Apr 2021 19:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237708AbhDZR5P (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 26 Apr 2021 13:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237681AbhDZR5K (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 13:57:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 133A861007;
        Mon, 26 Apr 2021 17:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619459788;
        bh=Q38Nx9cl7A4e5m4uQTWXre7HdD9MkHe6YBcW3h9eGZk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BhTLaafaZauPJkNwP+SQcNw+SneAq8AnLMS6waF/AeTP85dme5ilVHZ8v0sQXXjhx
         9p3LEj03WX6qE1xPa+dPj9VoiP7VUe50RG0fxil+y3M4mltN4thjt5BRkL5ADdi641
         ERLAMCSJlf28mB5txDVDz0ZdR8yZWnDuCXz16wG6X7aDDMsLInvTeBSv9Zzs4q9k4g
         XABzXHXhISxnTCT2F3J6sbxnqXC4p1JRkdzXdrJFh9wcTnvJdbRhplRI/QfQtu7XZ0
         2ZCWWMHbOcZudlxt24osZvMc/+JUF+U3qWAeutr3Jw47KBVv0kQuk7bFnIjSiAgXWm
         ksB1ZkPTpM5Ug==
Message-ID: <7a63b9bd92cf3cd9f05530157fcc5d3d90b31b9e.camel@kernel.org>
Subject: Re: [PATCH v3] libceph: add osd op counter metric support
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Mon, 26 Apr 2021 13:56:26 -0400
In-Reply-To: <96d573ba-c82c-a22a-ee9d-bbc2156910ab@redhat.com>
References: <20201110141937.414301-1-xiubli@redhat.com>
         <CAOi1vP-tBRNEgkmhvieUyBzOms-n=vge4XpYSpnU6cnq86SRMQ@mail.gmail.com>
         <96d573ba-c82c-a22a-ee9d-bbc2156910ab@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-11-11 at 09:32 +0800, Xiubo Li wrote:
> On 2020/11/10 23:44, Ilya Dryomov wrote:
> > On Tue, Nov 10, 2020 at 3:19 PM <xiubli@redhat.com> wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > The logic is the same with osdc/Objecter.cc in ceph in user space.
> > > 
> > > URL: https://tracker.ceph.com/issues/48053
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > > 
> > > V3:
> > > - typo fixing about oring the _WRITE
> > > 
> > >   include/linux/ceph/osd_client.h |  9 ++++++
> > >   net/ceph/debugfs.c              | 13 ++++++++
> > >   net/ceph/osd_client.c           | 56 +++++++++++++++++++++++++++++++++
> > >   3 files changed, 78 insertions(+)
> > > 
> > > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> > > index 83fa08a06507..24301513b186 100644
> > > --- a/include/linux/ceph/osd_client.h
> > > +++ b/include/linux/ceph/osd_client.h
> > > @@ -339,6 +339,13 @@ struct ceph_osd_backoff {
> > >          struct ceph_hobject_id *end;
> > >   };
> > > 
> > > +struct ceph_osd_metric {
> > > +       struct percpu_counter op_ops;
> > > +       struct percpu_counter op_rmw;
> > > +       struct percpu_counter op_r;
> > > +       struct percpu_counter op_w;
> > > +};
> > OK, so only reads and writes are really needed.  Why not expose them
> > through the existing metrics framework in fs/ceph?  Wouldn't "fs top"
> > want to display them?  Exposing latency information without exposing
> > overall counts seems rather weird to me anyway.
> 
> Okay, I just thought in future this may also be needed by rbd :-)
> 
> 
> > The fundamental problem is that debugfs output format is not stable.
> > The tracker mentions test_readahead -- updating some teuthology test
> > cases from time to time is not a big deal, but if a user facing tool
> > such as "fs top" starts relying on these, it would be bad.
> 
> No problem, let me move it to fs existing metric framework.
> 

Hi Xiubo/Ilya/Patrick :

Mea culpa...I had intended to drop this patch from testing branch after
this discussion, but got sidetracked and forgot to do so. I've now done
that though.

Cheers,
Jeff

