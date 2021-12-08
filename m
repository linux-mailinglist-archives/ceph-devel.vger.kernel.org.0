Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B5046DAF1
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Dec 2021 19:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238813AbhLHS0b (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Dec 2021 13:26:31 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41094 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhLHS0b (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Dec 2021 13:26:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CD93ACE2321
        for <ceph-devel@vger.kernel.org>; Wed,  8 Dec 2021 18:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA79C00446;
        Wed,  8 Dec 2021 18:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638987776;
        bh=TR2XHempXGB6m0CAz4wLZfXdLeCAq0Sjl6rDPJtrG4E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YUYvnuLaRpQYupMVYmojE5/Oh4/UokMEC/1NwbKkiCn0pAAmQ2t0dqAJsZJgvZt/y
         owcWEW+wqTkbKRLIUQQQDVLUIobVPTF6GJmq4hQIUI96nUUUdI6vV8Ugvg5qUweeBz
         13w5ZfADVggZJdyICB42Hfe0rwAgjYjJ2UyttPuKOQt0fVft6P/uc6/f1dtYms5+7C
         oeTRCPAJRsQimrr6p+KAhc8yT9PTf5P5dtAr6IJ6XH1fyiDWb4ifp+rDWp/8ZXdT0J
         MzRgPRbx7pkJo32nEmSNVU+qTs0aFwt0BseT3uO+PVZ93CiAGrGkmCm2pYnDzCy2Of
         Bvl+6C//N5CGw==
Message-ID: <dad48776c8037361451a0a82bc49f5435e34aaf7.camel@kernel.org>
Subject: Re: [PATCH v7 8/9] ceph: add object version support for sync read
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Wed, 08 Dec 2021 13:22:54 -0500
In-Reply-To: <2f46a421f943b5686ba175bd564821f39fb177d7.camel@kernel.org>
References: <20211208124528.679831-1-xiubli@redhat.com>
         <20211208124528.679831-2-xiubli@redhat.com>
         <2f46a421f943b5686ba175bd564821f39fb177d7.camel@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-12-08 at 10:33 -0500, Jeff Layton wrote:
> On Wed, 2021-12-08 at 20:45 +0800, xiubli@redhat.com wrote:
> > From: Xiubo Li <xiubli@redhat.com>
> > 
> > Always return the last object's version.
> > 
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >  fs/ceph/file.c  | 8 ++++++--
> >  fs/ceph/super.h | 3 ++-
> >  2 files changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index b42158c9aa16..9279b8642add 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -883,7 +883,8 @@ enum {
> >   * only return a short read to the caller if we hit EOF.
> >   */
> >  ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
> > -			 struct iov_iter *to, int *retry_op)
> > +			 struct iov_iter *to, int *retry_op,
> > +			 u64 *last_objver)
> >  {
> >  	struct ceph_inode_info *ci = ceph_inode(inode);
> >  	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> > @@ -950,6 +951,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
> >  					 req->r_end_latency,
> >  					 len, ret);
> >  
> > +		if (last_objver)
> > +			*last_objver = req->r_version;
> > +
> 
> Much better! That said, this might be unreliable if (say) the first OSD
> read was successful and then the second one failed on a long read that
> spans objects. We'd want to return a short read in that case, but the
> last_objver would end up being set to 0.
> 
> I think you shouldn't set last_objver unless the call is going to return
> > 0, and then you want to set it to the object version of the last
> successful read in the series.
> 
> 

Since this was a simple change, I went ahead and folded the patch below
into this patch and updated wip-fscrypt-size. Let me know if you have
any objections:

[PATCH] SQUASH: only set last_objver iff we're returning success

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 9279b8642add..ee6fb642cf05 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -893,6 +893,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 	u64 off = *ki_pos;
 	u64 len = iov_iter_count(to);
 	u64 i_size = i_size_read(inode);
+	u64 objver = 0;
 
 	dout("sync_read on inode %p %llu~%u\n", inode, *ki_pos, (unsigned)len);
 
@@ -951,9 +952,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 					 req->r_end_latency,
 					 len, ret);
 
-		if (last_objver)
-			*last_objver = req->r_version;
-
+		objver = req->r_version;
 		ceph_osdc_put_request(req);
 
 		i_size = i_size_read(inode);
@@ -1010,6 +1009,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		}
 	}
 
+	if (ret > 0)
+		*last_objver = objver;
+
 	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);
 	return ret;
 }
-- 
2.33.1


