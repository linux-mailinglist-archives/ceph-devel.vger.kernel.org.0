Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBAA24C733
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Aug 2020 23:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgHTVbB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Aug 2020 17:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgHTVbA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 20 Aug 2020 17:31:00 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 989B82076E;
        Thu, 20 Aug 2020 21:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597959059;
        bh=0m3kJKDl+90tStC1jWHdYAI2eddjB7Yb9p7PPMeCUzs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MoHq/+vT40HLeUutymiZJljXhIaUUBjyxrXPAwrJZjw+0UPxb1gQSU+4gmZLiSLRd
         ON6k9NN8/wEktznWxMDIWTr35yN8kPyGyCnAaIxyRCWJYn0keWJ+r/TdgFmXHDBmv5
         W1S39ntxhr7JEFdaeMjO4I5xglzvQ2k0VI+/2eL0=
Message-ID: <4429ff0fc03ced7ab7ecabeadda913b5a08d1684.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix inode number handling on arches with 32-bit
 ino_t
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     Ulrich.Weigand@de.ibm.com, Tuan.Hoang1@ibm.com, idryomov@gmail.com
Date:   Thu, 20 Aug 2020 17:30:57 -0400
In-Reply-To: <20200819151645.38951-1-jlayton@kernel.org>
References: <20200818162316.389462-1-jlayton@kernel.org>
         <20200819151645.38951-1-jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-08-19 at 11:16 -0400, Jeff Layton wrote:
> Tuan and Ulrich mentioned that they were hitting a problem on s390x,
> which has a 32-bit ino_t value, even though it's a 64-bit arch (for
> historical reasons).
> 
> I think the current handling of inode numbers in the ceph driver is
> wrong. It tries to use 32-bit inode numbers on 32-bit arches, but that's
> actually not a problem. 32-bit arches can deal with 64-bit inode numbers
> just fine when userland code is compiled with LFS support (the common
> case these days).
> 
> What we really want to do is just use 64-bit numbers everywhere, unless
> someone has mounted with the ino32 mount option. In that case, we want
> to ensure that we hash the inode number down to something that will fit
> in 32 bits before presenting the value to userland.
> 
> Add new helper functions that do this, and only do the conversion before
> presenting these values to userland in getattr and readdir.
> 
> The inode table hashvalue is changed to just cast the inode number to
> unsigned long, as low-order bits are the most likely to vary anyway.
> 
> While it's not strictly required, we do want to put something in
> inode->i_ino. Instead of basing it on BITS_PER_LONG, however, base it on
> the size of the ino_t type.
> 
> Reported-by: Tuan Hoang1 <Tuan.Hoang1@ibm.com>
> Reported-by: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
> URL: https://tracker.ceph.com/issues/46828
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c       | 14 ++++-----
>  fs/ceph/debugfs.c    |  4 +--
>  fs/ceph/dir.c        | 31 ++++++++-----------
>  fs/ceph/file.c       |  4 +--
>  fs/ceph/inode.c      | 19 ++++++------
>  fs/ceph/mds_client.h |  2 +-
>  fs/ceph/quota.c      |  4 +--
>  fs/ceph/super.h      | 73 +++++++++++++++++++++++---------------------
>  8 files changed, 74 insertions(+), 77 deletions(-)
> 
> v4:
> - flesh out comments in super.h
> - merge dout messages in ceph_get_inode
> - rename ceph_vino_to_ino to ceph_vino_to_ino_t
> 
> v3:
> - use ceph_ino instead of ceph_present_ino in most dout() messages
> 
> v2:
> - fix dir_emit inode number for ".."
> - fix ino_t size test
> 

FWIW, I built an i386 VM and ran a kernel with this patch through
xfstests and it seems to be ok.

To be clear though, this _will_ be a user-visible change on 32-bit
arches:

1/ inode numbers will be seen to have changed between kernel versions.
32-bit arches will see large inode numbers now instead of the hashed
ones they saw before.

2/ any really old software not built with LFS support may start failing
stat() calls with -EOVERFLOW on inode numbers >2^32. Nothing much we can
do about these, but hopefully the intersection of people running such
code on ceph will be very small.

The workaround for both problems will be to mount with "-o ino32".
-- 
Jeff Layton <jlayton@kernel.org>

