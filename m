Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD4416435F
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 12:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgBSL3t (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Feb 2020 06:29:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34616 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726823AbgBSL3s (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Feb 2020 06:29:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582111787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SBh1HNJgO79ZDJY20S72+ev5tfRgtHd41M6doWFpvzI=;
        b=iPYtJVSeGO74IHdVen9djwGkUYmhH60XWJ0m9MUm5ofBOyfFcPXUuInTqwy2Vzb45hf8oR
        2e3mj5gB1xjJsVrkE0sCWyXaLXYoVl3Cscj5gyIkZ3bP2Sqc1DJUGVZxSeRh8+kXb1sh+e
        fGb5n9xtTl6zZAJIW/vAjw0LIaGkUZc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-czi4JWDfPwaDW-rGKeAC2g-1; Wed, 19 Feb 2020 06:29:44 -0500
X-MC-Unique: czi4JWDfPwaDW-rGKeAC2g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28EF48010E8;
        Wed, 19 Feb 2020 11:29:43 +0000 (UTC)
Received: from [10.72.12.94] (ovpn-12-94.pek2.redhat.com [10.72.12.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DD4225E242;
        Wed, 19 Feb 2020 11:29:40 +0000 (UTC)
Subject: Re: BUG: ceph_inode_cachep and ceph_dentry_cachep caches are not
 clean when destroying
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <23e2b9a7-5ff6-1f07-ff03-08abcbf1457f@redhat.com>
 <CAOi1vP8b1aCph3NkAENEtAKfPDa8J03cNxwOZ+KSn1-te=6g0w@mail.gmail.com>
 <bed8db55-50e1-a787-c9d4-a7c0f3c6c9d2@redhat.com>
 <CAOi1vP_=t+ppv2Ob1O44-zQz69Y5au2G+5XHvqQ8vvxLUee_2g@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ee0c1043-b0b8-5107-3c78-c4a7b8fca4dc@redhat.com>
Date:   Wed, 19 Feb 2020 19:29:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP_=t+ppv2Ob1O44-zQz69Y5au2G+5XHvqQ8vvxLUee_2g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/19 19:27, Ilya Dryomov wrote:
> On Wed, Feb 19, 2020 at 12:01 PM Xiubo Li <xiubli@redhat.com> wrote:
>> On 2020/2/19 18:53, Ilya Dryomov wrote:
>>> On Wed, Feb 19, 2020 at 10:39 AM Xiubo Li <xiubli@redhat.com> wrote:
>>>> Hi Jeff, Ilya and all
>>>>
>>>> I hit this call traces by running some test cases when unmounting the fs
>>>> mount points.
>>>>
>>>> It seems there still have some inodes or dentries are not destroyed.
>>>>
>>>> Will this be a problem ? Any idea ?
>>> Hi Xiubo,
>>>
>>> Of course it is a problem ;)
>>>
>>> These are all in ceph_inode_info and ceph_dentry_info caches, but
>>> I see traces of rbd mappings as well.  Could you please share your
>>> test cases?  How are you unloading modules?
>> I am not sure exactly in which one, mostly I was running the following
>> commands.
>>
>> 1, ./bin/rbd map share -o mount_timeout=30
>>
>> 2, ./bin/rbd unmap share
>>
>> 3, ./bin/mount.ceph :/ /mnt/cephfs/
>>
>> 4, `for i in {0..1000}; do mkdir /mnt/cephfs/dir$0; done` and `for i in
>> {0..1000}; do rm -rf /mnt/cephfs/dir$0; done`
>>
>> 5, umount /mnt/cephfs/
>>
>> 6, rmmod ceph; rmmod rbd; rmmod libceph
>>
>> This it seems none business with the rbd mappings.
> Is this on more or less plain upstream or with async unlink and
> possibly other filesystem patches applied?

Using the latest test branch: 
https://github.com/ceph/ceph-client/tree/testing.

thanks

> Thanks,
>
>                  Ilya
>

