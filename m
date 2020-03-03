Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D7B177BCE
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Mar 2020 17:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730115AbgCCQX7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Mar 2020 11:23:59 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55055 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729508AbgCCQX7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 3 Mar 2020 11:23:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583252638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YafcUk3xXeZnyK4HIgbhUff2eET7NzAK8VKreCHjRqQ=;
        b=JFSgEdkQaqE8ItRobXaCPOEZmP0VWdDu7p/l4HjTR0Wp39p0BQiUOuF6De9cG8RKI9rmTe
        nSHTeiiCMA6+L8yVlge+b3G7kz9FN9i+hG1pylKxhP5fbTPs7fNVEFmmP05pqhGKUXWMk/
        CSUvVXn4P7aDnn2tWlXW8laYnYuHztw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-o-wGHgjuMwuDfwSnufkU7g-1; Tue, 03 Mar 2020 11:23:54 -0500
X-MC-Unique: o-wGHgjuMwuDfwSnufkU7g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E17B78017DF;
        Tue,  3 Mar 2020 16:23:52 +0000 (UTC)
Received: from [10.72.13.234] (ovpn-13-234.pek2.redhat.com [10.72.13.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF69C10013A1;
        Tue,  3 Mar 2020 16:23:50 +0000 (UTC)
Subject: Re: [PATCH v3 0/6] ceph: don't request caps for idle open files
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>
References: <20200228115550.6904-1-zyan@redhat.com>
 <186bfc2278dbdd4eac21f6ce03108c53e3f574b3.camel@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <a226d5b6-2371-5c94-97ee-6bc5b273b21d@redhat.com>
Date:   Wed, 4 Mar 2020 00:23:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <186bfc2278dbdd4eac21f6ce03108c53e3f574b3.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 3/3/20 3:53 AM, Jeff Layton wrote:
> On Fri, 2020-02-28 at 19:55 +0800, Yan, Zheng wrote:
>> This series make cephfs client not request caps for open files that
>> idle for a long time. For the case that one active client and multiple
>> standby clients open the same file, this increase the possibility that
>> mds issues exclusive caps to the active client.
>>
>> Yan, Zheng (4):
>>    ceph: always renew caps if mds_wanted is insufficient
>>    ceph: consider inode's last read/write when calculating wanted caps
>>    ceph: simplify calling of ceph_get_fmode()
>>    ceph: remove delay check logic from ceph_check_caps()
>>
>>   fs/ceph/caps.c               | 324 +++++++++++++++--------------------
>>   fs/ceph/file.c               |  39 ++---
>>   fs/ceph/inode.c              |  19 +-
>>   fs/ceph/ioctl.c              |   2 +
>>   fs/ceph/mds_client.c         |   5 -
>>   fs/ceph/super.h              |  35 ++--
>>   include/linux/ceph/ceph_fs.h |   1 +
>>   7 files changed, 188 insertions(+), 237 deletions(-)
>>
>> changes since v2
>>   - make __ceph_caps_file_wanted more readable
>>   - add patch 5 and 6, which fix hung write during testing patch 1~4
>>
> 
> This patch series causes some serious slowdown in the async dirops
> patches that I've not yet fully tracked down, and I suspect that they
> may also be the culprit in these bugs:
> 

slow down which tests?

>      https://tracker.ceph.com/issues/44381

this is because I forgot to check if inode is snap when queue delayed 
check. But it can't explain slow down.

>      https://tracker.ceph.com/issues/44382
> 
> I'm going to drop this series from the testing branch for now, until we
> can track down the issue.
> 
> Thanks,
> 


