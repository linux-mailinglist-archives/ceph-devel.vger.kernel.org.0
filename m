Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1920B164488
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 13:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbgBSMoH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Feb 2020 07:44:07 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33303 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726491AbgBSMoH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 19 Feb 2020 07:44:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582116245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KTCXOxkGwei2N9CqK9DpJSsxlDO0Dj8CyqxGlPrhXPo=;
        b=hBxEKpjkrTNYWwsxuutByvv4Em07yNbTUHB/vuo3C9T8dYyu9x68xdFPv3XGkivJzx//jm
        ZHuQ44d4f71cwErdNQU9xDQ6Dy+bis6sgn/FJdl26si5v/w+Pj8dZ5IBujQ/NFJrRpGWP0
        VdFklE9/nrIw+GFn6YAtZbSe6Qa+Vxs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-KWbqyH4jNeKUI3d-2Yc_OQ-1; Wed, 19 Feb 2020 07:44:02 -0500
X-MC-Unique: KWbqyH4jNeKUI3d-2Yc_OQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF621DBE8;
        Wed, 19 Feb 2020 12:44:01 +0000 (UTC)
Received: from [10.72.12.94] (ovpn-12-94.pek2.redhat.com [10.72.12.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AC6DE1001B00;
        Wed, 19 Feb 2020 12:43:58 +0000 (UTC)
Subject: Re: BUG: ceph_inode_cachep and ceph_dentry_cachep caches are not
 clean when destroying
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <23e2b9a7-5ff6-1f07-ff03-08abcbf1457f@redhat.com>
 <CAOi1vP8b1aCph3NkAENEtAKfPDa8J03cNxwOZ+KSn1-te=6g0w@mail.gmail.com>
 <bed8db55-50e1-a787-c9d4-a7c0f3c6c9d2@redhat.com>
 <CAOi1vP_=t+ppv2Ob1O44-zQz69Y5au2G+5XHvqQ8vvxLUee_2g@mail.gmail.com>
 <ee0c1043-b0b8-5107-3c78-c4a7b8fca4dc@redhat.com>
 <1efef7a514b31b731d031a788e4bc89f508343a9.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <09a76a4e-8596-87a7-94a2-53102af8e4f0@redhat.com>
Date:   Wed, 19 Feb 2020 20:43:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1efef7a514b31b731d031a788e4bc89f508343a9.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/19 20:33, Jeff Layton wrote:
> On Wed, 2020-02-19 at 19:29 +0800, Xiubo Li wrote:
>> On 2020/2/19 19:27, Ilya Dryomov wrote:
>>> On Wed, Feb 19, 2020 at 12:01 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>> On 2020/2/19 18:53, Ilya Dryomov wrote:
>>>>> On Wed, Feb 19, 2020 at 10:39 AM Xiubo Li <xiubli@redhat.com> wrote:
>>>>>> Hi Jeff, Ilya and all
>>>>>>
>>>>>> I hit this call traces by running some test cases when unmounting the fs
>>>>>> mount points.
>>>>>>
>>>>>> It seems there still have some inodes or dentries are not destroyed.
>>>>>>
>>>>>> Will this be a problem ? Any idea ?
>>>>> Hi Xiubo,
>>>>>
>>>>> Of course it is a problem ;)
>>>>>
>>>>> These are all in ceph_inode_info and ceph_dentry_info caches, but
>>>>> I see traces of rbd mappings as well.  Could you please share your
>>>>> test cases?  How are you unloading modules?
>>>> I am not sure exactly in which one, mostly I was running the following
>>>> commands.
>>>>
>>>> 1, ./bin/rbd map share -o mount_timeout=30
>>>>
>>>> 2, ./bin/rbd unmap share
>>>>
>>>> 3, ./bin/mount.ceph :/ /mnt/cephfs/
>>>>
>>>> 4, `for i in {0..1000}; do mkdir /mnt/cephfs/dir$0; done` and `for i in
>>>> {0..1000}; do rm -rf /mnt/cephfs/dir$0; done`
>>>>
>>>> 5, umount /mnt/cephfs/
>>>>
>>>> 6, rmmod ceph; rmmod rbd; rmmod libceph
>>>>
>>>> This it seems none business with the rbd mappings.
>>> Is this on more or less plain upstream or with async unlink and
>>> possibly other filesystem patches applied?
>> Using the latest test branch:
>> https://github.com/ceph/ceph-client/tree/testing.
>>
>> thanks
>>
> I've run a lot of tests like this and haven't see this at all. Did you
> see any "Busy inodes after umount" messages in dmesg?
>
> I note that your kernel is tainted -- sometimes if you're plugging in
> modules that have subtle ABI incompatibilities, you can end up with
> memory corruption like this.
>
> What would be ideal would be to come up with a reliable reproducer if
> possible.

The code is clean from the testing branch pulled yesterday, but hit it 
only once locally, just encounter it in the dmesg when checking other logs.

Thanks.



