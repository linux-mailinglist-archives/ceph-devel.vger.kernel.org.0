Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C90F17A8E1
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Mar 2020 16:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgCEPcW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Mar 2020 10:32:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:57142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbgCEPcW (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 10:32:22 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8418E208CD;
        Thu,  5 Mar 2020 15:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583422341;
        bh=lZ6754XB+jVEemkcKqvJ7qsgXHeetFAsFoczQGwiUyI=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=cLpdk5VFrP8UvBfm1gpOulNAnmqAlD6J7PO1hIKvYgjfjVmyewAyEuLvpzRC4NBMq
         jfvqtLGwP/MHL0F9GjTnkGIGMHOS/NkcQ2ehn9+FL5YbfOMUZYZGhZT8ep1IEdJzbj
         tGXMcCnin9kQssJ58WlIYGm6LUpXNcKZ2PMz2tjM=
Message-ID: <6bc88d487b99ec0cb2721151a706242d9c213dfd.camel@kernel.org>
Subject: Re: [PATCH v5 0/7] ceph: don't request caps for idle open files
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Date:   Thu, 05 Mar 2020 10:32:20 -0500
In-Reply-To: <20200305122105.69184-1-zyan@redhat.com>
References: <20200305122105.69184-1-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-03-05 at 20:20 +0800, Yan, Zheng wrote:
> This series make cephfs client not request caps for open files that
> idle for a long time. For the case that one active client and multiple
> standby clients open the same file, this increase the possibility that
> mds issues exclusive caps to the active client.
> 
> Yan, Zheng (7):
>   ceph: always renew caps if mds_wanted is insufficient
>   ceph: consider inode's last read/write when calculating wanted caps
>   ceph: remove delay check logic from ceph_check_caps()
>   ceph: simplify calling of ceph_get_fmode()
>   ceph: update i_requested_max_size only when sending cap msg to auth mds
>   ceph: check all mds' caps after page writeback
>   ceph: calculate dir's wanted caps according to recent dirops
> 
>  fs/ceph/caps.c               | 360 ++++++++++++++++-------------------
>  fs/ceph/dir.c                |  21 +-
>  fs/ceph/file.c               |  45 ++---
>  fs/ceph/inode.c              |  21 +-
>  fs/ceph/ioctl.c              |   2 +
>  fs/ceph/mds_client.c         |  16 +-
>  fs/ceph/super.h              |  37 ++--
>  include/linux/ceph/ceph_fs.h |   1 +
>  8 files changed, 243 insertions(+), 260 deletions(-)
> 
> changes since v2
>  - make __ceph_caps_file_wanted() more readable
>  - add patch 5 and 6, which fix hung write during testing patch 1~4
> 
> changes since v3
>  - don't queue delayed cap check for snap inode
>  - initialize ci->{last_rd,last_wr} to jiffies - 3600 * HZ
>  - make __ceph_caps_file_wanted() check inode type
> 
> changes since v4
>  - add patch 7, improve how to calculate dir's wanted caps
> 

Thanks Zheng. This one seems to work just fine. Merged into ceph-
client/testing branch with the following changes:

- squashed patch 7 into patch 2
- cleaned up a few changelog grammatical and spelling errors
- fix a small bit of whitespace damage

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

