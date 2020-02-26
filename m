Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2D8616F5EF
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Feb 2020 04:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730228AbgBZDFh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Feb 2020 22:05:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727880AbgBZDFg (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 22:05:36 -0500
Received: from vulkan (unknown [4.28.11.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5D8821744;
        Wed, 26 Feb 2020 03:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582686336;
        bh=uVEjOOphXTnE6SIPjhBfacAI7LjN41gjFod5feeVYyI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dgZhlF4/zdrOdkG8R8C1odWnPLINt0QR09roTnhSkZ55XaYZhbBD5NXNlQlDyrCrf
         czOZ9i61TPDkoRa2vEXKjPAm1OODhIVIOH1zUWgxOdBk2J+O4Wegc7sMqPGXzfO4Hn
         EeZFrs8cOAucwQW7geLhoH41SpG+s2s9KtOvHY54=
Message-ID: <d1edfa6b2713b63d8f6832ebb376b60a22ee2f69.camel@kernel.org>
Subject: Re: [PATCH v8 2/5] ceph: add caps perf metric for each session
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Tue, 25 Feb 2020 19:05:33 -0800
In-Reply-To: <ff394699-2de4-c3ba-9b11-0730acf7d4df@redhat.com>
References: <20200221070556.18922-1-xiubli@redhat.com>
         <20200221070556.18922-3-xiubli@redhat.com>
         <a654d3d4765741594e9c49ef62ba1d0ab41e3960.camel@kernel.org>
         <ff394699-2de4-c3ba-9b11-0730acf7d4df@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2020-02-22 at 09:51 +0800, Xiubo Li wrote:
> On 2020/2/21 20:00, Jeff Layton wrote:
> > On Fri, 2020-02-21 at 02:05 -0500, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > This will fulfill the cap hit/mis metric stuff per-superblock,
> > > it will count the hit/mis counters based each inode, and if one
> > > inode's 'issued & ~revoking == mask' will mean a hit, or a miss.
> > > 
> > > item          total           miss            hit
> > > -------------------------------------------------
> > > caps          295             107             4119
> > > 
> > > URL: https://tracker.ceph.com/issues/43215
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/acl.c        |  2 +-
> > >   fs/ceph/caps.c       | 19 +++++++++++++++++++
> > >   fs/ceph/debugfs.c    | 16 ++++++++++++++++
> > >   fs/ceph/dir.c        |  5 +++--
> > >   fs/ceph/inode.c      |  4 ++--
> > >   fs/ceph/mds_client.c | 26 ++++++++++++++++++++++----
> > >   fs/ceph/metric.h     | 19 +++++++++++++++++++
> > >   fs/ceph/super.h      |  8 +++++---
> > >   fs/ceph/xattr.c      |  4 ++--
> > >   9 files changed, 89 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
> > > index 26be6520d3fb..e0465741c591 100644
> > > --- a/fs/ceph/acl.c
> > > +++ b/fs/ceph/acl.c
> > > @@ -22,7 +22,7 @@ static inline void ceph_set_cached_acl(struct inode *inode,
> > >   	struct ceph_inode_info *ci = ceph_inode(inode);
> > >   
> > >   	spin_lock(&ci->i_ceph_lock);
> > > -	if (__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0))
> > > +	if (__ceph_caps_issued_mask_metric(ci, CEPH_CAP_XATTR_SHARED, 0))
> > >   		set_cached_acl(inode, type, acl);
> > >   	else
> > >   		forget_cached_acl(inode, type);
> > nit: calling __ceph_caps_issued_mask_metric means that you have an extra
> > branch. One to set/forget acl and one to update the counter.
> > 
> > This would be (very slightly) more efficient if you just put the cap
> > hit/miss calls inside the existing if block above. IOW, you could just
> > do:
> > 
> > if (__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0)) {
> > 	set_cached_acl(inode, type, acl);
> > 	ceph_update_cap_hit(&fsc->mdsc->metric);
> > } else {
> > 	forget_cached_acl(inode, type);
> > 	ceph_update_cap_mis(&fsc->mdsc->metric);
> > }
> 
> Yeah, this will works well here.
> 
> 
> > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > > index ff1714fe03aa..227949c3deb8 100644
> > > --- a/fs/ceph/dir.c
> > > +++ b/fs/ceph/dir.c
> > > @@ -346,8 +346,9 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> > >   	    !ceph_test_mount_opt(fsc, NOASYNCREADDIR) &&
> > >   	    ceph_snap(inode) != CEPH_SNAPDIR &&
> > >   	    __ceph_dir_is_complete_ordered(ci) &&
> > > -	    __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1)) {
> > > +	    __ceph_caps_issued_mask_metric(ci, CEPH_CAP_FILE_SHARED, 1)) {
> > These could also just be cap_hit/mis calls inside the existing if
> > blocks.
> 
> Yeah, right in the if branch we can be sure that the 
> __ceph_caps_issued_mask() is called. But in the else branch we still 
> need to get the return value from (rc = __ceph_caps_issued_mask()), and 
> only when "rc == 0" cap_mis will need. This could simplify the code here 
> and below.
> 
> This is main reason to add the __ceph_caps_issued_mask_metric() here. 
> And if you do not like this approach I will switch it back :-)
> 

Ok, good point. Let's leave this one as-is.

-- 
Jeff Layton <jlayton@kernel.org>

