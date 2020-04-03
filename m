Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2925E19D4FA
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Apr 2020 12:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgDCKXU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 Apr 2020 06:23:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:56204 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbgDCKXU (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 3 Apr 2020 06:23:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 477F6ACB1;
        Fri,  3 Apr 2020 10:23:18 +0000 (UTC)
Received: from localhost (webern.olymp [local])
        by webern.olymp (OpenSMTPD) with ESMTPA id 03610e6e;
        Fri, 3 Apr 2020 11:23:17 +0100 (WEST)
Date:   Fri, 3 Apr 2020 11:23:17 +0100
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, ukernel@gmail.com, idryomov@gmail.com,
        sage@redhat.com, jfajerski@suse.com, gfarnum@redhat.com
Subject: Re: [PATCH v2 2/2] ceph: request expedited service on session's last
 cap flush
Message-ID: <20200403102317.GA1066@suse.com>
References: <20200402112911.17023-1-jlayton@kernel.org>
 <20200402112911.17023-3-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402112911.17023-3-jlayton@kernel.org>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Apr 02, 2020 at 07:29:11AM -0400, Jeff Layton wrote:
> When flushing a lot of caps to the MDS's at once (e.g. for syncfs),
> we can end up waiting a substantial amount of time for MDS replies, due
> to the fact that it may delay some of them so that it can batch them up
> together in a single journal transaction. This can lead to stalls when
> calling sync or syncfs.
> 
> What we'd really like to do is request expedited service on the _last_
> cap we're flushing back to the server. If the CHECK_CAPS_FLUSH flag is
> set on the request and the current inode was the last one on the
> session->s_cap_dirty list, then mark the request with
> CEPH_CLIENT_CAPS_SYNC.
> 
> Note that this heuristic is not perfect. New inodes can race onto the
> list after we've started flushing, but it does seem to fix some common
> use cases.
> 
> Reported-by: Jan Fajerski <jfajerski@suse.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 95c9b25e45a6..3630f05993b3 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1987,6 +1987,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>  	}
>  
>  	for (p = rb_first(&ci->i_caps); p; p = rb_next(p)) {
> +		int mflags = 0;
>  		struct cap_msg_args arg;
>  
>  		cap = rb_entry(p, struct ceph_cap, ci_node);
> @@ -2118,6 +2119,9 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>  			flushing = ci->i_dirty_caps;
>  			flush_tid = __mark_caps_flushing(inode, session, false,
>  							 &oldest_flush_tid);
> +			if (flags & CHECK_CAPS_FLUSH &&
> +			    list_empty(&session->s_cap_dirty))
> +				mflags |= CEPH_CLIENT_CAPS_SYNC;
>  		} else {
>  			flushing = 0;
>  			flush_tid = 0;
> @@ -2128,8 +2132,8 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>  
>  		mds = cap->mds;  /* remember mds, so we don't repeat */
>  
> -		__prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE, 0, cap_used, want,
> -			   retain, flushing, flush_tid, oldest_flush_tid);
> +		__prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE, mflags, cap_used,
> +			   want, retain, flushing, flush_tid, oldest_flush_tid);
>  		spin_unlock(&ci->i_ceph_lock);
>  
>  		__send_cap(mdsc, &arg, ci);
> -- 
> 2.25.1
> 

FWIW, it looks good to me.  I've also tested it and I confirm it improves
(a lot!) the testcase reported by Jan.  Maybe it's worth adding the URL to
the tracker.

Cheers,
--
Luis
