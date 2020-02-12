Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3AE715A735
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Feb 2020 11:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgBLK7Z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Feb 2020 05:59:25 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44982 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725821AbgBLK7Y (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 Feb 2020 05:59:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581505163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1wWs3AW6y8lE5TwJCJ2ppY67pjWhRdhMeg/j2iS2Rgs=;
        b=IRTyv1RdWqD79PBWWNI8fV/Br/8MiIvZGQxu+YRMg94GGH/72hgFtnzU83uzXUSkWeBVyR
        2E43XNMLroDJXJ6/dTs2EMaIXjAytEmZxDZm8qXD5O4H28hItX/ncdbkBhjREv2udFNuXE
        /6Tc/JAmcaW4XWj22Bl95wi2mh329HA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-C8bx2NfuMnWEi2LOg6SWng-1; Wed, 12 Feb 2020 05:59:22 -0500
X-MC-Unique: C8bx2NfuMnWEi2LOg6SWng-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B69ED800D48;
        Wed, 12 Feb 2020 10:59:20 +0000 (UTC)
Received: from [10.72.12.209] (ovpn-12-209.pek2.redhat.com [10.72.12.209])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EFEA1001B09;
        Wed, 12 Feb 2020 10:59:15 +0000 (UTC)
Subject: Re: [RFC PATCH] ceph: fix description of some mount options
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, linux-doc@vger.kernel.org,
        corbet@lwn.net
References: <20200211153120.21369-1-xiubli@redhat.com>
 <537a2c4a37f601fe402fa7b893061fd9f4270f56.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <473f2e9b-93af-c232-aef7-49ab9fa1efa6@redhat.com>
Date:   Wed, 12 Feb 2020 18:59:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <537a2c4a37f601fe402fa7b893061fd9f4270f56.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/12 0:48, Jeff Layton wrote:
> On Tue, 2020-02-11 at 10:31 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Based on the latest code, the default value for wsize/rsize is
>> 64MB and the default value for the mount_timeout is 60 seconds.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> Checked the history of the code, I am a little confused about the
>> default values for wsize/rsize, there never been 16MB as the default,
>> and for the mount_timeout, never seen 30 as default.
>>
>> So did I miss something important about this ?
>>
> It looks like the default rsize/wsize were 16M prior to 94e6992bb560b.
> It then went to 32 and then 64 a little while afterward.

Yeah, it is.

Thanks,

BRs

>   I don't see
> where the mount_timeout was ever 30s though.
>
> Merged into testing branch since this seems obviously correct.
>
>>   Documentation/filesystems/ceph.txt | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/filesystems/ceph.txt b/Documentation/filesystems/ceph.txt
>> index b19b6a03f91c..92ffc9b3b018 100644
>> --- a/Documentation/filesystems/ceph.txt
>> +++ b/Documentation/filesystems/ceph.txt
>> @@ -103,17 +103,17 @@ Mount Options
>>   	address its connection to the monitor originates from.
>>   
>>     wsize=X
>> -	Specify the maximum write size in bytes.  Default: 16 MB.
>> +	Specify the maximum write size in bytes.  Default: 64 MB.
>>   
>>     rsize=X
>> -	Specify the maximum read size in bytes.  Default: 16 MB.
>> +	Specify the maximum read size in bytes.  Default: 64 MB.
>>   
>>     rasize=X
>>   	Specify the maximum readahead size in bytes.  Default: 8 MB.
>>   
>>     mount_timeout=X
>>   	Specify the timeout value for mount (in seconds), in the case
>> -	of a non-responsive Ceph file system.  The default is 30
>> +	of a non-responsive Ceph file system.  The default is 60
>>   	seconds.
>>   
>>     caps_max=X


