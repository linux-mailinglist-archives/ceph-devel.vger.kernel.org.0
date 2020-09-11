Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE842657A4
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Sep 2020 05:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725372AbgIKDnk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Sep 2020 23:43:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59226 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725283AbgIKDnj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Sep 2020 23:43:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599795816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Py8MC0I0O3F6bWNrM+yJqNd+MwH4KBeEOQn3dlVf+a4=;
        b=ex0IoPtxTfR1BLPmP7A/BpzPdflxKKK3gIQwDK1acC2k4t7fH+obHB1IglqfVaMtzvulWP
        SnAAC0h1DnL5iwO7XTo3kovOYYNwo6Ii8plW9K60EaPHwGmfRsGQA5zElfF5CuWn9jO3UP
        vlGVaEz7PIB6zppDHH6e81Fnnz1aDcg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-ZW54O5SkP--V_h0NwmWapg-1; Thu, 10 Sep 2020 23:43:34 -0400
X-MC-Unique: ZW54O5SkP--V_h0NwmWapg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CAF51074640;
        Fri, 11 Sep 2020 03:43:33 +0000 (UTC)
Received: from [10.72.12.33] (ovpn-12-33.pek2.redhat.com [10.72.12.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CD329CBA;
        Fri, 11 Sep 2020 03:43:29 +0000 (UTC)
Subject: Re: [PATCH v5 0/2] ceph: metrics for opened files, pinned caps and
 opened inodes
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20200903130140.799392-1-xiubli@redhat.com>
 <449a56624f3dd4e2a4a4cf95cd24d69c53700b6d.camel@kernel.org>
 <ad35f2f8-6692-3918-6137-adc8e95607c6@redhat.com>
 <CAOi1vP-8rbzZ=-Apir2B4Z6U10ZKrp41d6+BYgvGsyL+ND-JnQ@mail.gmail.com>
 <cdf40ea5-ecd0-0df6-7db4-7897aa3a5ad0@redhat.com>
 <CAOi1vP-XxXVcvyZgQF7mWaxm-21hiY5fF4tRYkua-F9ikof7UA@mail.gmail.com>
 <e291d899acee9f9218fe9a62f7300ab82592c459.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <9a5c5d2f-d105-21c4-327e-5ad18bf49518@redhat.com>
Date:   Fri, 11 Sep 2020 11:43:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <e291d899acee9f9218fe9a62f7300ab82592c459.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/9/10 20:13, Jeff Layton wrote:
> On Thu, 2020-09-10 at 08:00 +0200, Ilya Dryomov wrote:
>> On Thu, Sep 10, 2020 at 2:59 AM Xiubo Li <xiubli@redhat.com> wrote:
>>> On 2020/9/10 4:34, Ilya Dryomov wrote:
>>>> On Thu, Sep 3, 2020 at 4:22 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>>> On 2020/9/3 22:18, Jeff Layton wrote:
>>>>>> On Thu, 2020-09-03 at 09:01 -0400, xiubli@redhat.com wrote:
>>>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>>>
>>>>>>> Changed in V5:
>>>>>>> - Remove mdsc parsing helpers except the ceph_sb_to_mdsc()
>>>>>>> - Remove the is_opened member.
>>>>>>>
>>>>>>> Changed in V4:
>>>>>>> - A small fix about the total_inodes.
>>>>>>>
>>>>>>> Changed in V3:
>>>>>>> - Resend for V2 just forgot one patch, which is adding some helpers
>>>>>>> support to simplify the code.
>>>>>>>
>>>>>>> Changed in V2:
>>>>>>> - Add number of inodes that have opened files.
>>>>>>> - Remove the dir metrics and fold into files.
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Xiubo Li (2):
>>>>>>>      ceph: add ceph_sb_to_mdsc helper support to parse the mdsc
>>>>>>>      ceph: metrics for opened files, pinned caps and opened inodes
>>>>>>>
>>>>>>>     fs/ceph/caps.c    | 41 +++++++++++++++++++++++++++++++++++++----
>>>>>>>     fs/ceph/debugfs.c | 11 +++++++++++
>>>>>>>     fs/ceph/dir.c     | 20 +++++++-------------
>>>>>>>     fs/ceph/file.c    | 13 ++++++-------
>>>>>>>     fs/ceph/inode.c   | 11 ++++++++---
>>>>>>>     fs/ceph/locks.c   |  2 +-
>>>>>>>     fs/ceph/metric.c  | 14 ++++++++++++++
>>>>>>>     fs/ceph/metric.h  |  7 +++++++
>>>>>>>     fs/ceph/quota.c   | 10 +++++-----
>>>>>>>     fs/ceph/snap.c    |  2 +-
>>>>>>>     fs/ceph/super.h   |  6 ++++++
>>>>>>>     11 files changed, 103 insertions(+), 34 deletions(-)
>>>>>>>
>>>>>> Looks good. I went ahead and merge this into testing.
>>>>>>
>>>>>> Small merge conflict in quota.c, which I guess is probably due to not
>>>>>> basing this on testing branch. I also dropped what looks like an
>>>>>> unrelated hunk in the second patch.
>>>>>>
>>>>>> In the future, if you can be sure that patches you post apply cleanly to
>>>>>> testing branch then that would make things easier.
>>>>> Okay, will do it.
>>>> Hi Xiubo,
>>>>
>>>> There is a problem with lifetimes here.  mdsc isn't guaranteed to exist
>>>> when ->free_inode() is called.  This can lead to crashes on a NULL mdsc
>>>> in ceph_free_inode() in case of e.g. "umount -f".  I know it was Jeff's
>>>> suggestion to move the decrement of total_inodes into ceph_free_inode(),
>>>> but it doesn't look like it can be easily deferred past ->evict_inode().
>>> Okay, I will take a look.
>> Given that it's just a counter which we don't care about if the
>> mount is going away, some form of "if (mdsc)" check might do, but
>> need to make sure that it covers possible races, if any.
>>
> Good catch, Ilya.
>
> What may be best is to move the increment out of ceph_alloc_inode and
> instead put it in ceph_set_ino_cb. Then the decrement can go back into
> ceph_evict_inode.

Hi Jeff, Ilya

Checked the code, it seems in the ceph_evict_inode() we will also hit 
the same issue .

With the '-f' options when umounting, it will skip the inodes whose 
i_count ref > 0. And then free the fsc/mdsc in ceph. And later the 
iput_final() will call the ceph_evict_inode() and then ceph_free_inode().

Could we just check if !!(sb->s_flags & SB_ACTIVE) is false will we skip 
the counting ?

Thanks


> That will mean that you're only counting hashed inodes, but that's
> mostly what we're concerned with anyway, so I don't see that as a
> problem.


