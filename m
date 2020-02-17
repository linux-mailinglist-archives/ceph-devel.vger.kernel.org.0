Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F6C16166A
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Feb 2020 16:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgBQPmp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Feb 2020 10:42:45 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53834 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728000AbgBQPmp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 10:42:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581954164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b1gq85fLysK/TomyWWOm6NG9Krrnn2la8ByArYBArkM=;
        b=CHIUznsyB6Bj+S6v0/44jtB36ncUDr4BE9beceiNba9LvqFIQWb5IbApnBR9F/popQnKXi
        3pM2Wlbu+Pzp1Qh/QIh3IA2Bx5dWW0/dXRh0bK3w8MSdHfPdUdeHE/lx7fDidHoU+hdZYd
        XUEAjoUC8aKepgSH3f/xl8q2fmWrIwk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-3oYcmO3NOK2RdcaHfFBlfQ-1; Mon, 17 Feb 2020 10:42:42 -0500
X-MC-Unique: 3oYcmO3NOK2RdcaHfFBlfQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 978BA107ACC9;
        Mon, 17 Feb 2020 15:42:41 +0000 (UTC)
Received: from [10.72.12.166] (ovpn-12-166.pek2.redhat.com [10.72.12.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 80C5910021B2;
        Mon, 17 Feb 2020 15:42:36 +0000 (UTC)
Subject: Re: [PATCH] ceph: fix dout logs for null pointers
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20200217112806.30738-1-xiubli@redhat.com>
 <CAOi1vP_bCGoni+tmvVri6Gcv7QRN4+qvHUrrweHLpnTyAzQw=A@mail.gmail.com>
 <cf786dd6-cb6e-1a3a-a57e-04d9525bb4a4@redhat.com>
 <CAOi1vP9sLLUhuBAP7UZ1Mbjjx4uh0Rt0PwgAuD_qBevQoSOeHA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0637b6ba-b411-6ddd-2703-d0f96a65a796@redhat.com>
Date:   Mon, 17 Feb 2020 23:42:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <CAOi1vP9sLLUhuBAP7UZ1Mbjjx4uh0Rt0PwgAuD_qBevQoSOeHA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/17 23:27, Ilya Dryomov wrote:
> On Mon, Feb 17, 2020 at 4:02 PM Xiubo Li <xiubli@redhat.com> wrote:
>> On 2020/2/17 22:52, Ilya Dryomov wrote:
>>> On Mon, Feb 17, 2020 at 12:28 PM <xiubli@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> For example, if dentry and inode is NULL, the log will be:
>>>> ceph:  lookup result=000000007a1ca695
>>>> ceph:  submit_request on 0000000041d5070e for inode 000000007a1ca695
>>>>
>>>> The will be confusing without checking the corresponding code carefully.
>>>>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/dir.c        | 2 +-
>>>>    fs/ceph/mds_client.c | 6 +++++-
>>>>    2 files changed, 6 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>>>> index ffeaff5bf211..245a262ec198 100644
>>>> --- a/fs/ceph/dir.c
>>>> +++ b/fs/ceph/dir.c
>>>> @@ -798,7 +798,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
>>>>           err = ceph_handle_snapdir(req, dentry, err);
>>>>           dentry = ceph_finish_lookup(req, dentry, err);
>>>>           ceph_mdsc_put_request(req);  /* will dput(dentry) */
>>>> -       dout("lookup result=%p\n", dentry);
>>>> +       dout("lookup result=%d\n", err);
>>>>           return dentry;
>>>>    }
>>>>
>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>> index b6aa357f7c61..e34f159d262b 100644
>>>> --- a/fs/ceph/mds_client.c
>>>> +++ b/fs/ceph/mds_client.c
>>>> @@ -2772,7 +2772,11 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
>>>>                   ceph_get_cap_refs(ceph_inode(req->r_old_dentry_dir),
>>>>                                     CEPH_CAP_PIN);
>>>>
>>>> -       dout("submit_request on %p for inode %p\n", req, dir);
>>>> +       if (dir)
>>>> +               dout("submit_request on %p for inode %p\n", req, dir);
>>>> +       else
>>>> +               dout("submit_request on %p\n", req);
>>> Hi Xiubo,
>>>
>>> It's been this way for a couple of years now.  There are a lot more
>>> douts in libceph, ceph and rbd that are sometimes fed NULL pointers.
>>> I don't think replacing them with conditionals is the way forward.
>>>
>>> I honestly don't know what security concern is addressed by hashing
>>> NULL pointers, but that is what we have...  Ultimately, douts are just
>>> for developers, and when you find yourself having to chase individual
>>> pointers, you usually have a large enough piece of log to figure out
>>> what the NULL hash is.
>> Hi Ilya
>>
>> For the ceph_lookup(). The dentry will be NULL(when the directory exists
>> or -ENOENT) or ERR_PTR(-errno) in most cases here, it seems for the
>> rename case it will be the old dentry returned.
>>
>> So today I was trying to debug and get some logs from it, the
>> 000000007a1ca695 really confused me for a long time before I dig into
>> the source code.
> I was reacting to ceph_mdsc_submit_request() hunk.  Feel free to tweak
> ceph_lookup() or refactor it so that err is not threaded through three
> different functions as Jeff suggested.

Hi Ilya

Oh okay. You are right we can figure out what we need via many other 
dout logs.

I just saw some very confusing logs that the "dentry" in cpeh_lookup() 
and the "inode" in _submit_ are all 000000007a1ca695, so I addressed 
them both here.

Thanks,

BRs


> Thanks,
>
>                  Ilya
>

