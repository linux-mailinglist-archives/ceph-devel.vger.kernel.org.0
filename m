Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F5C1A333
	for <lists+ceph-devel@lfdr.de>; Fri, 10 May 2019 20:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbfEJS6s (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 May 2019 14:58:48 -0400
Received: from hr2.samba.org ([144.76.82.148]:39736 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727535AbfEJS6s (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 10 May 2019 14:58:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42627210; h=Message-ID:Cc:To:From:Date;
        bh=SXQwq/lxjEyftqRPeFlGKG5dzdIeLJ3dX9ac3uychuw=; b=aVMkA2TDGI6lb+zkbKfxTuNMkd
        adY+5blc9tXouJo16kXY6cBH51ctAODQWH27kZydJtU/xUrVSDXvcps2yaGz3E3IyHXJdXLkZ1KXz
        IIoiulSpM1IapH5czFUb1b187WC10CPeR8yrOTK758aT1hPFmUWZVgw9ZLiL4ZkKohsk=;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1hPAjE-0007Tl-JG; Fri, 10 May 2019 18:58:44 +0000
Date:   Fri, 10 May 2019 11:58:41 -0700
From:   Jeremy Allison <jra@samba.org>
To:     David Disseldorp <ddiss@suse.de>
Cc:     Jeremy Allison via samba-technical 
        <samba-technical@lists.samba.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        jra@samba.org
Subject: Re: [PATCH] Samba: CephFS Snapshots VFS module
Message-ID: <20190510185841.GA54524@jra4>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20190329184531.0c78e06b@echidna.suse.de>
 <20190508224740.GA21367@jra4>
 <20190510151601.798bee61@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510151601.798bee61@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 10, 2019 at 03:16:01PM +0200, David Disseldorp wrote:
> On Wed, 8 May 2019 15:47:40 -0700, Jeremy Allison via samba-technical wrote:
> 
> > On Fri, Mar 29, 2019 at 06:45:31PM +0100, David Disseldorp via samba-technical wrote:
> > > 
> > > The attached patchset adds a new ceph_snapshots Samba VFS module which
> > > handles snapshot enumeration and timewarp/@GMT token mapping.
> > > 
> > > Feedback appreciated.  
> > 
> > Mostly looks good - a few comments inline below. Hope you don't think
> > I'm being too picky, push back if so. I really want this functionality, just
> > want to make sure I can maintain it going forward.
> 
> Thanks for the review, Jeremy. I've attached a V2 patchset with the
> changes below squashed in...

A couple of comments left (sorry) - in:

+static int ceph_snap_gmt_convert(struct vfs_handle_struct *handle,
+                                    const char *name,
+                                    time_t timestamp,
+                                    char *_converted_buf,
+                                    size_t buflen)

You have:

+       /*
+        * found snapshot via parent. Append the child path component
+        * that was trimmed... +1 for path separator.
+        */
+       if (strlen(_converted_buf) + 1 + strlen(trimmed) >= buflen) {
+               return -EINVAL;
+       }
+       strncat(_converted_buf, "/", buflen);
+       strncat(_converted_buf, trimmed, buflen);

strncat is potentially dangerous here as it doesn't zero-terminate
by default if there's no space. I'd be much happier with strlcat instead.

Having said that, and looking at the arithmetic carefully I *think* it's
safe as you exit on >= buflen. But I had to think
about it carefully in the review. I don't want
other people to have to do that :-).

Can you change the comment to be:

+       /*
+        * found snapshot via parent. Append the child path component
+        * that was trimmed... +1 for path separator + 1 for null termination.
+        */
+       if (strlen(_converted_buf) + 1 + strlen(trimmed) + 1 > buflen) {
+               return -EINVAL;
+       }

Just to use the expected idion of '>' rather than the rarer
'>=' when checking string overruns.

So the result would be:

+       /*
+        * found snapshot via parent. Append the child path component
+        * that was trimmed... +1 for path separator + 1 for null termination.
+        */
+       if (strlen(_converted_buf) + 1 + strlen(trimmed) + 1 > buflen) {
+               return -EINVAL;
+       }
+       strlcat(_converted_buf, "/", buflen);
+       strlcat(_converted_buf, trimmed, buflen);

Second comment - in ceph_snap_gmt_opendir() you do:

+       dir = SMB_VFS_NEXT_OPENDIR(handle, conv_smb_fname, mask, attr);
+       saved_errno = errno;
+       TALLOC_FREE(conv_smb_fname);
+       errno = saved_errno;
+       return dir;

- NB, you're saving errno and restoring over the TALLOC_FREE(conv_smb_fname);
I think that's the right thing to do (you never know
if TALLOC_FREE might do a syscall to overwrite errno).

I think you also need to do this in:

ceph_snap_gmt_unlink()
ceph_snap_gmt_chmod()
ceph_snap_gmt_chown()
ceph_snap_gmt_chdir()
ceph_snap_gmt_ntimes()
ceph_snap_gmt_readlink()
ceph_snap_gmt_mknod()
ceph_snap_gmt_realpath()
ceph_snap_gmt_mkdir()
ceph_snap_gmt_rmdir()
ceph_snap_gmt_chflags()
ceph_snap_gmt_getxattr()
ceph_snap_gmt_listxattr()
ceph_snap_gmt_removexattr()
ceph_snap_gmt_setxattr()
ceph_snap_gmt_disk_free()
ceph_snap_gmt_get_quota()

for consistency.

Sorry for being picky, but I think we're getting there !

Jeremy.
