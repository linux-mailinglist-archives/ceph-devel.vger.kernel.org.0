Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D115F88B59
	for <lists+ceph-devel@lfdr.de>; Sat, 10 Aug 2019 14:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbfHJM3I (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 10 Aug 2019 08:29:08 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42853 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfHJM3H (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 10 Aug 2019 08:29:07 -0400
Received: by mail-ot1-f68.google.com with SMTP id l15so143046772otn.9
        for <ceph-devel@vger.kernel.org>; Sat, 10 Aug 2019 05:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FZkB5xW1xfXMsy2KV0BaHxtN5dQ4VW6PxpMENS6k1hs=;
        b=qTgaMeLKWUMGikdC9iN0vHJwLk6PIjBl3M1SvStE+fLRnmdasA3LkyMQ3WYleLnPVQ
         JD2iwUZ4Baz4wCrMOpksNo9K8eneKZip6TnMRU0kw6gU7hAakj4WNm8IWslMfhJlf2ZS
         5aQvSfKrndZJiwYI+3j5r22/Y5kzDi+Xi+0yXQ5pHbv2/LIffKjJ82vv9e3lVNrjIac4
         36rNQh+tShKLgQaMX5Ve1QztcOZmPKfCEClv/dQ4pPP51lehXAzb0ZniJllZ5R6ZaDhp
         opmFDB1tf7x9qpjm/7xKBIgZ0IpEDxQPQBM6PTIviFA4DJT76y8+uAhNxXtB/pAkGEcd
         Flcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FZkB5xW1xfXMsy2KV0BaHxtN5dQ4VW6PxpMENS6k1hs=;
        b=PdcDNsbZtNAmqI0woxJGDv3fN9V5ZFvvK6boqh78E9X7pb4AH+gQX4Awe/Uq7glCPF
         KJwMvxeSsLY0nUEKXoTnc2x19IdFbdawpFV6VDJa5R1fpZYbDW3PmjKtr5Pp5ujXCB9G
         StXxpYns2sPzov4yXB5u6SnO7nTLigCXM5NTR1bPNx2nIkgZFtMFGHRNfxoqGFdOPdYv
         sAmfrqQlbxjuqN4TZcqw9ZYr5yQg9dEcQyMFiqJOEsBBOkj0bYBenpsuoL+GxJ8QTZ0l
         UDvsqY2EyOn6aYbk82N6Z2GzFDy8vG5vMNqVyxrj02dXwjn0AHp5aQZir0JuyPEMZtTt
         GvMA==
X-Gm-Message-State: APjAAAWXsrOlXrpVYFf8F43TzN8BPXyKzPTPnIC/fz3MZHbtYObeSk9C
        jfLGmU60UdT5o4T/LTteP2EFZ2eYHv7bX+k1dHk=
X-Google-Smtp-Source: APXvYqzztfnS2YCO4IkVFJGKJex7ldsimPtFarrz2QYSmtlb8q1jraq7ft+M/stz7MfQI4WdOKJb3rk9t2HceobpL9w=
X-Received: by 2002:a5e:d817:: with SMTP id l23mr25519921iok.282.1565440146594;
 Sat, 10 Aug 2019 05:29:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190801202605.18172-1-jlayton@kernel.org> <20190801202605.18172-9-jlayton@kernel.org>
 <1916bc5f2b96eab8556fa9154492fb8379447278.camel@kernel.org>
In-Reply-To: <1916bc5f2b96eab8556fa9154492fb8379447278.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Sat, 10 Aug 2019 14:32:03 +0200
Message-ID: <CAOi1vP9i_=WWbngP2=tONY+rTVSiC=4=qfmZbV25roDkVUYp5A@mail.gmail.com>
Subject: Re: [PATCH 8/9] ceph: new tracepoints when adding and removing caps
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <ukernel@gmail.com>, Sage Weil <sage@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Aug 9, 2019 at 7:21 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Thu, 2019-08-01 at 16:26 -0400, Jeff Layton wrote:
> > Add support for two new tracepoints surrounding the adding/updating and
> > removing of caps from the cache. To support this, we also add new functions
> > for printing cap strings a'la ceph_cap_string().
> >
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/Makefile                |  3 +-
> >  fs/ceph/caps.c                  |  4 ++
> >  fs/ceph/trace.c                 | 76 +++++++++++++++++++++++++++++++++
> >  fs/ceph/trace.h                 | 55 ++++++++++++++++++++++++
> >  include/linux/ceph/ceph_debug.h |  1 +
> >  5 files changed, 138 insertions(+), 1 deletion(-)
> >  create mode 100644 fs/ceph/trace.c
> >  create mode 100644 fs/ceph/trace.h
> >
> > diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
> > index a699e320393f..5148284f74a9 100644
> > --- a/fs/ceph/Makefile
> > +++ b/fs/ceph/Makefile
> > @@ -3,12 +3,13 @@
> >  # Makefile for CEPH filesystem.
> >  #
> >
> > +ccflags-y += -I$(src)        # needed for trace events
> >  obj-$(CONFIG_CEPH_FS) += ceph.o
> >
> >  ceph-y := super.o inode.o dir.o file.o locks.o addr.o ioctl.o \
> >       export.o caps.o snap.o xattr.o quota.o \
> >       mds_client.o mdsmap.o strings.o ceph_frag.o \
> > -     debugfs.o
> > +     debugfs.o trace.o
> >
> >  ceph-$(CONFIG_CEPH_FSCACHE) += cache.o
> >  ceph-$(CONFIG_CEPH_FS_POSIX_ACL) += acl.o
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index 9344e742397e..236d9c205e3d 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -13,6 +13,7 @@
> >  #include "super.h"
> >  #include "mds_client.h"
> >  #include "cache.h"
> > +#include "trace.h"
> >  #include <linux/ceph/decode.h>
> >  #include <linux/ceph/messenger.h>
> >
> > @@ -754,6 +755,8 @@ void ceph_add_cap(struct inode *inode,
> >       cap->mseq = mseq;
> >       cap->cap_gen = gen;
> >
> > +     trace_ceph_add_cap(cap);
> > +
> >       if (fmode >= 0)
> >               __ceph_get_fmode(ci, fmode);
> >  }
> > @@ -1078,6 +1081,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
> >       int removed = 0;
> >
> >       dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
> > +     trace_ceph_remove_cap(cap);
> >
> >       /* remove from session list */
> >       spin_lock(&session->s_cap_lock);
> > diff --git a/fs/ceph/trace.c b/fs/ceph/trace.c
> > new file mode 100644
> > index 000000000000..e082d4eb973f
> > --- /dev/null
> > +++ b/fs/ceph/trace.c
> > @@ -0,0 +1,76 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#define CREATE_TRACE_POINTS
> > +#include "trace.h"
> > +
> > +#define CEPH_CAP_BASE_MASK   (CEPH_CAP_GSHARED|CEPH_CAP_GEXCL)
> > +#define CEPH_CAP_FILE_MASK   (CEPH_CAP_GSHARED |     \
> > +                              CEPH_CAP_GEXCL |       \
> > +                              CEPH_CAP_GCACHE |      \
> > +                              CEPH_CAP_GRD |         \
> > +                              CEPH_CAP_GWR |         \
> > +                              CEPH_CAP_GBUFFER |     \
> > +                              CEPH_CAP_GWREXTEND |   \
> > +                              CEPH_CAP_GLAZYIO)
> > +
> > +static void
> > +trace_gcap_string(struct trace_seq *p, int c)
> > +{
> > +     if (c & CEPH_CAP_GSHARED)
> > +             trace_seq_putc(p, 's');
> > +     if (c & CEPH_CAP_GEXCL)
> > +             trace_seq_putc(p, 'x');
> > +     if (c & CEPH_CAP_GCACHE)
> > +             trace_seq_putc(p, 'c');
> > +     if (c & CEPH_CAP_GRD)
> > +             trace_seq_putc(p, 'r');
> > +     if (c & CEPH_CAP_GWR)
> > +             trace_seq_putc(p, 'w');
> > +     if (c & CEPH_CAP_GBUFFER)
> > +             trace_seq_putc(p, 'b');
> > +     if (c & CEPH_CAP_GWREXTEND)
> > +             trace_seq_putc(p, 'a');
> > +     if (c & CEPH_CAP_GLAZYIO)
> > +             trace_seq_putc(p, 'l');
> > +}
> > +
> > +const char *
> > +trace_ceph_cap_string(struct trace_seq *p, int caps)
> > +{
> > +     int c;
> > +     const char *ret = trace_seq_buffer_ptr(p);
> > +
> > +     if (caps == 0) {
> > +             trace_seq_putc(p, '-');
> > +             goto out;
> > +     }
> > +
> > +     if (caps & CEPH_CAP_PIN)
> > +             trace_seq_putc(p, 'p');
> > +
> > +     c = (caps >> CEPH_CAP_SAUTH) & CEPH_CAP_BASE_MASK;
> > +     if (c) {
> > +             trace_seq_putc(p, 'A');
> > +             trace_gcap_string(p, c);
> > +     }
> > +
> > +     c = (caps >> CEPH_CAP_SLINK) & CEPH_CAP_BASE_MASK;
> > +     if (c) {
> > +             trace_seq_putc(p, 'L');
> > +             trace_gcap_string(p, c);
> > +     }
> > +
> > +     c = (caps >> CEPH_CAP_SXATTR) & CEPH_CAP_BASE_MASK;
> > +     if (c) {
> > +             trace_seq_putc(p, 'X');
> > +             trace_gcap_string(p, c);
> > +     }
> > +
> > +     c = (caps >> CEPH_CAP_SFILE) & CEPH_CAP_FILE_MASK;
> > +     if (c) {
> > +             trace_seq_putc(p, 'F');
> > +             trace_gcap_string(p, c);
> > +     }
> > +out:
> > +     trace_seq_putc(p, '\0');
> > +     return ret;
> > +}
> > diff --git a/fs/ceph/trace.h b/fs/ceph/trace.h
> > new file mode 100644
> > index 000000000000..d1cf4bb8a21d
> > --- /dev/null
> > +++ b/fs/ceph/trace.h
> > @@ -0,0 +1,55 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#undef TRACE_SYSTEM
> > +#define TRACE_SYSTEM ceph
> > +
> > +#if !defined(_CEPH_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
> > +#define _CEPH_TRACE_H
> > +
> > +#include <linux/tracepoint.h>
> > +#include <linux/trace_seq.h>
> > +#include "super.h"
> > +
> > +const char *trace_ceph_cap_string(struct trace_seq *p, int caps);
> > +#define show_caps(caps) ({ trace_ceph_cap_string(p, caps); })
> > +
> > +#define show_snapid(snap)    \
> > +     __print_symbolic_u64(snap, {CEPH_NOSNAP, "NOSNAP" })
> > +
> > +DECLARE_EVENT_CLASS(ceph_cap_class,
> > +     TP_PROTO(struct ceph_cap *cap),
> > +     TP_ARGS(cap),
> > +     TP_STRUCT__entry(
> > +             __field(u64, ino)
> > +             __field(u64, snap)
> > +             __field(int, issued)
> > +             __field(int, implemented)
> > +             __field(int, mds)
> > +             __field(int, mds_wanted)
> > +     ),
> > +     TP_fast_assign(
> > +             __entry->ino = cap->ci->i_vino.ino;
> > +             __entry->snap = cap->ci->i_vino.snap;
> > +             __entry->issued = cap->issued;
> > +             __entry->implemented = cap->implemented;
> > +             __entry->mds = cap->mds;
> > +             __entry->mds_wanted = cap->mds_wanted;
> > +     ),
> > +     TP_printk("ino=0x%llx snap=%s mds=%d issued=%s implemented=%s mds_wanted=%s",
> > +             __entry->ino, show_snapid(__entry->snap), __entry->mds,
> > +             show_caps(__entry->issued), show_caps(__entry->implemented),
> > +             show_caps(__entry->mds_wanted))
> > +)
> > +
> > +#define DEFINE_CEPH_CAP_EVENT(name)             \
> > +DEFINE_EVENT(ceph_cap_class, ceph_##name,       \
> > +     TP_PROTO(struct ceph_cap *cap),         \
> > +     TP_ARGS(cap))
> > +
> > +DEFINE_CEPH_CAP_EVENT(add_cap);
> > +DEFINE_CEPH_CAP_EVENT(remove_cap);
> > +
> > +#endif /* _CEPH_TRACE_H */
> > +
> > +#define TRACE_INCLUDE_PATH .
> > +#define TRACE_INCLUDE_FILE trace
> > +#include <trace/define_trace.h>
> > diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_debug.h
> > index d5a5da838caf..fa4a84e0e018 100644
> > --- a/include/linux/ceph/ceph_debug.h
> > +++ b/include/linux/ceph/ceph_debug.h
> > @@ -2,6 +2,7 @@
> >  #ifndef _FS_CEPH_DEBUG_H
> >  #define _FS_CEPH_DEBUG_H
> >
> > +#undef pr_fmt
> >  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >
> >  #include <linux/string.h>
>
> Since the MDS async unlink code is still a WIP, I'm going to break out
> this patch from the series and merge it separately. I'm finding this to
> be pretty useful in tracking down cap handling issues in the kernel.
>
> Let me know if anyone has objections.

I have a concern that this sets the precedent for segregating our
debugging infrastructure into two silos: the existing douts based on
pr_debug() and the new tracepoints.  I do agree that tracepoints are
nicer, can be easily filtered, etc but I don't see an overwhelming
reason for going with tracepoints here instead of amending one of the
existing douts or adding a new one.

On top of this there is the tracepoint ABI question.  This has been
a recurring topic at a couple of recent kernel summits, with not much
progress.  AFAIK this hasn't been an issue for individual filesystems,
but probably still worth considering.

Thanks,

                Ilya
