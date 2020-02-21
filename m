Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACF5B167FA3
	for <lists+ceph-devel@lfdr.de>; Fri, 21 Feb 2020 15:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgBUOIH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Feb 2020 09:08:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:35840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbgBUOIH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 09:08:07 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6F5B2073A;
        Fri, 21 Feb 2020 14:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582294087;
        bh=CypiA/vn3I9WbBU1l7kiIL90uJuh0I3XJXWVSJZYjjU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Farj8gkQ1l/ND/uM4fjInv7N8d39xBJqAdsPm7eHkoWJ+AuOzuPC1JVpASl2VMKKX
         /k7pM08UBEYAGMIntjyImIeq73emjm7Z2hs90mLGKQogz2yB/UUjrk0YP0S4sAtSfe
         H8FeKkFYeQPtz6CJcbhm4jj4f4Soowb8Z6W3cBeo=
Message-ID: <32d80496ed9aa08bcda5a64dca59b3f1139b4331.camel@kernel.org>
Subject: Re: [PATCH v2 0/4] ceph: don't request caps for idle open files
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 21 Feb 2020 09:08:05 -0500
In-Reply-To: <20200221131659.87777-1-zyan@redhat.com>
References: <20200221131659.87777-1-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-02-21 at 21:16 +0800, Yan, Zheng wrote:
> This series make cephfs client not request caps for open files that
> idle for a long time. For the case that one active client and multiple
> standby clients open the same file, this increase the possibility that
> mds issues exclusive caps to the active client.
> 
> Yan, Zheng (4):
>   ceph: always renew caps if mds_wanted is insufficient
>   ceph: consider inode's last read/write when calculating wanted caps
>   ceph: simplify calling of ceph_get_fmode()
>   ceph: remove delay check logic from ceph_check_caps()
> 
>  fs/ceph/caps.c               | 324 +++++++++++++++--------------------
>  fs/ceph/file.c               |  39 ++---
>  fs/ceph/inode.c              |  19 +-
>  fs/ceph/ioctl.c              |   2 +
>  fs/ceph/mds_client.c         |   5 -
>  fs/ceph/super.h              |  35 ++--
>  include/linux/ceph/ceph_fs.h |   1 +
>  7 files changed, 188 insertions(+), 237 deletions(-)
> 

This looks really good -- nice work, Zheng!

I had a minor nit with patch #2, but I'm not too concerned about it and
it can be fixed up after merge if necessary.

The async dirops set has some conflicts, and Xiubo's stats work may
also. I'm going to go ahead and merge this into testing so we can base
further work on top of it.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

