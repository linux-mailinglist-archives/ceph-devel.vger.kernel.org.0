Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A969828CE94
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Oct 2020 14:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbgJMMoY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Oct 2020 08:44:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727077AbgJMMoY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 13 Oct 2020 08:44:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602593062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yLZgTnrhMd67I/Xd0ZKUM3q5IS4kqWg4v741axIu0zs=;
        b=buUMRGnu1Sicp2wsx2P96vmMRw5MrJZJo/Jxy57i9VgNnLmachLafCDG8ShAMdgseb0B5P
        i7iHRsQ/Pzh1lCNf5O1x3QnOSzllbo+yRdAbzXpjeKVuQTKtEzEALoRLRDIt7SlkB7LWvl
        W3CwVzHK0Gqfqp+RVILqrtx9Jdwlj9c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-gnJWR0-bNoSdbzqY0sdoGw-1; Tue, 13 Oct 2020 08:44:19 -0400
X-MC-Unique: gnJWR0-bNoSdbzqY0sdoGw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 194AB1084D63;
        Tue, 13 Oct 2020 12:44:18 +0000 (UTC)
Received: from [10.72.12.67] (ovpn-12-67.pek2.redhat.com [10.72.12.67])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1990619C59;
        Tue, 13 Oct 2020 12:44:15 +0000 (UTC)
Subject: Re: [PATCH] ceph: add 'noshare' mount option support
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20201013103112.12132-1-xiubli@redhat.com>
 <6240402b3e530f3ffa8fba3cedd0113325c821fa.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <031552e2-b749-d910-273b-bb076e4d7f71@redhat.com>
Date:   Tue, 13 Oct 2020 20:44:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <6240402b3e530f3ffa8fba3cedd0113325c821fa.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/10/13 20:31, Jeff Layton wrote:
> On Tue, 2020-10-13 at 18:31 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will disable different mount points to share superblocks.
>>
> Why? What problem does this solve? Don't make us dig through random
> tracker bugs to determine this, please. :)

So, should we just mannully trigger to crash the kernel to get the 
coredump ?


> Also, the subject mentions a "noshare" mount option, but the code below
> will be expecting sharesb/nosharesb.
>
>> URL: https://tracker.ceph.com/issues/46883
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/super.c | 12 ++++++++++++
>>   fs/ceph/super.h |  1 +
>>   2 files changed, 13 insertions(+)
>>
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index 2f530a111b3a..6f283e4d62ee 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -159,6 +159,7 @@ enum {
>>   	Opt_quotadf,
>>   	Opt_copyfrom,
>>   	Opt_wsync,
>> +	Opt_sharesb,
>>   };
>>   
>>   enum ceph_recover_session_mode {
>> @@ -199,6 +200,7 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
>>   	fsparam_string	("source",			Opt_source),
>>   	fsparam_u32	("wsize",			Opt_wsize),
>>   	fsparam_flag_no	("wsync",			Opt_wsync),
>> +	fsparam_flag_no	("sharesb",			Opt_sharesb),
>>   	{}
>>   };
>>   
>> @@ -455,6 +457,12 @@ static int ceph_parse_mount_param(struct fs_context *fc,
>>   		else
>>   			fsopt->flags |= CEPH_MOUNT_OPT_ASYNC_DIROPS;
>>   		break;
>> +	case Opt_sharesb:
>> +		if (!result.negated)
>> +			fsopt->flags &= ~CEPH_MOUNT_OPT_NO_SHARE_SB;
>> +		else
>> +			fsopt->flags |= CEPH_MOUNT_OPT_NO_SHARE_SB;
>> +		break;
>>   	default:
>>   		BUG();
>>   	}
>> @@ -1007,6 +1015,10 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
>>   
>>   	dout("ceph_compare_super %p\n", sb);
>>   
>> +	if (fsopt->flags & CEPH_MOUNT_OPT_NO_SHARE_SB ||
>> +	    other->mount_options->flags & CEPH_MOUNT_OPT_NO_SHARE_SB)
>> +		return 0;
>> +
>>   	if (compare_mount_options(fsopt, opt, other)) {
>>   		dout("monitor(s)/mount options don't match\n");
>>   		return 0;
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index f097237a5ad3..e877c21196e5 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -44,6 +44,7 @@
>>   #define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in statfs */
>>   #define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'copy-from' op */
>>   #define CEPH_MOUNT_OPT_ASYNC_DIROPS    (1<<15) /* allow async directory ops */
>> +#define CEPH_MOUNT_OPT_NO_SHARE_SB     (1<<16) /* disable sharing the same superblock */
>>   
>>   #define CEPH_MOUNT_OPT_DEFAULT			\
>>   	(CEPH_MOUNT_OPT_DCACHE |		\


