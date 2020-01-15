Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 525F413CEEF
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2020 22:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbgAOVaF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 Jan 2020 16:30:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbgAOVaF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 16:30:05 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E4512081E;
        Wed, 15 Jan 2020 21:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579123805;
        bh=7C8BqFEXjndvZbz+8Y7jOBFn6F2/J59Sk/o3DKK0nY0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NHHxm5GpjAD/51kemFsjIMxN+8Ei+5afL6IGyy7mRQ9bI9y8LkoEPdWB8m7TLk8s6
         7Zj2Ol3iwGCvTVOrRR/gGB5kBBszlvbXs2rIrDBJdCYmMIr1lnSIvFPcWY9PNPsO0Z
         6w7MJEJOIStJS4KgVeRqgOn8UkottsYtHfEGcfv4=
Message-ID: <777c555ac651ac7ad2d7d6514dfa54f0f51a82d9.camel@kernel.org>
Subject: Re: [RFC PATCH v2 00/10] ceph: asynchronous file create support
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com,
        pdonnell@redhat.com, xiubli@redhat.com
Date:   Wed, 15 Jan 2020 16:30:03 -0500
In-Reply-To: <20200115205912.38688-1-jlayton@kernel.org>
References: <20200115205912.38688-1-jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-01-15 at 15:59 -0500, Jeff Layton wrote:
> v2:
> - move cached layout to dedicated field in inode
> - protect cached layout with i_ceph_lock
> - wipe cached layout in __check_cap_issue
> - set max_size of file to layout.stripe_unit
> - set truncate_size to (u64)-1
> - use dedicated CephFS feature bit instead of CEPHFS_FEATURE_OCTOPUS
> - set cap_id to 1 in async created inode
> - allocate inode number before submitting request
> - rework the prep for an async create to be more efficient
> - don't allow MDS or cap messages involving an inode until we get async
>   create reply
> 
> A lot of changes in this set, mostly based on Zheng and Xiubo's
> comments. Performance is pretty similar to the previous set:
> 
> Untarring a kernel tarball into a cephfs takes about 98s with
> async dirops disabled. With them enabled, it takes around 78s,
> which is about a 25% improvement.
> 
> This is not quite ready for merge. Error handling could still be
> improved. With xfstest generic/531, I see some messages like this pop
> up in the ring buffer:
> 
>     [ 7331.393110] ceph: ceph_async_create_cb: inode number mismatch! err=0 deleg_ino=0x100001232d9 target=0x100001232b9
> 
> Basically, we went to do an async create and got a different inode
> number back than expected. That still needs investigation, but I
> didn't see any test failures due to it.
> 
> Jeff Layton (10):
>   libceph: export ceph_file_layout_is_valid
>   ceph: make ceph_fill_inode non-static
>   ceph: make dentry_lease_is_valid non-static
>   ceph: make __take_cap_refs a public function
>   ceph: decode interval_sets for delegated inos
>   ceph: add flag to designate that a request is asynchronous
>   ceph: add infrastructure for waiting for async create to complete
>   ceph: add new MDS req field to hold delegated inode number
>   ceph: cache layout in parent dir on first sync create
>   ceph: attempt to do async create when possible
> 
>  fs/ceph/caps.c               |  34 ++++--
>  fs/ceph/dir.c                |  13 ++-
>  fs/ceph/file.c               | 218 +++++++++++++++++++++++++++++++++--
>  fs/ceph/inode.c              |  50 ++++----
>  fs/ceph/mds_client.c         | 126 ++++++++++++++++++--
>  fs/ceph/mds_client.h         |   9 +-
>  fs/ceph/super.h              |  16 ++-
>  include/linux/ceph/ceph_fs.h |   8 +-
>  net/ceph/ceph_fs.c           |   1 +
>  9 files changed, 410 insertions(+), 65 deletions(-)
> 

I forgot to mention that I went ahead and merged a few patches from the
first pile into testing, so this series is based on top of
ceph-client/testing as of today.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

