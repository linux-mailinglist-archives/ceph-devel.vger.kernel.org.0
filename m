Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868AE365941
	for <lists+ceph-devel@lfdr.de>; Tue, 20 Apr 2021 14:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbhDTMvs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 20 Apr 2021 08:51:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232241AbhDTMvp (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 20 Apr 2021 08:51:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F7B8613C5;
        Tue, 20 Apr 2021 12:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618923072;
        bh=umQhLK1orPghEroR5WV4ValOvGv8AW01JuWC93mmS8I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LlhRvcSBJsz+7S6WEDurYisg4VUxaNdQl5Zb4alTKA6sO2Bnlki07gbMlxhpX9aYm
         fjpbyohjNv0u8lRtkDImcqXM0XZB4nLOJxpRHl8CGXXNO7S3wvhnMEYNlI/GHOdBL3
         sVeGdlUCB0U0f/pxMB5ltOMIzGOS7FtnyiRS4zbUA6Jzg5CBBzXwADGC8I/92lfGSE
         ofu5PAXoAdzhY7gXsy1RN7K3kQbLwLHuICWM90FF9M0V4Vv9KYOH9qHexNbtQsGL6A
         BKOW3wMUkLv0SCyiLYL5znhsLZwKYTwbecW2sZN3ApfwjE7DMOrYi28sDK2SM4o5e1
         fFDwRGHaszS6A==
Message-ID: <d42cceede1969f4542e01841bd1b2c6b17bc9aa3.camel@kernel.org>
Subject: Re: [PATCH] ceph: make the lost+found dir accessible by kernel
 client
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ukernel@gmail.com,
        ceph-devel@vger.kernel.org
Date:   Tue, 20 Apr 2021 08:51:11 -0400
In-Reply-To: <294a5c31-f40c-b424-0497-6737c5cd583d@redhat.com>
References: <20210419023237.1177430-1-xiubli@redhat.com>
         <02cc34a899aab7169ecfdc9b15bb5dcb3d19edd8.camel@kernel.org>
         <294a5c31-f40c-b424-0497-6737c5cd583d@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-04-20 at 10:02 +0800, Xiubo Li wrote:
> On 2021/4/20 0:09, Jeff Layton wrote:
> > On Mon, 2021-04-19 at 10:32 +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > Inode number 0x4 is reserved for the lost+found dir, and the app
> > > or test app need to access it.
> > > 
> > > URL: https://tracker.ceph.com/issues/50216
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/super.h              | 3 ++-
> > >   include/linux/ceph/ceph_fs.h | 7 ++++---
> > >   2 files changed, 6 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > > index 4808a1458c9b..0f38e6183ff0 100644
> > > --- a/fs/ceph/super.h
> > > +++ b/fs/ceph/super.h
> > > @@ -542,7 +542,8 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
> > >   
> > > 
> > > 
> > > 
> > >   static inline bool ceph_vino_is_reserved(const struct ceph_vino vino)
> > >   {
> > > -	if (vino.ino < CEPH_INO_SYSTEM_BASE && vino.ino != CEPH_INO_ROOT) {
> > > +	if (vino.ino < CEPH_INO_SYSTEM_BASE && vino.ino != CEPH_INO_ROOT &&
> > > +	    vino.ino != CEPH_INO_LOST_AND_FOUND ) {
> > >   		WARN_RATELIMIT(1, "Attempt to access reserved inode number 0x%llx", vino.ino);
> > >   		return true;
> > >   	}
> > > diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> > > index e41a811026f6..57e5bd63fb7a 100644
> > > --- a/include/linux/ceph/ceph_fs.h
> > > +++ b/include/linux/ceph/ceph_fs.h
> > > @@ -27,9 +27,10 @@
> > >   #define CEPH_MONC_PROTOCOL   15 /* server/client */
> > >   
> > > 
> > > 
> > > 
> > >   
> > > 
> > > 
> > > 
> > > -#define CEPH_INO_ROOT   1
> > > -#define CEPH_INO_CEPH   2       /* hidden .ceph dir */
> > > -#define CEPH_INO_DOTDOT 3	/* used by ceph fuse for parent (..) */
> 
> Hi Jeff,
> 
> Please fix the "CEPH_INO_DOTDOT" when you folding this patch. The inode 
> number 3 is not _DOTDOT any more. This was introduced by an very old 
> commit(dd6f5e105d85e) but I couldn't find the related change about this 
> in ceph code.
> 
> It should be:
> 
> #define CEPH_INO_GLOBAL_SNAPREALM 3
> 
> 
Sounds good. I can fold that change into the patch.

What should we use for a comment there? I took a look at the MDS code
and it wasn't clear to me what the global_snaprealm is actually for...

> > > +#define CEPH_INO_ROOT           1
> > > +#define CEPH_INO_CEPH           2 /* hidden .ceph dir */
> > > +#define CEPH_INO_DOTDOT         3 /* used by ceph fuse for parent (..) */
> > > +#define CEPH_INO_LOST_AND_FOUND 4 /* lost+found dir */
> > >   
> > > 
> > > 
> > > 
> > >   /* arbitrary limit on max # of monitors (cluster of 3 is typical) */
> > >   #define CEPH_MAX_MON   31
> > Thanks Xiubo,
> > 
> > For some background, apparently cephfs-data-scan can create this
> > directory, and the clients do need access to it. I'll fold this into the
> > original patch that makes these inodes inaccessible (ceph: don't allow
> > access to MDS-private inodes).
> > 
> > Cheers!
> 
> 

-- 
Jeff Layton <jlayton@kernel.org>

