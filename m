Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B937E1997A7
	for <lists+ceph-devel@lfdr.de>; Tue, 31 Mar 2020 15:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730961AbgCaNh7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 31 Mar 2020 09:37:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:54332 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730851AbgCaNh7 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 31 Mar 2020 09:37:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CB28EAC92;
        Tue, 31 Mar 2020 13:37:57 +0000 (UTC)
Received: from localhost (webern.olymp [local])
        by webern.olymp (OpenSMTPD) with ESMTPA id f350ea60;
        Tue, 31 Mar 2020 14:37:56 +0100 (WEST)
Date:   Tue, 31 Mar 2020 14:37:56 +0100
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, ukernel@gmail.com, idryomov@gmail.com,
        sage@redhat.com, jfajerski@suse.com
Subject: Re: [PATCH] ceph: request expedited service when flushing caps
Message-ID: <20200331133756.GA67759@suse.com>
References: <20200331105223.9610-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331105223.9610-1-jlayton@kernel.org>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Mar 31, 2020 at 06:52:23AM -0400, Jeff Layton wrote:
> Jan noticed some long stalls when flushing caps using sync() after
> doing small file creates. For instance, running this:
> 
>     $ time for i in $(seq -w 11 30); do echo "Hello World" > hello-$i.txt; sync -f ./hello-$i.txt; done
> 
> Could take more than 90s in some cases. The sync() will flush out caps,
> but doesn't tell the MDS that it's waiting synchronously on the
> replies.
> 
> When ceph_check_caps finds that CHECK_CAPS_FLUSH is set, then set the
> CEPH_CLIENT_CAPS_SYNC bit in the cap update request. This clues the MDS
> into that fact and it can then expedite the reply.
> 
> URL: https://tracker.ceph.com/issues/44744
> Reported-and-Tested-by: Jan Fajerski <jfajerski@suse.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Feel free to add my Reviewed-by (and also tested).  Also, it may be worth
adding a stable tag for this patch, although it would require some
massaging to use __send_cap instead of __prep_cap.

Cheers,
--
Luis

> ---
>  fs/ceph/caps.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 61808793e0c0..6403178f2376 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2111,8 +2111,11 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>  
>  		mds = cap->mds;  /* remember mds, so we don't repeat */
>  
> -		__prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE, 0, cap_used, want,
> -			   retain, flushing, flush_tid, oldest_flush_tid);
> +		__prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE,
> +			   (flags & CHECK_CAPS_FLUSH) ?
> +			    CEPH_CLIENT_CAPS_SYNC : 0,
> +			   cap_used, want, retain, flushing, flush_tid,
> +			   oldest_flush_tid);
>  		spin_unlock(&ci->i_ceph_lock);
>  
>  		__send_cap(mdsc, &arg, ci);
> -- 
> 2.25.1
> 
