Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9EA263AD7
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Sep 2020 04:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgIJCrU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Sep 2020 22:47:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49534 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730388AbgIJCAR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Sep 2020 22:00:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599703214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FNqVfZquE93GYB1jXToAyy/BThfc9EBqsh9+LW0xdZk=;
        b=VkYU+FaCcgnKsTDU+C1glUiBZ5FX5eWKvSF2VtahnL3PFTYsjLlNpqeO3BHBTx2vbO5q+d
        eDt7Gk85HhAIjK0AI8d3EI27fesC9zz2Ybp9SKqLdOztZxjy8n0/YS0UEMLbIoCdDpPRBU
        ktu/jxuNt3wl7XGPORs5i65iP87x0AI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-CZvH8HKVOfyBxCx-5y5vag-1; Wed, 09 Sep 2020 20:59:33 -0400
X-MC-Unique: CZvH8HKVOfyBxCx-5y5vag-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27DBF1882FAD;
        Thu, 10 Sep 2020 00:59:32 +0000 (UTC)
Received: from [10.72.12.33] (ovpn-12-33.pek2.redhat.com [10.72.12.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 32DF05D9EF;
        Thu, 10 Sep 2020 00:59:29 +0000 (UTC)
Subject: Re: [PATCH v5 0/2] ceph: metrics for opened files, pinned caps and
 opened inodes
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20200903130140.799392-1-xiubli@redhat.com>
 <449a56624f3dd4e2a4a4cf95cd24d69c53700b6d.camel@kernel.org>
 <ad35f2f8-6692-3918-6137-adc8e95607c6@redhat.com>
 <CAOi1vP-8rbzZ=-Apir2B4Z6U10ZKrp41d6+BYgvGsyL+ND-JnQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <cdf40ea5-ecd0-0df6-7db4-7897aa3a5ad0@redhat.com>
Date:   Thu, 10 Sep 2020 08:59:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-8rbzZ=-Apir2B4Z6U10ZKrp41d6+BYgvGsyL+ND-JnQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/9/10 4:34, Ilya Dryomov wrote:
> On Thu, Sep 3, 2020 at 4:22 PM Xiubo Li <xiubli@redhat.com> wrote:
>> On 2020/9/3 22:18, Jeff Layton wrote:
>>> On Thu, 2020-09-03 at 09:01 -0400, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> Changed in V5:
>>>> - Remove mdsc parsing helpers except the ceph_sb_to_mdsc()
>>>> - Remove the is_opened member.
>>>>
>>>> Changed in V4:
>>>> - A small fix about the total_inodes.
>>>>
>>>> Changed in V3:
>>>> - Resend for V2 just forgot one patch, which is adding some helpers
>>>> support to simplify the code.
>>>>
>>>> Changed in V2:
>>>> - Add number of inodes that have opened files.
>>>> - Remove the dir metrics and fold into files.
>>>>
>>>>
>>>>
>>>> Xiubo Li (2):
>>>>     ceph: add ceph_sb_to_mdsc helper support to parse the mdsc
>>>>     ceph: metrics for opened files, pinned caps and opened inodes
>>>>
>>>>    fs/ceph/caps.c    | 41 +++++++++++++++++++++++++++++++++++++----
>>>>    fs/ceph/debugfs.c | 11 +++++++++++
>>>>    fs/ceph/dir.c     | 20 +++++++-------------
>>>>    fs/ceph/file.c    | 13 ++++++-------
>>>>    fs/ceph/inode.c   | 11 ++++++++---
>>>>    fs/ceph/locks.c   |  2 +-
>>>>    fs/ceph/metric.c  | 14 ++++++++++++++
>>>>    fs/ceph/metric.h  |  7 +++++++
>>>>    fs/ceph/quota.c   | 10 +++++-----
>>>>    fs/ceph/snap.c    |  2 +-
>>>>    fs/ceph/super.h   |  6 ++++++
>>>>    11 files changed, 103 insertions(+), 34 deletions(-)
>>>>
>>> Looks good. I went ahead and merge this into testing.
>>>
>>> Small merge conflict in quota.c, which I guess is probably due to not
>>> basing this on testing branch. I also dropped what looks like an
>>> unrelated hunk in the second patch.
>>>
>>> In the future, if you can be sure that patches you post apply cleanly to
>>> testing branch then that would make things easier.
>> Okay, will do it.
> Hi Xiubo,
>
> There is a problem with lifetimes here.  mdsc isn't guaranteed to exist
> when ->free_inode() is called.  This can lead to crashes on a NULL mdsc
> in ceph_free_inode() in case of e.g. "umount -f".  I know it was Jeff's
> suggestion to move the decrement of total_inodes into ceph_free_inode(),
> but it doesn't look like it can be easily deferred past ->evict_inode().

Okay, I will take a look.

Thanks Ilya.


> Thanks,
>
>                  Ilya
>

