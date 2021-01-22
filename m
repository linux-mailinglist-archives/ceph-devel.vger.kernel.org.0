Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE8A2FFFD8
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Jan 2021 11:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbhAVKMD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 22 Jan 2021 05:12:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31301 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727729AbhAVKJy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 22 Jan 2021 05:09:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611310084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=42dbdFJaR8tJEHMKluzck6kyK+c6JbIce91AcM2XNmg=;
        b=PozwnzgAePXdecCvzNZA/Tjb1KRYusYY/VhGEMBCp7lRoe5MqKbBVA3kZRx+pWsTVDSzZ/
        I7kSe3wUr3N3h4rUkrb12Tlbd93M+ehIE9kbX6CYmf2sY5R5KAwFmizXnnxmG1G4aT/eza
        DtK4AtgwDrkjN02GB2wgJXgo3/Ys6IA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-F9z8jNMZOU-me4f4q2VJTA-1; Fri, 22 Jan 2021 05:08:01 -0500
X-MC-Unique: F9z8jNMZOU-me4f4q2VJTA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A46280A5C1;
        Fri, 22 Jan 2021 10:08:00 +0000 (UTC)
Received: from [10.72.12.125] (ovpn-12-125.pek2.redhat.com [10.72.12.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AE7F10021AA;
        Fri, 22 Jan 2021 10:07:58 +0000 (UTC)
Subject: Re: [PATCH v3] ceph: defer flushing the capsnap if the Fb is used
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210110020140.141727-1-xiubli@redhat.com>
 <f698d039251d444eec334b119b5ae0b0dd101a21.camel@kernel.org>
 <376245cf-a60d-6ddb-6ab3-894a491b854e@redhat.com>
 <868f0eddf24fcdcb4bdebf93e9200bf699884155.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <02da13e0-1373-5f81-8c26-160710cf58d3@redhat.com>
Date:   Fri, 22 Jan 2021 18:07:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <868f0eddf24fcdcb4bdebf93e9200bf699884155.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2021/1/21 22:28, Jeff Layton wrote:
> On Mon, 2021-01-18 at 17:10 +0800, Xiubo Li wrote:
>> On 2021/1/13 5:48, Jeff Layton wrote:
>>> On Sun, 2021-01-10 at 10:01 +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> If the Fb cap is used it means the current inode is flushing the
>>>> dirty data to OSD, just defer flushing the capsnap.
>>>>
>>>> URL: https://tracker.ceph.com/issues/48679
>>>> URL: https://tracker.ceph.com/issues/48640
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>
>>>> V3:
>>>> - Add more comments about putting the inode ref
>>>> - A small change about the code style
>>>>
>>>> V2:
>>>> - Fix inode reference leak bug
>>>>
>>>>    fs/ceph/caps.c | 32 +++++++++++++++++++-------------
>>>>    fs/ceph/snap.c |  6 +++---
>>>>    2 files changed, 22 insertions(+), 16 deletions(-)
>>>>
>>> Hi Xiubo,
>>>
>>> This patch seems to cause hangs in some xfstests (generic/013, in
>>> particular). I'll take a closer look when I have a chance, but I'm
>>> dropping this for now.
>> Okay.
>>
>> BTW, what's your test commands to reproduce it ? I will take a look when
>> I am free these days or later.
>>
>
> FWIW, I was able to trigger a hang with this patch by running one of the
> tests that this patch was intended to fix (snaptest-git-ceph.sh). Here's
> the stack trace of the hung task:
>
> # cat /proc/1166/stack
> [<0>] wait_woken+0x87/0xb0
> [<0>] ceph_get_caps+0x405/0x6a0 [ceph]
> [<0>] ceph_write_iter+0x2ca/0xd20 [ceph]
> [<0>] new_sync_write+0x10b/0x190
> [<0>] vfs_write+0x240/0x390
> [<0>] ksys_write+0x58/0xd0
> [<0>] do_syscall_64+0x33/0x40
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Hi Jeff,

I have reproduced it, and also tried the libcephfs, which have the same 
logic for this issue, and it worked well.

I will take a look at it later.

> Without this patch I could run that test in a loop without issue. This
> bug mentions that the original issue occurred during mds thrashing
> though, and I haven't tried reproducing that scenario yet:
>
>      https://tracker.ceph.com/issues/48640

 From the logs this issue seems not related the thrashing operation, 
during this test the MDS has already been secussfully thrashed.

BRs

Xiubo

> Cheers,


