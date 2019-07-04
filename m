Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 456A25F0F9
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Jul 2019 03:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfGDBa6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 21:30:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41170 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbfGDBa6 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 21:30:58 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 36DEE308218D
        for <ceph-devel@vger.kernel.org>; Thu,  4 Jul 2019 01:30:58 +0000 (UTC)
Received: from [10.72.12.126] (ovpn-12-126.pek2.redhat.com [10.72.12.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8706713ACD;
        Thu,  4 Jul 2019 01:30:56 +0000 (UTC)
Subject: Re: [PATCH 0/9] ceph: auto reconnect after blacklisted
To:     Jeff Layton <jlayton@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
References: <20190703124442.6614-1-zyan@redhat.com>
 <4bd33f73c9f64e79c0364a22dfdd63db02b4e7ab.camel@redhat.com>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <1f6359f5-7669-a60b-0a3b-5f74d203af67@redhat.com>
Date:   Thu, 4 Jul 2019 09:30:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <4bd33f73c9f64e79c0364a22dfdd63db02b4e7ab.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 04 Jul 2019 01:30:58 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 7/4/19 12:01 AM, Jeff Layton wrote:
> On Wed, 2019-07-03 at 20:44 +0800, Yan, Zheng wrote:
>> This series add support for auto reconnect after blacklisted.
>>
>> Auto reconnect is controlled by recover_session=<clean|no> mount option.
>> Clean mode is enabled by default. In this mode, client drops dirty date
>> and dirty metadata, All writable file handles are invalidated. Read-only
>> file handles continue to work and caches are dropped if necessary.
>> If an inode contains any lost file lock, read and write are not allowed.
>> until all lost file locks are released.
> 
> Just giving this a quick glance:
> 
> Based on the last email discussion about this, I thought that you were
> going to provide a mount option that someone could enable that would
> basically allow the client to "soldier on" in the face of being
> blacklisted and then unblacklisted, without needing to remount anything.
> 
> This set seems to keep the force_reconnect option (patch #7) though, so
> I'm quite confused at this point. What exactly is the goal of here?
> 

because auto reconnect can be disabled, force_reconnect is the manual 
way to fix blacklistd mount.

> There's also nothing in the changelogs or comments about
> recover_session=brute, which seems like it ought to at least be
> mentioned.

brute code is not enabled yet
> 
> At this point, I'm going to say NAK on this set until there is some
> accompanying documentation about how you intend for this be used and by
> whom. A patch for the mount.ceph(8) manpage would be a good place to
> start.
> 
>> Yan, Zheng (9):
>>    libceph: add function that reset client's entity addr
>>    libceph: add function that clears osd client's abort_err
>>    ceph: allow closing session in restarting/reconnect state
>>    ceph: track and report error of async metadata operation
>>    ceph: pass filp to ceph_get_caps()
>>    ceph: return -EIO if read/write against filp that lost file locks
>>    ceph: add 'force_reconnect' option for remount
>>    ceph: invalidate all write mode filp after reconnect
>>    ceph: auto reconnect after blacklisted
>>
>>   fs/ceph/addr.c                  | 30 +++++++----
>>   fs/ceph/caps.c                  | 84 ++++++++++++++++++++----------
>>   fs/ceph/file.c                  | 50 ++++++++++--------
>>   fs/ceph/inode.c                 |  2 +
>>   fs/ceph/locks.c                 |  8 ++-
>>   fs/ceph/mds_client.c            | 92 ++++++++++++++++++++++++++-------
>>   fs/ceph/mds_client.h            |  6 +--
>>   fs/ceph/super.c                 | 91 ++++++++++++++++++++++++++++++--
>>   fs/ceph/super.h                 | 23 +++++++--
>>   include/linux/ceph/libceph.h    |  1 +
>>   include/linux/ceph/messenger.h  |  1 +
>>   include/linux/ceph/mon_client.h |  1 +
>>   include/linux/ceph/osd_client.h |  2 +
>>   net/ceph/ceph_common.c          | 38 +++++++++-----
>>   net/ceph/messenger.c            |  5 ++
>>   net/ceph/mon_client.c           |  7 +++
>>   net/ceph/osd_client.c           | 24 +++++++++
>>   17 files changed, 365 insertions(+), 100 deletions(-)
>>
> 

