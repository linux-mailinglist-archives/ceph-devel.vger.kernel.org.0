Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC621737C8
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Feb 2020 14:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbgB1NBO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 28 Feb 2020 08:01:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgB1NBN (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 28 Feb 2020 08:01:13 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D78F222C4;
        Fri, 28 Feb 2020 13:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582894873;
        bh=d/hEmnjkH2BJWXF7DooqIPD/7q80k7FCXWE+9DyZ0ZY=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=aspUpgT95oYsyGVzfxYjs6H5VvH2dp16B+1K6vinvrxdtzV+WZqcaDVa5BJoxQgOD
         6HZzLb/eLe+ZuU5zNvqzcIin2WtqTIRaFcwshBv23Ssawd0OO8JfZeViCg8HecL04z
         zM9sar7sA2tDZFkrLbiXTEFsvQYWi3+R5Rtn7SIE=
Message-ID: <61519b99b630ea6be7893bf9493b0f3d68a54e8d.camel@kernel.org>
Subject: Re: [PATCH v3 0/6] ceph: don't request caps for idle open files
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Date:   Fri, 28 Feb 2020 08:01:11 -0500
In-Reply-To: <20200228115550.6904-1-zyan@redhat.com>
References: <20200228115550.6904-1-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-02-28 at 19:55 +0800, Yan, Zheng wrote:
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
> changes since v2
>  - make __ceph_caps_file_wanted more readable
>  - add patch 5 and 6, which fix hung write during testing patch 1~4
> 

Thanks Zheng. This looks good to me -- merged into testing branch with
some small revisions to the changelogs. Let me know if I made any
mistakes there.
-- 
Jeff Layton <jlayton@kernel.org>

