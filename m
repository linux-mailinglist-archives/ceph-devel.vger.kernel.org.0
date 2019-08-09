Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51E208810D
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Aug 2019 19:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407554AbfHIRVu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Aug 2019 13:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbfHIRVt (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 13:21:49 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A5152085A;
        Fri,  9 Aug 2019 17:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565371308;
        bh=dXGZbWSL/O8HR2866L5gjTJY/Wr9aTRQzqnzv92eihU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eb8OIoZGDGqt08flK6LJ5SEcbIMjeWP9Swq24Hc3oON702nToChhcxv8MtG02bVwK
         jcmkzYMznnMXMgrWvDwGZSn4cWLzWi+ddPmxOf0rjFZOteMfZ9AbbdfzawRbppu8aJ
         X2SVIF48Q+JC16icBUC9GXqmc+ilebT//76s6nZg=
Message-ID: <1916bc5f2b96eab8556fa9154492fb8379447278.camel@kernel.org>
Subject: Re: [PATCH 8/9] ceph: new tracepoints when adding and removing caps
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com,
        pdonnell@redhat.com
Date:   Fri, 09 Aug 2019 13:21:46 -0400
In-Reply-To: <20190801202605.18172-9-jlayton@kernel.org>
References: <20190801202605.18172-1-jlayton@kernel.org>
         <20190801202605.18172-9-jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-08-01 at 16:26 -0400, Jeff Layton wrote:
> Add support for two new tracepoints surrounding the adding/updating and
> removing of caps from the cache. To support this, we also add new functions
> for printing cap strings a'la ceph_cap_string().
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/Makefile                |  3 +-
>  fs/ceph/caps.c                  |  4 ++
>  fs/ceph/trace.c                 | 76 +++++++++++++++++++++++++++++++++
>  fs/ceph/trace.h                 | 55 ++++++++++++++++++++++++
>  include/linux/ceph/ceph_debug.h |  1 +
>  5 files changed, 138 insertions(+), 1 deletion(-)
>  create mode 100644 fs/ceph/trace.c
>  create mode 100644 fs/ceph/trace.h
> 
> diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
> index a699e320393f..5148284f74a9 100644
> --- a/fs/ceph/Makefile
> +++ b/fs/ceph/Makefile
> @@ -3,12 +3,13 @@
>  # Makefile for CEPH filesystem.
>  #
>  
> +ccflags-y += -I$(src)	# needed for trace events
>  obj-$(CONFIG_CEPH_FS) += ceph.o
>  
>  ceph-y := super.o inode.o dir.o file.o locks.o addr.o ioctl.o \
>  	export.o caps.o snap.o xattr.o quota.o \
>  	mds_client.o mdsmap.o strings.o ceph_frag.o \
> -	debugfs.o
> +	debugfs.o trace.o
>  
>  ceph-$(CONFIG_CEPH_FSCACHE) += cache.o
>  ceph-$(CONFIG_CEPH_FS_POSIX_ACL) += acl.o
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 9344e742397e..236d9c205e3d 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -13,6 +13,7 @@
>  #include "super.h"
>  #include "mds_client.h"
>  #include "cache.h"
> +#include "trace.h"
>  #include <linux/ceph/decode.h>
>  #include <linux/ceph/messenger.h>
>  
> @@ -754,6 +755,8 @@ void ceph_add_cap(struct inode *inode,
>  	cap->mseq = mseq;
>  	cap->cap_gen = gen;
>  
> +	trace_ceph_add_cap(cap);
> +
>  	if (fmode >= 0)
>  		__ceph_get_fmode(ci, fmode);
>  }
> @@ -1078,6 +1081,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>  	int removed = 0;
>  
>  	dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
> +	trace_ceph_remove_cap(cap);
>  
>  	/* remove from session list */
>  	spin_lock(&session->s_cap_lock);
> diff --git a/fs/ceph/trace.c b/fs/ceph/trace.c
> new file mode 100644
> index 000000000000..e082d4eb973f
> --- /dev/null
> +++ b/fs/ceph/trace.c
> @@ -0,0 +1,76 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define CREATE_TRACE_POINTS
> +#include "trace.h"
> +
> +#define CEPH_CAP_BASE_MASK	(CEPH_CAP_GSHARED|CEPH_CAP_GEXCL)
> +#define CEPH_CAP_FILE_MASK	(CEPH_CAP_GSHARED |	\
> +				 CEPH_CAP_GEXCL |	\
> +				 CEPH_CAP_GCACHE |	\
> +				 CEPH_CAP_GRD |		\
> +				 CEPH_CAP_GWR |		\
> +				 CEPH_CAP_GBUFFER |	\
> +				 CEPH_CAP_GWREXTEND |	\
> +				 CEPH_CAP_GLAZYIO)
> +
> +static void
> +trace_gcap_string(struct trace_seq *p, int c)
> +{
> +	if (c & CEPH_CAP_GSHARED)
> +		trace_seq_putc(p, 's');
> +	if (c & CEPH_CAP_GEXCL)
> +		trace_seq_putc(p, 'x');
> +	if (c & CEPH_CAP_GCACHE)
> +		trace_seq_putc(p, 'c');
> +	if (c & CEPH_CAP_GRD)
> +		trace_seq_putc(p, 'r');
> +	if (c & CEPH_CAP_GWR)
> +		trace_seq_putc(p, 'w');
> +	if (c & CEPH_CAP_GBUFFER)
> +		trace_seq_putc(p, 'b');
> +	if (c & CEPH_CAP_GWREXTEND)
> +		trace_seq_putc(p, 'a');
> +	if (c & CEPH_CAP_GLAZYIO)
> +		trace_seq_putc(p, 'l');
> +}
> +
> +const char *
> +trace_ceph_cap_string(struct trace_seq *p, int caps)
> +{
> +	int c;
> +	const char *ret = trace_seq_buffer_ptr(p);
> +
> +	if (caps == 0) {
> +		trace_seq_putc(p, '-');
> +		goto out;
> +	}
> +
> +	if (caps & CEPH_CAP_PIN)
> +		trace_seq_putc(p, 'p');
> +
> +	c = (caps >> CEPH_CAP_SAUTH) & CEPH_CAP_BASE_MASK;
> +	if (c) {
> +		trace_seq_putc(p, 'A');
> +		trace_gcap_string(p, c);
> +	}
> +
> +	c = (caps >> CEPH_CAP_SLINK) & CEPH_CAP_BASE_MASK;
> +	if (c) {
> +		trace_seq_putc(p, 'L');
> +		trace_gcap_string(p, c);
> +	}
> +
> +	c = (caps >> CEPH_CAP_SXATTR) & CEPH_CAP_BASE_MASK;
> +	if (c) {
> +		trace_seq_putc(p, 'X');
> +		trace_gcap_string(p, c);
> +	}
> +
> +	c = (caps >> CEPH_CAP_SFILE) & CEPH_CAP_FILE_MASK;
> +	if (c) {
> +		trace_seq_putc(p, 'F');
> +		trace_gcap_string(p, c);
> +	}
> +out:
> +	trace_seq_putc(p, '\0');
> +	return ret;
> +}
> diff --git a/fs/ceph/trace.h b/fs/ceph/trace.h
> new file mode 100644
> index 000000000000..d1cf4bb8a21d
> --- /dev/null
> +++ b/fs/ceph/trace.h
> @@ -0,0 +1,55 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM ceph
> +
> +#if !defined(_CEPH_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _CEPH_TRACE_H
> +
> +#include <linux/tracepoint.h>
> +#include <linux/trace_seq.h>
> +#include "super.h"
> +
> +const char *trace_ceph_cap_string(struct trace_seq *p, int caps);
> +#define show_caps(caps) ({ trace_ceph_cap_string(p, caps); })
> +
> +#define show_snapid(snap)	\
> +	__print_symbolic_u64(snap, {CEPH_NOSNAP, "NOSNAP" })
> +
> +DECLARE_EVENT_CLASS(ceph_cap_class,
> +	TP_PROTO(struct ceph_cap *cap),
> +	TP_ARGS(cap),
> +	TP_STRUCT__entry(
> +		__field(u64, ino)
> +		__field(u64, snap)
> +		__field(int, issued)
> +		__field(int, implemented)
> +		__field(int, mds)
> +		__field(int, mds_wanted)
> +	),
> +	TP_fast_assign(
> +		__entry->ino = cap->ci->i_vino.ino;
> +		__entry->snap = cap->ci->i_vino.snap;
> +		__entry->issued = cap->issued;
> +		__entry->implemented = cap->implemented;
> +		__entry->mds = cap->mds;
> +		__entry->mds_wanted = cap->mds_wanted;
> +	),
> +	TP_printk("ino=0x%llx snap=%s mds=%d issued=%s implemented=%s mds_wanted=%s",
> +		__entry->ino, show_snapid(__entry->snap), __entry->mds,
> +		show_caps(__entry->issued), show_caps(__entry->implemented),
> +		show_caps(__entry->mds_wanted))
> +)
> +
> +#define DEFINE_CEPH_CAP_EVENT(name)             \
> +DEFINE_EVENT(ceph_cap_class, ceph_##name,       \
> +	TP_PROTO(struct ceph_cap *cap),		\
> +	TP_ARGS(cap))
> +
> +DEFINE_CEPH_CAP_EVENT(add_cap);
> +DEFINE_CEPH_CAP_EVENT(remove_cap);
> +
> +#endif /* _CEPH_TRACE_H */
> +
> +#define TRACE_INCLUDE_PATH .
> +#define TRACE_INCLUDE_FILE trace
> +#include <trace/define_trace.h>
> diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_debug.h
> index d5a5da838caf..fa4a84e0e018 100644
> --- a/include/linux/ceph/ceph_debug.h
> +++ b/include/linux/ceph/ceph_debug.h
> @@ -2,6 +2,7 @@
>  #ifndef _FS_CEPH_DEBUG_H
>  #define _FS_CEPH_DEBUG_H
>  
> +#undef pr_fmt
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
>  #include <linux/string.h>

Since the MDS async unlink code is still a WIP, I'm going to break out
this patch from the series and merge it separately. I'm finding this to
be pretty useful in tracking down cap handling issues in the kernel.

Let me know if anyone has objections.
-- 
Jeff Layton <jlayton@kernel.org>

