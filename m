Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D9C16805F
	for <lists+ceph-devel@lfdr.de>; Fri, 21 Feb 2020 15:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgBUOfD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Feb 2020 09:35:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727096AbgBUOfD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 09:35:03 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14143222C4;
        Fri, 21 Feb 2020 14:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582295702;
        bh=MTcTa1XA0kqgXhJGTqaKg6rfu1UcVD1cVvumaGAKFsk=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=biOWVeUqSf4S7xB+qgG3Zj4fUNz4aUnwxmt1I28wpw/mZDN+1pgkQWsuNYnZ+TX4J
         /T/ps+/B8fL3w1ofpVo4V+B3we/B6oKsCsbkB6f+hhHOvjz+QZvOZPkViviQq+PA9S
         MX+yFcve10J2dBILVVzYQE3NUg6aU5X7p53o6Q9g=
Message-ID: <21448792f55a51f2b5b0652390ec6e04cbd311af.camel@kernel.org>
Subject: Re: [PATCH v2 2/4] ceph: consider inode's last read/write when
 calculating wanted caps
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Date:   Fri, 21 Feb 2020 09:35:00 -0500
In-Reply-To: <1d77fa7876ba37df07c3a8c9dc4c3d8ce4f2538d.camel@kernel.org>
References: <20200221131659.87777-1-zyan@redhat.com>
         <20200221131659.87777-3-zyan@redhat.com>
         <1d77fa7876ba37df07c3a8c9dc4c3d8ce4f2538d.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-02-21 at 09:27 -0500, Jeff Layton wrote:
> On Fri, 2020-02-21 at 21:16 +0800, Yan, Zheng wrote:
> > Add i_last_rd and i_last_wr to ceph_inode_info. These two fields are
> > used to track inode's last read/write, they are updated when getting
> > caps for read/write.
> > 
> > If there is no read/write on an inode for 'caps_wanted_delay_max'
> > seconds, __ceph_caps_file_wanted() does not request caps for read/write
> > even there are open files.
> > 
> > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > ---
> >  fs/ceph/caps.c               | 152 ++++++++++++++++++++++++-----------
> >  fs/ceph/file.c               |  21 ++---
> >  fs/ceph/inode.c              |  10 ++-
> >  fs/ceph/ioctl.c              |   2 +
> >  fs/ceph/super.h              |  13 ++-
> >  include/linux/ceph/ceph_fs.h |   1 +
> >  6 files changed, 139 insertions(+), 60 deletions(-)
> > 
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index 293920d013ff..2a9df235286d 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -971,18 +971,49 @@ int __ceph_caps_used(struct ceph_inode_info *ci)
> >  	return used;
> >  }
> >  
> > +#define FMODE_WAIT_BIAS 1000
> > +
> >  /*
> >   * wanted, by virtue of open file modes
> >   */
> >  int __ceph_caps_file_wanted(struct ceph_inode_info *ci)
> >  {
> > -	int i, bits = 0;
> > -	for (i = 0; i < CEPH_FILE_MODE_BITS; i++) {
> > -		if (ci->i_nr_by_mode[i])
> > -			bits |= 1 << i;
> > +	struct ceph_mount_options *opt =
> > +		ceph_inode_to_client(&ci->vfs_inode)->mount_options;
> > +	unsigned long used_cutoff =
> > +		round_jiffies(jiffies - opt->caps_wanted_delay_max * HZ);
> > +	unsigned long idle_cutoff =
> > +		round_jiffies(jiffies - opt->caps_wanted_delay_min * HZ);
> > +	int bits = 0;
> > +
> > +	if (ci->i_nr_by_mode[0] > 0)
> > +		bits |= CEPH_FILE_MODE_PIN;
> > +
> > +	if (ci->i_nr_by_mode[1] > 0) {
> > +		if (ci->i_nr_by_mode[1] >= FMODE_WAIT_BIAS ||
> > +		    time_after(ci->i_last_rd, used_cutoff))
> > +			bits |= CEPH_FILE_MODE_RD;
> > +	} else if (time_after(ci->i_last_rd, idle_cutoff)) {
> > +		bits |= CEPH_FILE_MODE_RD;
> > +	}
> > +
> > +	if (ci->i_nr_by_mode[2] > 0) {
> > +		if (ci->i_nr_by_mode[2] >= FMODE_WAIT_BIAS ||
> > +		    time_after(ci->i_last_wr, used_cutoff))
> > +			bits |= CEPH_FILE_MODE_WR;
> > +	} else if (time_after(ci->i_last_wr, idle_cutoff)) {
> > +		bits |= CEPH_FILE_MODE_WR;
> >  	}
> > +
> > +	/* check lazyio only when read/write is wanted */
> > +	if ((bits & CEPH_FILE_MODE_RDWR) && ci->i_nr_by_mode[3] > 0)
> 
> LAZY is 4. Shouldn't this be?
> 
>     if ((bits & CEPH_FILE_MODE_RDWR) && ci->i_nr_by_mode[CEPH_FILE_MODE_LAZY] > 0)
> 

Nope, that value was right, but I think we should phrase this in terms
of symbolic constants. Maybe we can squash this patch into your series?

-----------------------8<-----------------------

[PATCH] SQUASH: use symbolic constants in __ceph_caps_file_wanted()

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index ad365cf870f6..1b450f2195fe 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -971,19 +971,19 @@ int __ceph_caps_file_wanted(struct ceph_inode_info *ci)
 		round_jiffies(jiffies - opt->caps_wanted_delay_min * HZ);
 	int bits = 0;
 
-	if (ci->i_nr_by_mode[0] > 0)
+	if (ci->i_nr_by_mode[CEPH_FILE_MODE_PIN] > 0)
 		bits |= CEPH_FILE_MODE_PIN;
 
-	if (ci->i_nr_by_mode[1] > 0) {
-		if (ci->i_nr_by_mode[1] >= FMODE_WAIT_BIAS ||
+	if (ci->i_nr_by_mode[CEPH_FILE_MODE_RD] > 0) {
+		if (ci->i_nr_by_mode[CEPH_FILE_MODE_RD] >= FMODE_WAIT_BIAS ||
 		    time_after(ci->i_last_rd, used_cutoff))
 			bits |= CEPH_FILE_MODE_RD;
 	} else if (time_after(ci->i_last_rd, idle_cutoff)) {
 		bits |= CEPH_FILE_MODE_RD;
 	}
 
-	if (ci->i_nr_by_mode[2] > 0) {
-		if (ci->i_nr_by_mode[2] >= FMODE_WAIT_BIAS ||
+	if (ci->i_nr_by_mode[CEPH_FILE_MODE_WR] > 0) {
+		if (ci->i_nr_by_mode[CEPH_FILE_MODE_WR] >= FMODE_WAIT_BIAS ||
 		    time_after(ci->i_last_wr, used_cutoff))
 			bits |= CEPH_FILE_MODE_WR;
 	} else if (time_after(ci->i_last_wr, idle_cutoff)) {
@@ -991,12 +991,13 @@ int __ceph_caps_file_wanted(struct ceph_inode_info *ci)
 	}
 
 	/* check lazyio only when read/write is wanted */
-	if ((bits & CEPH_FILE_MODE_RDWR) && ci->i_nr_by_mode[3] > 0)
+	if ((bits & CEPH_FILE_MODE_RDWR) &&
+	    ci->i_nr_by_mode[ffs(CEPH_FILE_MODE_LAZY)] > 0)
 		bits |= CEPH_FILE_MODE_LAZY;
 
 	if (bits == 0)
 		return 0;
-	if (bits == 1 && !S_ISDIR(ci->vfs_inode.i_mode))
+	if (bits == (1 << CEPH_FILE_MODE_PIN) && !S_ISDIR(ci->vfs_inode.i_mode))
 		return 0;
 
 	return ceph_caps_for_mode(bits >> 1);
-- 
2.24.1


