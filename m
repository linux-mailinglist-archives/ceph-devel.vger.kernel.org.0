Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE4E3647F3
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Apr 2021 18:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbhDSQJt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Apr 2021 12:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhDSQJs (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 19 Apr 2021 12:09:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1C0F61354;
        Mon, 19 Apr 2021 16:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618848559;
        bh=MFAfKB7soiC3jRV6LP9MpOdQ4lj3aoiRHMdOIM6fC94=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QlKpaSyyGBLarSXhpJQi5vTT2s4CiWQ07BkslZS3ifzikjebofR8E3vsOl8iUmqbW
         x/O7B/6OprqcgURglNHM4P+6a8Dqj2jaUh4aKuzAr6Yw8OSk+p3wYEnqEXgS0IOOry
         m72my5cs9Y3P0ISfuY63po2DVjxjSQ7vE6AeuXf28yTl38SV++urRwbZdHTrh/OIRr
         PnkNeECA67WdIRMYb5tj+OVR9Na8CnqRnnf8NLu+oQlgoLfbdGTuaufO1Le82VjorW
         YaPDCRPERfAtGMBQ28CvUI515EbiVJ9aK/j0yzh7asdbAFTaI+IYCCCNitrtct4cfS
         LsoLzbPXJv6aw==
Message-ID: <02cc34a899aab7169ecfdc9b15bb5dcb3d19edd8.camel@kernel.org>
Subject: Re: [PATCH] ceph: make the lost+found dir accessible by kernel
 client
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ukernel@gmail.com,
        ceph-devel@vger.kernel.org
Date:   Mon, 19 Apr 2021 12:09:17 -0400
In-Reply-To: <20210419023237.1177430-1-xiubli@redhat.com>
References: <20210419023237.1177430-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-04-19 at 10:32 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Inode number 0x4 is reserved for the lost+found dir, and the app
> or test app need to access it.
> 
> URL: https://tracker.ceph.com/issues/50216
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/super.h              | 3 ++-
>  include/linux/ceph/ceph_fs.h | 7 ++++---
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 4808a1458c9b..0f38e6183ff0 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -542,7 +542,8 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
>  
> 
> 
> 
>  static inline bool ceph_vino_is_reserved(const struct ceph_vino vino)
>  {
> -	if (vino.ino < CEPH_INO_SYSTEM_BASE && vino.ino != CEPH_INO_ROOT) {
> +	if (vino.ino < CEPH_INO_SYSTEM_BASE && vino.ino != CEPH_INO_ROOT &&
> +	    vino.ino != CEPH_INO_LOST_AND_FOUND ) {
>  		WARN_RATELIMIT(1, "Attempt to access reserved inode number 0x%llx", vino.ino);
>  		return true;
>  	}
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index e41a811026f6..57e5bd63fb7a 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -27,9 +27,10 @@
>  #define CEPH_MONC_PROTOCOL   15 /* server/client */
>  
> 
> 
> 
>  
> 
> 
> 
> -#define CEPH_INO_ROOT   1
> -#define CEPH_INO_CEPH   2       /* hidden .ceph dir */
> -#define CEPH_INO_DOTDOT 3	/* used by ceph fuse for parent (..) */
> +#define CEPH_INO_ROOT           1
> +#define CEPH_INO_CEPH           2 /* hidden .ceph dir */
> +#define CEPH_INO_DOTDOT         3 /* used by ceph fuse for parent (..) */
> +#define CEPH_INO_LOST_AND_FOUND 4 /* lost+found dir */
>  
> 
> 
> 
>  /* arbitrary limit on max # of monitors (cluster of 3 is typical) */
>  #define CEPH_MAX_MON   31

Thanks Xiubo,

For some background, apparently cephfs-data-scan can create this
directory, and the clients do need access to it. I'll fold this into the
original patch that makes these inodes inaccessible (ceph: don't allow
access to MDS-private inodes).

Cheers!
-- 
Jeff Layton <jlayton@kernel.org>

