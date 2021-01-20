Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150242FC62F
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Jan 2021 01:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbhATA6M (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Jan 2021 19:58:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41340 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727612AbhATA6K (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 19 Jan 2021 19:58:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611104202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zubmaTw2nP+Z73Tnximr4jSPJM3DR1F8I6ZEBNPd8gE=;
        b=HxPjZa1jxRd6BwonBdXC/a6ehsnNsNTNuZuetkfG6iAqB6aKygbxR0VShXIgcCiU0bYz47
        r0Q4EIY9nbj3K1pTtKgBaH4+bxw1louzJTNpgVjOs/Cg3ye7HyGxOZNZoo1kC03NXylmuq
        sZqN5y2ecKYz/bbWp0P5gK/H+d03VIM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-6RYpu1XPMKKWr8f7JFckhQ-1; Tue, 19 Jan 2021 19:56:40 -0500
X-MC-Unique: 6RYpu1XPMKKWr8f7JFckhQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94FC0800D55;
        Wed, 20 Jan 2021 00:56:38 +0000 (UTC)
Received: from [10.72.12.125] (ovpn-12-125.pek2.redhat.com [10.72.12.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1344360D52;
        Wed, 20 Jan 2021 00:56:36 +0000 (UTC)
Subject: Re: [PATCH v3] ceph: defer flushing the capsnap if the Fb is used
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210110020140.141727-1-xiubli@redhat.com>
 <f698d039251d444eec334b119b5ae0b0dd101a21.camel@kernel.org>
 <376245cf-a60d-6ddb-6ab3-894a491b854e@redhat.com>
 <5a6fd5f3ab30fe04332bc4af4ecdeaca7fd501c0.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d05c2108-079d-f9c4-7a65-2be42579ecbb@redhat.com>
Date:   Wed, 20 Jan 2021 08:56:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <5a6fd5f3ab30fe04332bc4af4ecdeaca7fd501c0.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2021/1/18 19:08, Jeff Layton wrote:
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
>>>>   fs/ceph/caps.c | 32 +++++++++++++++++++-------------
>>>>   fs/ceph/snap.c |  6 +++---
>>>>   2 files changed, 22 insertions(+), 16 deletions(-)
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
>> BRs
>>
> I set up xfstests to run on cephfs, and then just run:
>
>      $ sudo ./check generic/013
>
> It wouldn't reliably complete with this patch in place. Setting up
> xfstests is the "hard part". I'll plan to roll up a wiki page on how to
> do that soon (that's good info to have out there anyway).

Okay, sure.

Thanks.


> Cheers,


