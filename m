Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E60289D8E
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Aug 2019 14:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbfHLMHa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Aug 2019 08:07:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726987AbfHLMHa (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 12 Aug 2019 08:07:30 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CF4020651;
        Mon, 12 Aug 2019 12:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565611648;
        bh=mosU0gK7/xvkslNUMNWdCHL/t6RDtzheFgYztHxereU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JbaDlH4teQMdkw9B4bRLjqiU/PiMBw+qG+bDoyP/F3VbhMAqep9EDRX6AQUjQKeaQ
         bTiwTXLVpamBHhgKO2L9dT3n99QDiY7SGF8vbXgx7bnAgDXKNmLvknyflT2kaRuYfT
         KzeRVPj8aE16AQEmF3MCtvVB9AvK4R4VNFLOh3ec=
Message-ID: <ebafed9fb452df12b8fd50eb55511ab045656110.camel@kernel.org>
Subject: Re: [PATCH 8/9] ceph: new tracepoints when adding and removing caps
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <ukernel@gmail.com>, Sage Weil <sage@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Date:   Mon, 12 Aug 2019 08:07:27 -0400
In-Reply-To: <CAOi1vP9i_=WWbngP2=tONY+rTVSiC=4=qfmZbV25roDkVUYp5A@mail.gmail.com>
References: <20190801202605.18172-1-jlayton@kernel.org>
         <20190801202605.18172-9-jlayton@kernel.org>
         <1916bc5f2b96eab8556fa9154492fb8379447278.camel@kernel.org>
         <CAOi1vP9i_=WWbngP2=tONY+rTVSiC=4=qfmZbV25roDkVUYp5A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2019-08-10 at 14:32 +0200, Ilya Dryomov wrote:
> On Fri, Aug 9, 2019 at 7:21 PM Jeff Layton <jlayton@kernel.org> wrote:
> > On Thu, 2019-08-01 at 16:26 -0400, Jeff Layton wrote:
> > > Add support for two new tracepoints surrounding the adding/updating and
> > > removing of caps from the cache. To support this, we also add new functions
> > > for printing cap strings a'la ceph_cap_string().
> > > 
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/Makefile                |  3 +-
> > >  fs/ceph/caps.c                  |  4 ++
> > >  fs/ceph/trace.c                 | 76 +++++++++++++++++++++++++++++++++
> > >  fs/ceph/trace.h                 | 55 ++++++++++++++++++++++++
> > >  include/linux/ceph/ceph_debug.h |  1 +
> > >  5 files changed, 138 insertions(+), 1 deletion(-)
> > >  create mode 100644 fs/ceph/trace.c
> > >  create mode 100644 fs/ceph/trace.h
> > > 
> > > diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
> > > index a699e320393f..5148284f74a9 100644
> > > --- a/fs/ceph/Makefile
> > > +++ b/fs/ceph/Makefile
> > > @@ -3,12 +3,13 @@
> > >  # Makefile for CEPH filesystem.
> > >  #
> > > 
> > > +ccflags-y += -I$(src)        # needed for trace events
> > >  obj-$(CONFIG_CEPH_FS) += ceph.o
> > > 
> > >  ceph-y := super.o inode.o dir.o file.o locks.o addr.o ioctl.o \
> > >       export.o caps.o snap.o xattr.o quota.o \
> > >       mds_client.o mdsmap.o strings.o ceph_frag.o \
> > > -     debugfs.o
> > > +     debugfs.o trace.o
> > > 
> > >  ceph-$(CONFIG_CEPH_FSCACHE) += cache.o
> > >  ceph-$(CONFIG_CEPH_FS_POSIX_ACL) += acl.o
> > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > index 9344e742397e..236d9c205e3d 100644
> > > --- a/fs/ceph/caps.c
> > > +++ b/fs/ceph/caps.c
> > > @@ -13,6 +13,7 @@
> > >  #include "super.h"
> > >  #include "mds_client.h"
> > >  #include "cache.h"
> > > +#include "trace.h"
> > >  #include <linux/ceph/decode.h>
> > >  #include <linux/ceph/messenger.h>
> > > 
> > > @@ -754,6 +755,8 @@ void ceph_add_cap(struct inode *inode,
> > >       cap->mseq = mseq;
> > >       cap->cap_gen = gen;
> > > 
> > > +     trace_ceph_add_cap(cap);
> > > +
> > >       if (fmode >= 0)
> > >               __ceph_get_fmode(ci, fmode);
> > >  }
> > > @@ -1078,6 +1081,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
> > >       int removed = 0;
> > > 
> > >       dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
> > > +     trace_ceph_remove_cap(cap);
> > > 
> > >       /* remove from session list */
> > >       spin_lock(&session->s_cap_lock);
> > > diff --git a/fs/ceph/trace.c b/fs/ceph/trace.c
> > > new file mode 100644
> > > index 000000000000..e082d4eb973f
> > > --- /dev/null
> > > +++ b/fs/ceph/trace.c
> > > @@ -0,0 +1,76 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +#define CREATE_TRACE_POINTS
> > > +#include "trace.h"
> > > +
> > > +#define CEPH_CAP_BASE_MASK   (CEPH_CAP_GSHARED|CEPH_CAP_GEXCL)
> > > +#define CEPH_CAP_FILE_MASK   (CEPH_CAP_GSHARED |     \
> > > +                              CEPH_CAP_GEXCL |       \
> > > +                              CEPH_CAP_GCACHE |      \
> > > +                              CEPH_CAP_GRD |         \
> > > +                              CEPH_CAP_GWR |         \
> > > +                              CEPH_CAP_GBUFFER |     \
> > > +                              CEPH_CAP_GWREXTEND |   \
> > > +                              CEPH_CAP_GLAZYIO)
> > > +
> > > +static void
> > > +trace_gcap_string(struct trace_seq *p, int c)
> > > +{
> > > +     if (c & CEPH_CAP_GSHARED)
> > > +             trace_seq_putc(p, 's');
> > > +     if (c & CEPH_CAP_GEXCL)
> > > +             trace_seq_putc(p, 'x');
> > > +     if (c & CEPH_CAP_GCACHE)
> > > +             trace_seq_putc(p, 'c');
> > > +     if (c & CEPH_CAP_GRD)
> > > +             trace_seq_putc(p, 'r');
> > > +     if (c & CEPH_CAP_GWR)
> > > +             trace_seq_putc(p, 'w');
> > > +     if (c & CEPH_CAP_GBUFFER)
> > > +             trace_seq_putc(p, 'b');
> > > +     if (c & CEPH_CAP_GWREXTEND)
> > > +             trace_seq_putc(p, 'a');
> > > +     if (c & CEPH_CAP_GLAZYIO)
> > > +             trace_seq_putc(p, 'l');
> > > +}
> > > +
> > > +const char *
> > > +trace_ceph_cap_string(struct trace_seq *p, int caps)
> > > +{
> > > +     int c;
> > > +     const char *ret = trace_seq_buffer_ptr(p);
> > > +
> > > +     if (caps == 0) {
> > > +             trace_seq_putc(p, '-');
> > > +             goto out;
> > > +     }
> > > +
> > > +     if (caps & CEPH_CAP_PIN)
> > > +             trace_seq_putc(p, 'p');
> > > +
> > > +     c = (caps >> CEPH_CAP_SAUTH) & CEPH_CAP_BASE_MASK;
> > > +     if (c) {
> > > +             trace_seq_putc(p, 'A');
> > > +             trace_gcap_string(p, c);
> > > +     }
> > > +
> > > +     c = (caps >> CEPH_CAP_SLINK) & CEPH_CAP_BASE_MASK;
> > > +     if (c) {
> > > +             trace_seq_putc(p, 'L');
> > > +             trace_gcap_string(p, c);
> > > +     }
> > > +
> > > +     c = (caps >> CEPH_CAP_SXATTR) & CEPH_CAP_BASE_MASK;
> > > +     if (c) {
> > > +             trace_seq_putc(p, 'X');
> > > +             trace_gcap_string(p, c);
> > > +     }
> > > +
> > > +     c = (caps >> CEPH_CAP_SFILE) & CEPH_CAP_FILE_MASK;
> > > +     if (c) {
> > > +             trace_seq_putc(p, 'F');
> > > +             trace_gcap_string(p, c);
> > > +     }
> > > +out:
> > > +     trace_seq_putc(p, '\0');
> > > +     return ret;
> > > +}
> > > diff --git a/fs/ceph/trace.h b/fs/ceph/trace.h
> > > new file mode 100644
> > > index 000000000000..d1cf4bb8a21d
> > > --- /dev/null
> > > +++ b/fs/ceph/trace.h
> > > @@ -0,0 +1,55 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +#undef TRACE_SYSTEM
> > > +#define TRACE_SYSTEM ceph
> > > +
> > > +#if !defined(_CEPH_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
> > > +#define _CEPH_TRACE_H
> > > +
> > > +#include <linux/tracepoint.h>
> > > +#include <linux/trace_seq.h>
> > > +#include "super.h"
> > > +
> > > +const char *trace_ceph_cap_string(struct trace_seq *p, int caps);
> > > +#define show_caps(caps) ({ trace_ceph_cap_string(p, caps); })
> > > +
> > > +#define show_snapid(snap)    \
> > > +     __print_symbolic_u64(snap, {CEPH_NOSNAP, "NOSNAP" })
> > > +
> > > +DECLARE_EVENT_CLASS(ceph_cap_class,
> > > +     TP_PROTO(struct ceph_cap *cap),
> > > +     TP_ARGS(cap),
> > > +     TP_STRUCT__entry(
> > > +             __field(u64, ino)
> > > +             __field(u64, snap)
> > > +             __field(int, issued)
> > > +             __field(int, implemented)
> > > +             __field(int, mds)
> > > +             __field(int, mds_wanted)
> > > +     ),
> > > +     TP_fast_assign(
> > > +             __entry->ino = cap->ci->i_vino.ino;
> > > +             __entry->snap = cap->ci->i_vino.snap;
> > > +             __entry->issued = cap->issued;
> > > +             __entry->implemented = cap->implemented;
> > > +             __entry->mds = cap->mds;
> > > +             __entry->mds_wanted = cap->mds_wanted;
> > > +     ),
> > > +     TP_printk("ino=0x%llx snap=%s mds=%d issued=%s implemented=%s mds_wanted=%s",
> > > +             __entry->ino, show_snapid(__entry->snap), __entry->mds,
> > > +             show_caps(__entry->issued), show_caps(__entry->implemented),
> > > +             show_caps(__entry->mds_wanted))
> > > +)
> > > +
> > > +#define DEFINE_CEPH_CAP_EVENT(name)             \
> > > +DEFINE_EVENT(ceph_cap_class, ceph_##name,       \
> > > +     TP_PROTO(struct ceph_cap *cap),         \
> > > +     TP_ARGS(cap))
> > > +
> > > +DEFINE_CEPH_CAP_EVENT(add_cap);
> > > +DEFINE_CEPH_CAP_EVENT(remove_cap);
> > > +
> > > +#endif /* _CEPH_TRACE_H */
> > > +
> > > +#define TRACE_INCLUDE_PATH .
> > > +#define TRACE_INCLUDE_FILE trace
> > > +#include <trace/define_trace.h>
> > > diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_debug.h
> > > index d5a5da838caf..fa4a84e0e018 100644
> > > --- a/include/linux/ceph/ceph_debug.h
> > > +++ b/include/linux/ceph/ceph_debug.h
> > > @@ -2,6 +2,7 @@
> > >  #ifndef _FS_CEPH_DEBUG_H
> > >  #define _FS_CEPH_DEBUG_H
> > > 
> > > +#undef pr_fmt
> > >  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > > 
> > >  #include <linux/string.h>
> > 
> > Since the MDS async unlink code is still a WIP, I'm going to break out
> > this patch from the series and merge it separately. I'm finding this to
> > be pretty useful in tracking down cap handling issues in the kernel.
> > 
> > Let me know if anyone has objections.
> 
> I have a concern that this sets the precedent for segregating our
> debugging infrastructure into two silos: the existing douts based on
> pr_debug() and the new tracepoints.  I do agree that tracepoints are
> nicer, can be easily filtered, etc but I don't see an overwhelming
> reason for going with tracepoints here instead of amending one of the
> existing douts or adding a new one.
> 

Mainly I wanted to start moving away from printk debugging, as that can
have peformance impacts that can affect tight race conditions. It's
terribly frustrating to crank up some debugging to hunt down a race
condition only to find that it goes away when you do.

> On top of this there is the tracepoint ABI question.  This has been
> a recurring topic at a couple of recent kernel summits, with not much
> progress.  AFAIK this hasn't been an issue for individual filesystems,
> but probably still worth considering.
> 

Oh, I hadn't kept up with the controversy here. That's very much a fair
point. I'll do some more reading up on this to see what the current
state is. For now I'll go ahead and drop this patch from the testing
branch until we determine its fate.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

